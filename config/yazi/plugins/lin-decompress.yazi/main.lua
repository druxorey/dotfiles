-- Debugger
local IS_DEBUG = false
local function dmsg(msg)
	if IS_DEBUG then
		ya.dbg(msg)
	end
end
-- Sync Helpers
local function tabs_to_table(tabs)
	local t = {}
	for i = 1, #tabs do
		table.insert(t, tabs[i])
	end
	return t
end
-- Syncs
local get_configs = ya.sync(function(state)
	return state.config
end)
local get_files = ya.sync(function(state, args)
	local tabs, paths = {}, {}
	if args.tabselect then
		if args.tabselect == "all" then
			tabs = tabs_to_table(cx.tabs)
		elseif args.tabselect == "active" or args.tabselect == "current" then
			table.insert(tabs, cx.active)
		end
		for _, tab in pairs(tabs) do
			for _, url in pairs(tab.selected) do
				table.insert(paths, tostring(url.path))
			end
		end
	end
	if not args.no_hover then
		table.insert(paths, tostring(cx.active.current.hovered.url.path))
	end
	return paths
end)
-- Notify Users
local function alert(msg, opts)
	opts = opts or {}
	ya.notify({
		title = "lin-decompress",
		content = msg,
		timeout = opts.timeout or 10,
		level = opts.level or "info",
	})
end
-- Create directory
local function create_dir(dir_path)
	local is_successful, error = fs.create("dir_all", Url(dir_path))
	if not is_successful then
		alert("Unable to create directory -> " .. dir_path, { level = "error" })
		ya.err(tostring(error))
	end
	return is_successful
end
-- Ask User
local function ask(msg, default, opts)
	opts = opts or {}
	local width = opts.width or 40
	local y = opts.y or 10
	local should_fail = opts.should_fail and true or false
	local should_hide = opts.obscure and true or false
	local value, event = ya.input({
		pos = { "top-center", x = -width + 10, y = y, w = width },
		title = msg,
		value = default,
		obscure = should_hide,
		realtime = false,
		debounce = 0.3,
	})
	dmsg("Asked: '" .. msg .. "'")
	if should_fail or not value then
		error("Error occurred when asking user: '" .. msg .. "'")
	end
	return value
end
-- Ask encryption credential
local function ask_cred()
	return ask("Password?: (Stop asking[!!!])", "", { obscure = true })
end
-- Ask User output directory
local function ask_output(path)
	local url = Url(path)
	local parent_dir = url.parent
	local extract_dir = ask("Directory to extract ALL archives?", tostring(parent_dir))
	return extract_dir
end
-- Variables
local cmd_options = {}
local global_tar_cmd = {}
local tar_cmd = {
	["tar"] = {
		tool_name = "tar",
		cmd = { "--overwrite" },
		in_cmd = "-xf",
		out_cmd = "-C",
		sub_cmd = "-I",
	},
}
local archive_cmds = {}
-- Strip content from mime-type
local function strip_type(str)
	local f_index, _ = string.find(str, ":")
	local file_type = string.sub(str, f_index + 1 or 1)
	file_type = string.gsub(file_type, "\n", "")
	file_type = string.gsub(file_type, "%s", "")
	return file_type
end
-- Identify filetype
local function get_type(path)
	dmsg("Getting type for Path: " .. path)
	local output, err = Command("file"):arg("--mime-type"):arg(path):output()
	if err then
		alert("Unable to get mimetype for -> " .. path, { level = "error" })
		ya.err(tostring(err))
		return nil
	end
	return strip_type(output.stdout)
end
-- Get tar archive commands
local function get_tar_cmds_by_mime(mimetype)
	for archive_name, cmd in pairs(tar_cmd) do
		if string.find(mimetype, archive_name) then
			return { is_tar_type = true, cmds = cmd }
		end
	end
	return {}
end
local function get_tar_cmds_by_ext(ext)
	for _, cmd in pairs(tar_cmd) do
		if cmd.exts[ext] then
			return { is_tar_type = true, cmds = cmd }
		end
	end
	return {}
end
-- Get other archive type commands
local function get_other_cmds_by_mime(mimetype)
	for archive_name, cmd in pairs(archive_cmds) do
		if string.find(mimetype, archive_name) then
			return { cmds = cmd }
		end
	end
	return { cmds = archive_cmds["default"] }
end
local function get_other_cmds_by_ext(ext)
	for _, cmd in pairs(archive_cmds) do
		if cmd.exts[ext] then
			return { cmds = cmd }
		end
	end
	return { cmds = archive_cmds["default"] }
end
-- Get commands for archive by extension
local function get_cmds_by_ext(ext)
	local cmds = get_tar_cmds_by_ext(ext)
	if cmds.is_tar_type then
		return cmds
	end
	return get_other_cmds_by_ext(ext)
end
-- Get commands for archive by mimetype
local function get_cmds_by_mime(mimetype)
	local cmds = get_tar_cmds_by_mime(mimetype)
	if cmds.is_tar_type then
		return cmds
	end
	return get_other_cmds_by_mime(mimetype)
end
-- Get commands for archive
local function get_cmds(mimetype, path)
	if string.find(mimetype, "octet-stream") then
		local ext = Url(path).ext
		return get_cmds_by_ext(ext)
	else
		return get_cmds_by_mime(mimetype)
	end
end
-- Is tool installed?
local function tool_exists(tool_name)
	local s = Command("which"):arg(tool_name):status()
	return s and s.code == 0
end
-- Selects an archive extract tool
local function get_tool(cmds)
	if tool_exists(cmds.tool_name) then
		return cmds
	end
	cmds.is_tar_type = false
	return archive_cmds["default"]
end
-- Concatenate two items to strings
local function str_concat(item1, item2)
	local result = ""
	for _, v in ipairs({ item1, item2 }) do
		if type(v) == "table" then
			result = string.format("%s %s", result, table.concat(v, " "))
		else
			if result == "" then
				result = v
			else
				result = result .. " " .. v
			end
		end
	end
	return string.gsub(result, "(%s%s)%s*", " ")
end
-- Add collection of arguments to a command
local function get_command_args(command, args)
	if args then
		for i, arg in ipairs(args) do
			command = command:arg(arg)
		end
	end
	return command
end
-- Remove extracted folder with the same name as parent. e.g. (foo/foo/)
local function remove_dup_dir(archive_dir)
	local archive_url = Url(archive_dir)
	local files, err = fs.read_dir(archive_url, { limit = 1 })
	if err then
		alert(err, { level = "error" })
		return
	end
	local file = files and files[1] or nil
	dmsg("Dup Suspect: " .. file.name)
	dmsg("Dup: " .. file.name .. " and " .. archive_url.name)
	if not file or not file.cha.is_dir or file.name ~= archive_url.name then
		dmsg("Directory does not contain duplicate at -> " .. archive_dir)
		return
	end
	local _, err2 = Command("sh"):arg("-c"):arg("mv " .. file.url.path .. "/* " .. archive_dir):output()
	if err2 then
		dmsg(err2)
		dmsg("Failed to move duplicate directory")
		return
	end
	fs.remove("dir", file.url)
end
-- Retrieve archive directory save location
local function get_archive_dir(inputs, path)
	local url = Url(path)
	local strip_tar_path = string.gsub(url.stem, "%.tar$", "", 1)
	local output_dir = Url(inputs.output)
	local archive_url = output_dir:join(strip_tar_path)
	return tostring(archive_url)
end
-- Retrieve extracted file url
local function get_extracted_file_url(inputs, path)
	local path_url = Url(path)
	local output_url = Url(inputs.output)
	local full_file_name = path_url.name or "file_name"
	local file_name_wo_archive_ext = string.gsub(full_file_name, ".%w+$", "", 1)
	return output_url:join(file_name_wo_archive_ext)
end
-- Basic extract command for tar
local function tar_command(path, tar_tool, archive_dir)
	local command = Command(tar_tool.tool_name)
	dmsg(tar_tool)
	-- Tar extract commands
	command = command:arg(tar_tool.in_cmd):arg(path)
	-- Tar flag commands
	command = get_command_args(command, tar_tool.cmd)
	-- Tar argument commands
	return command:arg(tar_tool.out_cmd):arg(archive_dir)
end
-- Extracts a .tar archive
local function tar_extract(path, tool_cmd, archive_dir)
	local command = tar_command(path, tool_cmd, archive_dir)
	local _, error = command:output()
	if error then
		alert("An error occurred extracting -> " .. path, { level = "error" })
		ya.err(tostring(error))
		fs.remove("dir_clean", Url(archive_dir))
	end
end
-- Extracts archives with tar.*
local function double_extract(path, tool_cmd, archive_dir)
	-- Tar flag commands
	local command = tar_command(path, tar_cmd["tar"], archive_dir)
	dmsg(tool_cmd)
	-- Sub compressor commands
	local compressor_cmds = tool_cmd.tool_name
	if tool_cmd.cmd then
		compressor_cmds = str_concat(compressor_cmds, tool_cmd.cmd) .. " "
	end
	-- Sub compressor global commands
	if not tool_cmd.no_global_tar then
		compressor_cmds = str_concat(compressor_cmds, global_tar_cmd.cmd)
	end
	local _, error = command:arg(tar_cmd["tar"].sub_cmd):arg(compressor_cmds):output()
	if error then
		alert("An error occurred extracting -> " .. path, { level = "error" })
		ya.err(tostring(error))
		fs.remove("dir_clean", Url(archive_dir))
	end
end
-- Extracts single tar related files (.lz,.zstd,etc)
local function tar_like_extract(path, tool_cmd, file_url)
	local command = Command(tool_cmd.tool_name)
	dmsg(tool_cmd)
	-- Compressor specific commands
	command = get_command_args(command, tool_cmd.cmd)
	-- Global compressor commands
	if not tool_cmd.no_global_tar then
		command = get_command_args(command, global_tar_cmd.cmd)
	end
	local output = command:arg(path):output()
	dmsg("File URL -> " .. tostring(file_url))
	local is_successful, error = fs.write(file_url, output.stdout)
	if not is_successful then
		alert("Unable to extract file -> " .. tostring(file_url), { level = "error" })
		ya.err(tostring(error))
		fs.remove("dir_clean", file_url.parent)
	end
end
-- Extracts other types of archives (zip,rar,7z,etc.)
local function other_extract(path, tool_cmd, archive_dir, inputs)
	dmsg(tool_cmd)
	local command = Command(tool_cmd.tool_name)
	command = get_command_args(command, tool_cmd.cmd)
	if tool_cmd.pw_cmd and inputs.cred ~= "!!!" and not cmd_options.no_password then
		inputs.cred = ask_cred()
		if inputs.cred and inputs.cred ~= "!!!" then
			local format_pw = string.format("%s%s", tool_cmd.pw_cmd, inputs.cred)
			command = command:arg(format_pw)
		end
	end
	local is_successful = create_dir(archive_dir)
	if not is_successful then
		return
	end
	local format_out = string.format("%s%s", tool_cmd.out_cmd, archive_dir)
	local _, error = command:arg(format_out):arg(path):stdout(Command.PIPED):output()
	if error then
		fs.remove("dir_clean", Url(archive_dir))
		alert("An error occurred extracting -> " .. path, { level = "error" })
		ya.err(tostring(error))
	end
end
-- Operate on a single file
local function decompress_file(path, mimetype, inputs)
	local cmds = get_cmds(mimetype, path)
	local tool_cmd = get_tool(cmds.cmds)
	dmsg("Chosen tool -> " .. tool_cmd.tool_name)
	local archive_dir = get_archive_dir(inputs, path)
	dmsg("Archive Dir -> " .. archive_dir)
	local skip_dup_removal = false
	if cmds.is_tar_type then
		if string.find(path, "%.tar%.", 1) then
			create_dir(archive_dir)
			dmsg("Extract type -> double")
			double_extract(path, tool_cmd, archive_dir)
		elseif string.find(path, "%.tar$", 1) then
			create_dir(archive_dir)
			dmsg("Extract type -> tar")
			tar_extract(path, tool_cmd, archive_dir)
		else
			create_dir(inputs.output)
			skip_dup_removal = true
			dmsg("Extract type -> tar-like")
			local file_url = get_extracted_file_url(inputs, path)
			tar_like_extract(path, tool_cmd, file_url)
		end
	else
		create_dir(archive_dir)
		dmsg("Extract type -> other")
		other_extract(path, tool_cmd, archive_dir, inputs)
	end
	if not skip_dup_removal then
		remove_dup_dir(archive_dir)
	end
end
-- Extract all archive files
local function decompress_files(paths)
	local inputs = {}
	alert("Attempting to extract " .. #paths .. " files", { timeout = 5 })
	for _, path in ipairs(paths) do
		local mimetype = get_type(path)
		dmsg(path .. ": " .. mimetype)
		if mimetype and not string.find(mimetype, "directory") then
			if not inputs.output then
				inputs.output = ask_output(path)
				dmsg("Ask Output directory -> " .. inputs.output)
			end
			decompress_file(path, mimetype, inputs)
		end
	end
	alert("Extraction process completed!")
end
-- Move table 1 into table 2
local function table_move(t1, t2)
	for k, v in pairs(t1) do
		t2[k] = v
	end
end
-- Setup Configurations
local function setup_vars()
	local configs = get_configs()
	global_tar_cmd = configs.global_tar_compressor
	table_move(configs.tar_compressors, tar_cmd)
	archive_cmds = configs.other_compressors
end
-- Entry point
local M = {}
function M:setup(state)
	self.config = state
end
function M:entry(job)
	setup_vars()
	cmd_options = job.args
	local paths = get_files(cmd_options)
	if #paths > 0 then
		decompress_files(paths)
	end
end
return M
