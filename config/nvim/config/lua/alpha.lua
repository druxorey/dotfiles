local present, alpha = pcall(require, "alpha")
if not present then
   return
end

alpha.setup(require'alpha.themes.theta'.config)
