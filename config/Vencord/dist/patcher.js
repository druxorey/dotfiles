// Vencord 3d46f19
// Standalone: true
// Platform: Universal
// Updater Disabled: false
"use strict";var en=Object.create;var Ee=Object.defineProperty;var tn=Object.getOwnPropertyDescriptor;var rn=Object.getOwnPropertyNames;var nn=Object.getPrototypeOf,on=Object.prototype.hasOwnProperty;var d=(e,t)=>()=>(e&&(t=e(e=0)),t);var he=(e,t)=>{for(var r in t)Ee(e,r,{get:t[r],enumerable:!0})},gt=(e,t,r,n)=>{if(t&&typeof t=="object"||typeof t=="function")for(let i of rn(t))!on.call(e,i)&&i!==r&&Ee(e,i,{get:()=>t[i],enumerable:!(n=tn(t,i))||n.enumerable});return e};var Ge=(e,t,r)=>(r=e!=null?en(nn(e)):{},gt(t||!e||!e.__esModule?Ee(r,"default",{value:e,enumerable:!0}):r,e)),Ne=e=>gt(Ee({},"__esModule",{value:!0}),e);var l=d(()=>{"use strict"});var de=d(()=>{"use strict";l()});var me,Me=d(()=>{l();me="3d46f19"});var ee,Ue=d(()=>{l();ee="Vendicated/Vencord"});var yt,wt=d(()=>{"use strict";l();Me();Ue();yt=`Vencord/${me}${ee?` (https://github.com/${ee})`:""}`});function te(e,t={}){return new Promise((r,n)=>{St.default.get(e,t,i=>{let{statusCode:o,statusMessage:a,headers:s}=i;if(o>=400)return void n(`${o}: ${a} - ${e}`);if(o>=300)return void r(te(s.location,t));let c=[];i.on("error",n),i.on("data",u=>c.push(u)),i.once("end",()=>r(Buffer.concat(c)))})})}var St,ze=d(()=>{"use strict";l();St=Ge(require("https"))});function ve(e){return async function(){try{return{ok:!0,value:await e(...arguments)}}catch(t){return{ok:!1,error:t instanceof Error?{...t}:t}}}}var Tt,xt=d(()=>{"use strict";l();Tt=["patcher.js","preload.js","renderer.js","renderer.css"]});var ln={};async function At(e){return te(an+e,{headers:{Accept:"application/vnd.github+json","User-Agent":yt}})}async function sn(){if(!await It())return[];let t=await At(`/compare/${me}...HEAD`);return JSON.parse(t.toString("utf-8")).commits.map(n=>({hash:n.sha.slice(0,7),author:n.author.login,message:n.commit.message.split(`
`)[0]}))}async function It(){let e=await At("/releases/latest"),t=JSON.parse(e.toString());return t.name.slice(t.name.lastIndexOf(" ")+1)===me?!1:(t.assets.forEach(({name:n,browser_download_url:i})=>{Tt.some(o=>n.startsWith(o))&&We.push([n,i])}),!0)}async function cn(){return await Promise.all(We.map(async([e,t])=>(0,Et.writeFile)((0,Dt.join)(__dirname,e),await te(t)))),We=[],!0}var ge,Et,Dt,an,We,Pt=d(()=>{"use strict";l();de();wt();ge=require("electron"),Et=require("fs/promises"),Dt=require("path");Me();Ue();ze();xt();an=`https://api.github.com/repos/${ee}`,We=[];ge.ipcMain.handle("VencordGetRepo",ve(()=>`https://github.com/${ee}`));ge.ipcMain.handle("VencordGetUpdates",ve(sn));ge.ipcMain.handle("VencordUpdate",ve(It));ge.ipcMain.handle("VencordBuild",ve(cn))});var Rt=d(()=>{"use strict";l();Pt()});var Ze={};he(Ze,{fetchTrackData:()=>fn});async function je(e){let{stdout:t}=await Lt("osascript",e.map(r=>["-e",r]).flat());return t}function bt(e,t){let r=new URL("https://tools.applemediaservices.com/api/apple-media/music/US/search.json");return r.searchParams.set("types",e),r.searchParams.set("limit","1"),r.searchParams.set("term",t),r}async function un({id:e,name:t,artist:r,album:n}){if(e===b?.id){if("data"in b)return b.data;if("failures"in b&&b.failures>=5)return null}try{let[i,o]=await Promise.all([fetch(bt("songs",r+" "+n+" "+t),Ot).then(f=>f.json()),fetch(bt("artists",r.split(/ *[,&] */)[0]),Ot).then(f=>f.json())]),a=i?.songs?.data[0]?.attributes.url,s=i?.songs?.data[0]?.id?`https://song.link/i/${i?.songs?.data[0]?.id}`:void 0,c=i?.songs?.data[0]?.attributes.artwork.url.replace("{w}","512").replace("{h}","512"),u=o?.artists?.data[0]?.attributes.artwork.url.replace("{w}","512").replace("{h}","512");return b={id:e,data:{appleMusicLink:a,songLink:s,albumArtwork:c,artistArtwork:u}},b.data}catch(i){return console.error("[AppleMusicRichPresence] Failed to fetch remote data:",i),b={id:e,failures:(e===b?.id&&"failures"in b?b.failures:0)+1},null}}async function fn(){try{await Lt("pgrep",["^Music$"])}catch{return null}if(await je(['tell application "Music"',"get player state","end tell"]).then(f=>f.trim())!=="playing")return null;let t=await je(['tell application "Music"',"get player position","end tell"]).then(f=>Number.parseFloat(f.trim())),r=await je(['set output to ""','tell application "Music"',"set t_id to database id of current track","set t_name to name of current track","set t_album to album of current track","set t_artist to artist of current track","set t_duration to duration of current track",'set output to "" & t_id & "\\n" & t_name & "\\n" & t_album & "\\n" & t_artist & "\\n" & t_duration',"end tell","return output"]),[n,i,o,a,s]=r.split(`
`).filter(f=>!!f),c=Number.parseFloat(s),u=await un({id:n,name:i,artist:a,album:o});return{name:i,album:o,artist:a,playerPosition:t,duration:c,...u}}var _t,kt,Lt,Ot,b,Ct=d(()=>{"use strict";l();_t=require("child_process"),kt=require("util"),Lt=(0,kt.promisify)(_t.execFile);Ot={headers:{"user-agent":"Mozilla/5.0 (Windows NT 10.0; rv:125.0) Gecko/20100101 Firefox/125.0"}},b=null});var He={};he(He,{initDevtoolsOpenEagerLoad:()=>pn});function pn(e){let t=()=>e.sender.executeJavaScript("Vencord.Plugins.plugins.ConsoleShortcuts.eagerLoad(true)");e.sender.isDevToolsOpened()?t():e.sender.once("devtools-opened",()=>t())}var Vt=d(()=>{"use strict";l()});var ye,Gt=d(()=>{"use strict";l();ye=class{pathListeners=new Map;globalListeners=new Set;constructor(t,r={}){this.plain=t,this.store=this.makeProxy(t),Object.assign(this,r)}makeProxy(t,r=t,n=""){let i=this;return new Proxy(t,{get(o,a){let s=o[a];return!(a in o)&&i.getDefaultValue&&(s=i.getDefaultValue({target:o,key:a,root:r,path:n})),typeof s=="object"&&s!==null&&!Array.isArray(s)?i.makeProxy(s,r,`${n}${n&&"."}${a}`):s},set(o,a,s){if(o[a]===s)return!0;Reflect.set(o,a,s);let c=`${n}${n&&"."}${a}`;return i.globalListeners.forEach(u=>u(s,c)),i.pathListeners.get(c)?.forEach(u=>u(s)),!0}})}setData(t,r){if(this.readOnly)throw new Error("SettingsStore is read-only");if(this.plain=t,this.store=this.makeProxy(t),r){let n=t,i=r.split(".");for(let o of i){if(!n){console.warn(`Settings#setData: Path ${r} does not exist in new data. Not dispatching update`);return}n=n[o]}this.pathListeners.get(r)?.forEach(o=>o(n))}this.markAsChanged()}addGlobalChangeListener(t){this.globalListeners.add(t)}addChangeListener(t,r){let n=this.pathListeners.get(t)??new Set;n.add(r),this.pathListeners.set(t,n)}removeGlobalChangeListener(t){this.globalListeners.delete(t)}removeChangeListener(t,r){let n=this.pathListeners.get(t);!n||(n.delete(r),n.size||this.pathListeners.delete(t))}markAsChanged(){this.globalListeners.forEach(t=>t(this.plain,""))}}});function Be(e,t){for(let r in t){let n=t[r];typeof n=="object"&&!Array.isArray(n)?(e[r]??={},Be(e[r],n)):e[r]??=n}return e}var Nt=d(()=>{"use strict";l()});var Mt,U,De,re,z,ne,Ye,Je,Ut,Ae,ie=d(()=>{"use strict";l();Mt=require("electron"),U=require("path"),De=process.env.VENCORD_USER_DATA_DIR??(process.env.DISCORD_USER_DATA_DIR?(0,U.join)(process.env.DISCORD_USER_DATA_DIR,"..","VencordData"):(0,U.join)(Mt.app.getPath("userData"),"..","Vencord")),re=(0,U.join)(De,"settings"),z=(0,U.join)(De,"themes"),ne=(0,U.join)(re,"quickCss.css"),Ye=(0,U.join)(re,"settings.json"),Je=(0,U.join)(re,"native-settings.json"),Ut=["https:","http:","steam:","spotify:","com.epicgames.launcher:","tidal:"],Ae=process.argv.includes("--vanilla")});function Wt(e,t){try{return JSON.parse((0,H.readFileSync)(t,"utf-8"))}catch(r){return r?.code!=="ENOENT"&&console.error(`Failed to read ${e} settings`,r),{}}}var Ie,H,x,hn,Ft,zt,B=d(()=>{"use strict";l();de();Gt();Nt();Ie=require("electron"),H=require("fs");ie();(0,H.mkdirSync)(re,{recursive:!0});x=new ye(Wt("renderer",Ye));x.addGlobalChangeListener(()=>{try{(0,H.writeFileSync)(Ye,JSON.stringify(x.plain,null,4))}catch(e){console.error("Failed to write renderer settings",e)}});Ie.ipcMain.handle("VencordGetSettingsDir",()=>re);Ie.ipcMain.on("VencordGetSettings",e=>e.returnValue=x.plain);Ie.ipcMain.handle("VencordSetSettings",(e,t,r)=>{x.setData(t,r)});hn={plugins:{}},Ft=Wt("native",Je);Be(Ft,hn);zt=new ye(Ft);zt.addGlobalChangeListener(()=>{try{(0,H.writeFileSync)(Je,JSON.stringify(zt.plain,null,4))}catch(e){console.error("Failed to write native settings",e)}})});var Zt={};var jt,Ht=d(()=>{"use strict";l();B();jt=require("electron");jt.app.on("browser-window-created",(e,t)=>{t.webContents.on("frame-created",(r,{frame:n})=>{n.once("dom-ready",()=>{if(n.url.startsWith("https://open.spotify.com/embed/")){let i=x.store.plugins?.FixSpotifyEmbeds;if(!i?.enabled)return;n.executeJavaScript(`
                    const original = Audio.prototype.play;
                    Audio.prototype.play = function() {
                        this.volume = ${i.volume/100||.1};
                        return original.apply(this, arguments);
                    }
                `)}})})})});var Yt={};var Bt,Jt=d(()=>{"use strict";l();B();Bt=require("electron");Bt.app.on("browser-window-created",(e,t)=>{t.webContents.on("frame-created",(r,{frame:n})=>{n.once("dom-ready",()=>{if(n.url.startsWith("https://www.youtube.com/")){if(!x.store.plugins?.FixYoutubeEmbeds?.enabled)return;n.executeJavaScript(`
                new MutationObserver(() => {
                    if(
                        document.querySelector('div.ytp-error-content-wrap-subreason a[href*="www.youtube.com/watch?v="]')
                    ) location.reload()
                }).observe(document.body, { childList: true, subtree:true });
                `)}})})})});var Ke={};he(Ke,{resolveRedirect:()=>mn});function qt(e){return new Promise((t,r)=>{let n=(0,Kt.request)(new URL(e),{method:"HEAD"},i=>{t(i.headers.location?qt(i.headers.location):e)});n.on("error",r),n.end()})}async function mn(e,t){return dn.test(t)?qt(t):t}var Kt,dn,$t=d(()=>{"use strict";l();Kt=require("https"),dn=/^https:\/\/(spotify\.link|s\.team)\/.+$/});var qe={};he(qe,{readRecording:()=>vn});async function vn(e,t){t=(0,we.normalize)(t);let r=(0,we.basename)(t),n=(0,we.normalize)(Xt.app.getPath("userData")+"/");if(console.log(r,n,t),r!=="recording.ogg"||!t.startsWith(n))return null;try{let i=await(0,Qt.readFile)(t);return new Uint8Array(i.buffer)}catch{return null}}var Xt,Qt,we,er=d(()=>{"use strict";l();Xt=require("electron"),Qt=require("fs/promises"),we=require("path")});var tr,rr=d(()=>{l();tr=`"use strict";const LOGO_ID="block-youtube-ads-logo",hiddenCSS=["#__ffYoutube1","#__ffYoutube2","#__ffYoutube3","#__ffYoutube4","#feed-pyv-container","#feedmodule-PRO","#homepage-chrome-side-promo","#merch-shelf","#offer-module",'#pla-shelf > ytd-pla-shelf-renderer[class="style-scope ytd-watch"]',"#pla-shelf","#premium-yva","#promo-info","#promo-list","#promotion-shelf","#related > ytd-watch-next-secondary-results-renderer > #items > ytd-compact-promoted-video-renderer.ytd-watch-next-secondary-results-renderer","#search-pva","#shelf-pyv-container","#video-masthead","#watch-branded-actions","#watch-buy-urls","#watch-channel-brand-div","#watch7-branded-banner","#YtKevlarVisibilityIdentifier","#YtSparklesVisibilityIdentifier",".carousel-offer-url-container",".companion-ad-container",".GoogleActiveViewElement",'.list-view[style="margin: 7px 0pt;"]',".promoted-sparkles-text-search-root-container",".promoted-videos",".searchView.list-view",".sparkles-light-cta",".watch-extra-info-column",".watch-extra-info-right",".ytd-carousel-ad-renderer",".ytd-compact-promoted-video-renderer",".ytd-companion-slot-renderer",".ytd-merch-shelf-renderer",".ytd-player-legacy-desktop-watch-ads-renderer",".ytd-promoted-sparkles-text-search-renderer",".ytd-promoted-video-renderer",".ytd-search-pyv-renderer",".ytd-video-masthead-ad-v3-renderer",".ytp-ad-action-interstitial-background-container",".ytp-ad-action-interstitial-slot",".ytp-ad-image-overlay",".ytp-ad-overlay-container",".ytp-ad-progress",".ytp-ad-progress-list",'[class*="ytd-display-ad-"]','[layout*="display-ad-"]','a[href^="http://www.youtube.com/cthru?"]','a[href^="https://www.youtube.com/cthru?"]',"ytd-action-companion-ad-renderer","ytd-banner-promo-renderer","ytd-compact-promoted-video-renderer","ytd-companion-slot-renderer","ytd-display-ad-renderer","ytd-promoted-sparkles-text-search-renderer","ytd-promoted-sparkles-web-renderer","ytd-search-pyv-renderer","ytd-single-option-survey-renderer","ytd-video-masthead-ad-advertiser-info-renderer","ytd-video-masthead-ad-v3-renderer","YTM-PROMOTED-VIDEO-RENDERER"],hideElements=()=>{const e=hiddenCSS;if(!e)return;const t=e.join(", ")+" { display: none!important; }",r=document.createElement("style");r.innerHTML=t,document.head.appendChild(r)},observeDomChanges=e=>{new MutationObserver(r=>{e(r)}).observe(document.documentElement,{childList:!0,subtree:!0})},hideDynamicAds=()=>{const e=document.querySelectorAll("#contents > ytd-rich-item-renderer ytd-display-ad-renderer");e.length!==0&&e.forEach(t=>{if(t.parentNode&&t.parentNode.parentNode){const r=t.parentNode.parentNode;r.localName==="ytd-rich-item-renderer"&&(r.style.display="none")}})},autoSkipAds=()=>{if(document.querySelector(".ad-showing")){const e=document.querySelector("video");e&&e.duration&&(e.currentTime=e.duration,setTimeout(()=>{const t=document.querySelector("button.ytp-ad-skip-button");t&&t.click()},100))}},overrideObject=(e,t,r)=>{if(!e)return!1;let n=!1;for(const o in e)e.hasOwnProperty(o)&&o===t?(e[o]=r,n=!0):e.hasOwnProperty(o)&&typeof e[o]=="object"&&overrideObject(e[o],t,r)&&(n=!0);return n},jsonOverride=(e,t)=>{const r=JSON.parse;JSON.parse=(...o)=>{const d=r.apply(this,o);return overrideObject(d,e,t),d};const n=Response.prototype.json;Response.prototype.json=new Proxy(n,{apply(...o){const d=Reflect.apply(...o);return new Promise((s,i)=>{d.then(a=>{overrideObject(a,e,t),s(a)}).catch(a=>i(a))})}})},addAdGuardLogoStyle=()=>{},addAdGuardLogo=()=>{if(document.getElementById(LOGO_ID))return;const e=document.createElement("span");if(e.innerHTML="__logo_text__",e.setAttribute("id",LOGO_ID),window.location.hostname==="m.youtube.com"){const t=document.querySelector("header.mobile-topbar-header > button");t&&(t.parentNode?.insertBefore(e,t.nextSibling),addAdGuardLogoStyle())}else if(window.location.hostname==="www.youtube.com"){const t=document.getElementById("country-code");t&&(t.innerHTML="",t.appendChild(e),addAdGuardLogoStyle())}else if(window.location.hostname==="music.youtube.com"){const t=document.querySelector(".ytmusic-nav-bar#left-content");t&&(t.appendChild(e),addAdGuardLogoStyle())}else if(window.location.hostname==="www.youtube-nocookie.com"){const t=document.querySelector("#yt-masthead #logo-container .content-region");t&&(t.innerHTML="",t.appendChild(e),addAdGuardLogoStyle())}};jsonOverride("adPlacements",[]),jsonOverride("playerAds",[]),hideElements(),addAdGuardLogo(),hideDynamicAds(),autoSkipAds(),observeDomChanges(()=>{addAdGuardLogo(),hideDynamicAds(),autoSkipAds()});
`});var ir={};var nr,or=d(()=>{"use strict";l();B();nr=require("electron");rr();nr.app.on("browser-window-created",(e,t)=>{t.webContents.on("frame-created",(r,{frame:n})=>{n.once("dom-ready",()=>{if(n.url.includes("discordsays")&&n.url.includes("youtube.com")){if(!x.store.plugins?.WatchTogetherAdblock?.enabled)return;n.executeJavaScript(tr)}})})})});var $e={};he($e,{sendToOverlay:()=>gn});function gn(e,t){t.icon=Buffer.from(t.icon).toString("base64");let r=JSON.stringify(t);ar??=(0,sr.createSocket)("udp4"),ar.send(r,42069,"127.0.0.1")}var sr,ar,cr=d(()=>{"use strict";l();sr=require("dgram")});var lr,ur=d(()=>{l();Ct();Vt();Ht();Jt();$t();er();or();cr();lr={AppleMusicRichPresence:Ze,ConsoleShortcuts:He,FixSpotifyEmbeds:Zt,FixYoutubeEmbeds:Yt,OpenInApp:Ke,VoiceMessages:qe,WatchTogetherAdblock:ir,XSOverlay:$e}});var Xe,fr,pr=d(()=>{"use strict";l();de();Xe=require("electron");ur();fr={};for(let[e,t]of Object.entries(lr)){let r=Object.entries(t);if(!r.length)continue;let n=fr[e]={};for(let[i,o]of r){let a=`VencordPluginNative_${e}_${i}`;Xe.ipcMain.handle(a,o),n[i]=a}}Xe.ipcMain.on("VencordGetPluginIpcMethodMap",e=>{e.returnValue=fr})});function Qe(e,t=300){let r;return function(...n){clearTimeout(r),r=setTimeout(()=>{e(...n)},t)}}var hr=d(()=>{"use strict";l()});var dr,mr=d(()=>{l();dr="PCFkb2N0eXBlIGh0bWw+PGh0bWwgbGFuZz0iZW4iPjxoZWFkPjxtZXRhIGNoYXJzZXQ9InV0Zi04Ij48dGl0bGU+VmVuY29yZCBRdWlja0NTUyBFZGl0b3I8L3RpdGxlPjxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9jZG4uanNkZWxpdnIubmV0L25wbS9tb25hY28tZWRpdG9yQDAuNTAuMC9taW4vdnMvZWRpdG9yL2VkaXRvci5tYWluLmNzcyIgaW50ZWdyaXR5PSJzaGEyNTYtdGlKUFEyTzA0ei9wWi9Bd2R5SWdock9NemV3ZitQSXZFbDFZS2JRdnNaaz0iIGNyb3Nzb3JpZ2luPSJhbm9ueW1vdXMiIHJlZmVycmVycG9saWN5PSJuby1yZWZlcnJlciI+PHN0eWxlPiNjb250YWluZXIsYm9keSxodG1se3Bvc2l0aW9uOmFic29sdXRlO2xlZnQ6MDt0b3A6MDt3aWR0aDoxMDAlO2hlaWdodDoxMDAlO21hcmdpbjowO3BhZGRpbmc6MDtvdmVyZmxvdzpoaWRkZW59PC9zdHlsZT48L2hlYWQ+PGJvZHk+PGRpdiBpZD0iY29udGFpbmVyIj48L2Rpdj48c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG4uanNkZWxpdnIubmV0L25wbS9tb25hY28tZWRpdG9yQDAuNTAuMC9taW4vdnMvbG9hZGVyLmpzIiBpbnRlZ3JpdHk9InNoYTI1Ni1LY1U0OFRHcjg0cjd1bkY3SjVJZ0JvOTVhZVZyRWJyR2UwNFM3VGNGVWpzPSIgY3Jvc3NvcmlnaW49ImFub255bW91cyIgcmVmZXJyZXJwb2xpY3k9Im5vLXJlZmVycmVyIj48L3NjcmlwdD48c2NyaXB0PnJlcXVpcmUuY29uZmlnKHtwYXRoczp7dnM6Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbW9uYWNvLWVkaXRvckAwLjUwLjAvbWluL3ZzIn19KSxyZXF1aXJlKFsidnMvZWRpdG9yL2VkaXRvci5tYWluIl0sKCgpPT57Z2V0Q3VycmVudENzcygpLnRoZW4oKGU9Pnt2YXIgdD1tb25hY28uZWRpdG9yLmNyZWF0ZShkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgiY29udGFpbmVyIikse3ZhbHVlOmUsbGFuZ3VhZ2U6ImNzcyIsdGhlbWU6Z2V0VGhlbWUoKX0pO3Qub25EaWRDaGFuZ2VNb2RlbENvbnRlbnQoKCgpPT5zZXRDc3ModC5nZXRWYWx1ZSgpKSkpLHdpbmRvdy5hZGRFdmVudExpc3RlbmVyKCJyZXNpemUiLCgoKT0+e3QubGF5b3V0KCl9KSl9KSl9KSk8L3NjcmlwdD48L2JvZHk+PC9odG1sPg=="});function et(e,t={}){return{fileName:e,name:t.name??e.replace(/\.css$/i,""),author:t.author??"Unknown Author",description:t.description??"A Discord Theme.",version:t.version,license:t.license,source:t.source,website:t.website,invite:t.invite}}function vr(e){return e.charCodeAt(0)===65279&&(e=e.slice(1)),e}function gr(e,t){if(!e)return et(t);let r=e.split("/**",2)?.[1]?.split("*/",1)?.[0];if(!r)return et(t);let n={},i="",o="";for(let a of r.split(yn))if(a.length!==0)if(a.charAt(0)==="@"&&a.charAt(1)!==" "){n[i]=o.trim();let s=a.indexOf(" ");i=a.substring(1,s),o=a.substring(s+1)}else o+=" "+a.replace("\\n",`
`).replace(wn,"@");return n[i]=o.trim(),delete n[""],et(t,n)}var yn,wn,yr=d(()=>{"use strict";l();yn=/[^\S\r\n]*?\r?(?:\r\n|\n)[^\S\r\n]*?\*[^\S\r\n]?/,wn=/^\\@/});function Sr(e){e.webContents.setWindowOpenHandler(({url:t})=>{switch(t){case"about:blank":case"https://discord.com/popout":case"https://ptb.discord.com/popout":case"https://canary.discord.com/popout":return{action:"allow"}}try{var{protocol:r}=new URL(t)}catch{return{action:"deny"}}switch(r){case"http:":case"https:":case"mailto:":case"steam:":case"spotify:":wr.shell.openExternal(t)}return{action:"deny"}})}var wr,Tr=d(()=>{"use strict";l();wr=require("electron")});function tt(e,t){let r=(0,oe.normalize)(e),n=(0,oe.join)(e,t),i=(0,oe.normalize)(n);return i.startsWith(r)?i:null}function xr(){return(0,J.readFile)(ne,"utf-8").catch(()=>"")}async function Sn(){let e=await(0,J.readdir)(z).catch(()=>[]),t=[];for(let r of e){if(!r.endsWith(".css"))continue;let n=await Er(r).then(vr).catch(()=>null);n!=null&&t.push(gr(n,r))}return t}function Er(e){e=e.replace(/\?v=\d+$/,"");let t=tt(z,e);return t?(0,J.readFile)(t,"utf-8"):Promise.reject(`Unsafe path ${e}`)}function Dr(e){let t;(0,J.open)(ne,"a+").then(n=>{n.close(),t=(0,Y.watch)(ne,{persistent:!1},Qe(async()=>{e.webContents.postMessage("VencordQuickCssUpdate",await xr())},50))}).catch(()=>{});let r=(0,Y.watch)(z,{persistent:!1},Qe(()=>{e.webContents.postMessage("VencordThemeUpdate",void 0)}));e.once("closed",()=>{t?.close(),r.close()})}var v,Y,J,oe,rt=d(()=>{"use strict";l();Rt();pr();B();hr();de();v=require("electron");mr();Y=require("fs"),J=require("fs/promises"),oe=require("path");yr();ie();Tr();(0,Y.mkdirSync)(z,{recursive:!0});v.ipcMain.handle("VencordOpenQuickCss",()=>v.shell.openPath(ne));v.ipcMain.handle("VencordOpenExternal",(e,t)=>{try{var{protocol:r}=new URL(t)}catch{throw"Malformed URL"}if(!Ut.includes(r))throw"Disallowed protocol.";v.shell.openExternal(t)});v.ipcMain.handle("VencordGetQuickCss",()=>xr());v.ipcMain.handle("VencordSetQuickCss",(e,t)=>(0,Y.writeFileSync)(ne,t));v.ipcMain.handle("VencordGetThemesDir",()=>z);v.ipcMain.handle("VencordGetThemesList",()=>Sn());v.ipcMain.handle("VencordGetThemeData",(e,t)=>Er(t));v.ipcMain.handle("VencordGetThemeSystemValues",()=>({"os-accent-color":`#${v.systemPreferences.getAccentColor?.()||""}`}));v.ipcMain.handle("VencordOpenMonacoEditor",async()=>{let e="Vencord QuickCSS Editor",t=v.BrowserWindow.getAllWindows().find(n=>n.title===e);if(t&&!t.isDestroyed()){t.focus();return}let r=new v.BrowserWindow({title:e,autoHideMenuBar:!0,darkTheme:!0,webPreferences:{preload:(0,oe.join)(__dirname,"preload.js"),contextIsolation:!0,nodeIntegration:!1,sandbox:!1}});Sr(r),await r.loadURL(`data:text/html;base64,${dr}`)})});function Br(e,t,r){let n=t;if(t in e)return void r(e[n]);Object.defineProperty(e,t,{set(i){delete e[n],e[n]=i,r(i)},configurable:!0,enumerable:!1})}var Yr=d(()=>{"use strict";l()});var Fn={};function zn(e,t){let r=e.slice(4).split(".").map(Number),n=t.slice(4).split(".").map(Number);for(let i=0;i<n.length;i++){if(r[i]>n[i])return!0;if(r[i]<n[i])return!1}return!1}function Wn(){if(!process.env.DISABLE_UPDATER_AUTO_PATCHING)try{let e=(0,P.dirname)(process.execPath),t=(0,P.basename)(e),r=(0,P.join)(e,".."),n=(0,D.readdirSync)(r).reduce((s,c)=>c.startsWith("app-")&&zn(c,s)?c:s,t);if(n===t)return;let i=(0,P.join)(r,n,"resources"),o=(0,P.join)(i,"app.asar"),a=(0,P.join)(i,"_app.asar");if(!(0,D.existsSync)(o)||(0,D.statSync)(o).isDirectory())return;console.info("[Vencord] Detected Host Update. Repatching..."),(0,D.renameSync)(o,a),(0,D.mkdirSync)(o),(0,D.writeFileSync)((0,P.join)(o,"package.json"),JSON.stringify({name:"discord",main:"index.js"})),(0,D.writeFileSync)((0,P.join)(o,"index.js"),`require(${JSON.stringify((0,P.join)(__dirname,"patcher.js"))});`)}catch(e){console.error("[Vencord] Failed to repatch latest host update",e)}}var Jr,D,P,Kr=d(()=>{"use strict";l();Jr=require("electron"),D=require("original-fs"),P=require("path");Jr.app.on("before-quit",Wn)});var Bn={};var S,F,jn,Zn,ut,Hn,qr=d(()=>{"use strict";l();Yr();S=Ge(require("electron")),F=require("path");rt();B();ie();console.log("[Vencord] Starting up...");jn=require.main.filename,Zn=require.main.path.endsWith("app.asar")?"_app.asar":"app.asar",ut=(0,F.join)((0,F.dirname)(jn),"..",Zn),Hn=require((0,F.join)(ut,"package.json"));require.main.filename=(0,F.join)(ut,Hn.main);S.app.setAppPath(ut);if(Ae)console.log("[Vencord] Running in vanilla mode. Not loading Vencord");else{let e=x.store;if(process.platform==="win32"&&(Kr(),e.winCtrlQ)){let i=S.Menu.buildFromTemplate;S.Menu.buildFromTemplate=function(o){if(o[0]?.label==="&File"){let{submenu:a}=o[0];Array.isArray(a)&&a.push({label:"Quit (Hidden)",visible:!1,acceleratorWorksWhenHidden:!0,accelerator:"Control+Q",click:()=>S.app.quit()})}return i.call(this,o)}}class t extends S.default.BrowserWindow{constructor(o){if(o?.webPreferences?.preload&&o.title){let a=o.webPreferences.preload;o.webPreferences.preload=(0,F.join)(__dirname,"preload.js"),o.webPreferences.sandbox=!1,o.webPreferences.backgroundThrottling=!1,e.frameless?o.frame=!1:process.platform==="win32"&&e.winNativeTitleBar&&delete o.frame,e.transparent&&(o.transparent=!0,o.backgroundColor="#00000000"),process.platform==="darwin"&&e.macosVibrancyStyle&&(o.backgroundColor="#00000000",e.macosVibrancyStyle&&(o.vibrancy=e.macosVibrancyStyle)),process.env.DISCORD_PRELOAD=a,super(o),Dr(this)}else super(o)}}Object.assign(t,S.default.BrowserWindow),Object.defineProperty(t,"name",{value:"BrowserWindow",configurable:!0});let r=require.resolve("electron");delete require.cache[r].exports,require.cache[r].exports={...S.default,BrowserWindow:t},Br(global,"appSettings",i=>{i.set("DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING",!0),e.disableMinSize?(i.set("MIN_WIDTH",0),i.set("MIN_HEIGHT",0)):(i.set("MIN_WIDTH",940),i.set("MIN_HEIGHT",500))}),process.env.DATA_DIR=(0,F.join)(S.app.getPath("userData"),"..","Vencord");let n=S.app.commandLine.appendSwitch;S.app.commandLine.appendSwitch=function(...i){if(i[0]==="disable-features"){let o=new Set((i[1]??"").split(","));o.add("WidgetLayering"),o.add("UseEcoQoSForBackgroundProcess"),i[1]+=[...o].join(",")}return n.apply(this,i)},S.app.commandLine.appendSwitch("disable-renderer-backgrounding"),S.app.commandLine.appendSwitch("disable-background-timer-throttling"),S.app.commandLine.appendSwitch("disable-backgrounding-occluded-windows")}console.log("[Vencord] Loading original Discord app.asar");require(require.main.filename)});l();var K=require("electron"),$r=require("path");rt();B();ie();l();var jr=require("electron");l();var Pr=require("module"),Tn=(0,Pr.createRequire)("/"),Re,xn=";var __w=require('worker_threads');__w.parentPort.on('message',function(m){onmessage({data:m})}),postMessage=function(m,t){__w.parentPort.postMessage(m,t)},close=process.exit;self=global";try{Re=Tn("worker_threads").Worker}catch{}var En=Re?function(e,t,r,n,i){var o=!1,a=new Re(e+xn,{eval:!0}).on("error",function(s){return i(s,null)}).on("message",function(s){return i(null,s)}).on("exit",function(s){s&&!o&&i(new Error("exited with code "+s),null)});return a.postMessage(r,n),a.terminate=function(){return o=!0,Re.prototype.terminate.call(a)},a}:function(e,t,r,n,i){setImmediate(function(){return i(new Error("async operations unsupported - update to Node 12+ (or Node 10-11 with the --experimental-worker CLI flag)"),null)});var o=function(){};return{terminate:o,postMessage:o}},T=Uint8Array,W=Uint16Array,ot=Uint32Array,at=new T([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0,0]),st=new T([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,0,0]),Rr=new T([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15]),br=function(e,t){for(var r=new W(31),n=0;n<31;++n)r[n]=t+=1<<e[n-1];for(var i=new ot(r[30]),n=1;n<30;++n)for(var o=r[n];o<r[n+1];++o)i[o]=o-r[n]<<5|n;return[r,i]},Or=br(at,2),ct=Or[0],Dn=Or[1];ct[28]=258,Dn[258]=28;var _r=br(st,0),kr=_r[0],go=_r[1],_e=new W(32768);for(m=0;m<32768;++m)C=(m&43690)>>>1|(m&21845)<<1,C=(C&52428)>>>2|(C&13107)<<2,C=(C&61680)>>>4|(C&3855)<<4,_e[m]=((C&65280)>>>8|(C&255)<<8)>>>1;var C,m,ae=function(e,t,r){for(var n=e.length,i=0,o=new W(t);i<n;++i)e[i]&&++o[e[i]-1];var a=new W(t);for(i=0;i<t;++i)a[i]=a[i-1]+o[i-1]<<1;var s;if(r){s=new W(1<<t);var c=15-t;for(i=0;i<n;++i)if(e[i])for(var u=i<<4|e[i],f=t-e[i],g=a[e[i]-1]++<<f,R=g|(1<<f)-1;g<=R;++g)s[_e[g]>>>c]=u}else for(s=new W(n),i=0;i<n;++i)e[i]&&(s[i]=_e[a[e[i]-1]++]>>>15-e[i]);return s},Se=new T(288);for(m=0;m<144;++m)Se[m]=8;var m;for(m=144;m<256;++m)Se[m]=9;var m;for(m=256;m<280;++m)Se[m]=7;var m;for(m=280;m<288;++m)Se[m]=8;var m,Lr=new T(32);for(m=0;m<32;++m)Lr[m]=5;var m;var Cr=ae(Se,9,1);var Vr=ae(Lr,5,1),be=function(e){for(var t=e[0],r=1;r<e.length;++r)e[r]>t&&(t=e[r]);return t},I=function(e,t,r){var n=t/8|0;return(e[n]|e[n+1]<<8)>>(t&7)&r},Oe=function(e,t){var r=t/8|0;return(e[r]|e[r+1]<<8|e[r+2]<<16)>>(t&7)},Gr=function(e){return(e+7)/8|0},ke=function(e,t,r){(t==null||t<0)&&(t=0),(r==null||r>e.length)&&(r=e.length);var n=new(e.BYTES_PER_ELEMENT==2?W:e.BYTES_PER_ELEMENT==4?ot:T)(r-t);return n.set(e.subarray(t,r)),n};var Nr=["unexpected EOF","invalid block type","invalid length/literal","invalid distance","stream finished","no stream handler",,"no callback","invalid UTF-8 data","extra field too long","date not in range 1980-2099","filename too long","stream finishing","invalid zip data"],E=function(e,t,r){var n=new Error(t||Nr[e]);if(n.code=e,Error.captureStackTrace&&Error.captureStackTrace(n,E),!r)throw n;return n},Mr=function(e,t,r){var n=e.length;if(!n||r&&r.f&&!r.l)return t||new T(0);var i=!t||r,o=!r||r.i;r||(r={}),t||(t=new T(n*3));var a=function(dt){var mt=t.length;if(dt>mt){var vt=new T(Math.max(mt*2,dt));vt.set(t),t=vt}},s=r.f||0,c=r.p||0,u=r.b||0,f=r.l,g=r.d,R=r.m,V=r.n,ce=n*8;do{if(!f){s=I(e,c,1);var j=I(e,c+1,3);if(c+=3,j)if(j==1)f=Cr,g=Vr,R=9,V=5;else if(j==2){var N=I(e,c,31)+257,q=I(e,c+10,15)+4,le=N+I(e,c+5,31)+1;c+=14;for(var Z=new T(le),ue=new T(19),w=0;w<q;++w)ue[Rr[w]]=I(e,c+w*3,7);c+=q*3;for(var L=be(ue),Te=(1<<L)-1,$=ae(ue,L,1),w=0;w<le;){var fe=$[I(e,c,Te)];c+=fe&15;var y=fe>>>4;if(y<16)Z[w++]=y;else{var X=0,xe=0;for(y==16?(xe=3+I(e,c,3),c+=2,X=Z[w-1]):y==17?(xe=3+I(e,c,7),c+=3):y==18&&(xe=11+I(e,c,127),c+=7);xe--;)Z[w++]=X}}var ft=Z.subarray(0,N),M=Z.subarray(N);R=be(ft),V=be(M),f=ae(ft,R,1),g=ae(M,V,1)}else E(1);else{var y=Gr(c)+4,A=e[y-4]|e[y-3]<<8,G=y+A;if(G>n){o&&E(0);break}i&&a(u+A),t.set(e.subarray(y,G),u),r.b=u+=A,r.p=c=G*8,r.f=s;continue}if(c>ce){o&&E(0);break}}i&&a(u+131072);for(var Xr=(1<<R)-1,Qr=(1<<V)-1,Le=c;;Le=c){var X=f[Oe(e,c)&Xr],Q=X>>>4;if(c+=X&15,c>ce){o&&E(0);break}if(X||E(2),Q<256)t[u++]=Q;else if(Q==256){Le=c,f=null;break}else{var pt=Q-254;if(Q>264){var w=Q-257,pe=at[w];pt=I(e,c,(1<<pe)-1)+ct[w],c+=pe}var Ce=g[Oe(e,c)&Qr],Ve=Ce>>>4;Ce||E(3),c+=Ce&15;var M=kr[Ve];if(Ve>3){var pe=st[Ve];M+=Oe(e,c)&(1<<pe)-1,c+=pe}if(c>ce){o&&E(0);break}i&&a(u+131072);for(var ht=u+pt;u<ht;u+=4)t[u]=t[u-M],t[u+1]=t[u+1-M],t[u+2]=t[u+2-M],t[u+3]=t[u+3-M];u=ht}}r.l=f,r.p=Le,r.b=u,r.f=s,f&&(s=1,r.m=R,r.d=g,r.n=V)}while(!s);return u==t.length?t:ke(t,0,u)};var An=new T(0);var In=function(e,t){var r={};for(var n in e)r[n]=e[n];for(var n in t)r[n]=t[n];return r},Ar=function(e,t,r){for(var n=e(),i=e.toString(),o=i.slice(i.indexOf("[")+1,i.lastIndexOf("]")).replace(/\s+/g,"").split(","),a=0;a<n.length;++a){var s=n[a],c=o[a];if(typeof s=="function"){t+=";"+c+"=";var u=s.toString();if(s.prototype)if(u.indexOf("[native code]")!=-1){var f=u.indexOf(" ",8)+1;t+=u.slice(f,u.indexOf("(",f))}else{t+=u;for(var g in s.prototype)t+=";"+c+".prototype."+g+"="+s.prototype[g].toString()}else t+=u}else r[c]=s}return[t,r]},Pe=[],Pn=function(e){var t=[];for(var r in e)e[r].buffer&&t.push((e[r]=new e[r].constructor(e[r])).buffer);return t},Rn=function(e,t,r,n){var i;if(!Pe[r]){for(var o="",a={},s=e.length-1,c=0;c<s;++c)i=Ar(e[c],o,a),o=i[0],a=i[1];Pe[r]=Ar(e[s],o,a)}var u=In({},Pe[r][1]);return En(Pe[r][0]+";onmessage=function(e){for(var k in e.data)self[k]=e.data[k];onmessage="+t.toString()+"}",r,u,Pn(u),n)},bn=function(){return[T,W,ot,at,st,Rr,ct,kr,Cr,Vr,_e,Nr,ae,be,I,Oe,Gr,ke,E,Mr,lt,Ur,zr]};var Ur=function(e){return postMessage(e,[e.buffer])},zr=function(e){return e&&e.size&&new T(e.size)},On=function(e,t,r,n,i,o){var a=Rn(r,n,i,function(s,c){a.terminate(),o(s,c)});return a.postMessage([e,t],t.consume?[e.buffer]:[]),function(){a.terminate()}};var _=function(e,t){return e[t]|e[t+1]<<8},O=function(e,t){return(e[t]|e[t+1]<<8|e[t+2]<<16|e[t+3]<<24)>>>0},nt=function(e,t){return O(e,t)+O(e,t+4)*4294967296};function _n(e,t,r){return r||(r=t,t={}),typeof r!="function"&&E(7),On(e,t,[bn],function(n){return Ur(lt(n.data[0],zr(n.data[1])))},1,r)}function lt(e,t){return Mr(e,t)}var it=typeof TextDecoder<"u"&&new TextDecoder,kn=0;try{it.decode(An,{stream:!0}),kn=1}catch{}var Ln=function(e){for(var t="",r=0;;){var n=e[r++],i=(n>127)+(n>223)+(n>239);if(r+i>e.length)return[t,ke(e,r-1)];i?i==3?(n=((n&15)<<18|(e[r++]&63)<<12|(e[r++]&63)<<6|e[r++]&63)-65536,t+=String.fromCharCode(55296|n>>10,56320|n&1023)):i&1?t+=String.fromCharCode((n&31)<<6|e[r++]&63):t+=String.fromCharCode((n&15)<<12|(e[r++]&63)<<6|e[r++]&63):t+=String.fromCharCode(n)}};function Cn(e,t){if(t){for(var r="",n=0;n<e.length;n+=16384)r+=String.fromCharCode.apply(null,e.subarray(n,n+16384));return r}else{if(it)return it.decode(e);var i=Ln(e),o=i[0],a=i[1];return a.length&&E(8),o}}var Vn=function(e,t){return t+30+_(e,t+26)+_(e,t+28)},Gn=function(e,t,r){var n=_(e,t+28),i=Cn(e.subarray(t+46,t+46+n),!(_(e,t+8)&2048)),o=t+46+n,a=O(e,t+20),s=r&&a==4294967295?Nn(e,o):[a,O(e,t+24),O(e,t+42)],c=s[0],u=s[1],f=s[2];return[_(e,t+10),c,u,i,o+_(e,t+30)+_(e,t+32),f]},Nn=function(e,t){for(;_(e,t)!=1;t+=4+_(e,t+2));return[nt(e,t+12),nt(e,t+4),nt(e,t+20)]};var Ir=typeof queueMicrotask=="function"?queueMicrotask:typeof setTimeout=="function"?setTimeout:function(e){e()};function Wr(e,t,r){r||(r=t,t={}),typeof r!="function"&&E(7);var n=[],i=function(){for(var y=0;y<n.length;++y)n[y]()},o={},a=function(y,A){Ir(function(){r(y,A)})};Ir(function(){a=r});for(var s=e.length-22;O(e,s)!=101010256;--s)if(!s||e.length-s>65558)return a(E(13,0,1),null),i;var c=_(e,s+8);if(c){var u=c,f=O(e,s+16),g=f==4294967295||u==65535;if(g){var R=O(e,s-12);g=O(e,R)==101075792,g&&(u=c=O(e,R+32),f=O(e,R+48))}for(var V=t&&t.filter,ce=function(y){var A=Gn(e,f,g),G=A[0],N=A[1],q=A[2],le=A[3],Z=A[4],ue=A[5],w=Vn(e,ue);f=Z;var L=function($,fe){$?(i(),a($,null)):(fe&&(o[le]=fe),--c||a(null,o))};if(!V||V({name:le,size:N,originalSize:q,compression:G}))if(!G)L(null,ke(e,w,w+N));else if(G==8){var Te=e.subarray(w,w+N);if(N<32e4)try{L(null,lt(Te,new T(q)))}catch($){L($,null)}else n.push(_n(Te,{size:q},L))}else L(E(14,"unknown compression type "+G,1),null);else L(null,null)},j=0;j<u;++j)ce(j)}else a(null,{});return i}var Zr=require("fs"),k=require("fs/promises"),se=require("path");ie();l();function Fr(e){function t(a,s,c,u){let f=0;return f+=a<<0,f+=s<<8,f+=c<<16,f+=u<<24>>>0,f}if(e[0]===80&&e[1]===75&&e[2]===3&&e[3]===4)return e;if(e[0]!==67||e[1]!==114||e[2]!==50||e[3]!==52)throw new Error("Invalid header: Does not start with Cr24");let r=e[4]===3,n=e[4]===2;if(!n&&!r||e[5]||e[6]||e[7])throw new Error("Unexpected crx format version number.");if(n){let a=t(e[8],e[9],e[10],e[11]),s=t(e[12],e[13],e[14],e[15]),c=16+a+s;return e.subarray(c,e.length)}let o=12+t(e[8],e[9],e[10],e[11]);return e.subarray(o,e.length)}ze();var Mn=(0,se.join)(De,"ExtensionCache");async function Un(e,t){return await(0,k.mkdir)(t,{recursive:!0}),new Promise((r,n)=>{Wr(e,(i,o)=>{if(i)return void n(i);Promise.all(Object.keys(o).map(async a=>{if(a.startsWith("_metadata/"))return;if(a.endsWith("/"))return void(0,k.mkdir)((0,se.join)(t,a),{recursive:!0});let s=a.split("/"),c=s.pop(),u=s.join("/"),f=(0,se.join)(t,u);u&&await(0,k.mkdir)(f,{recursive:!0}),await(0,k.writeFile)((0,se.join)(f,c),o[a])})).then(()=>r()).catch(a=>{(0,k.rm)(t,{recursive:!0,force:!0}),n(a)})})})}async function Hr(e){let t=(0,se.join)(Mn,`${e}`);try{await(0,k.access)(t,Zr.constants.F_OK)}catch{let n=e==="fmkadmapgofadopljbjfkapdkoienihi"?"https://raw.githubusercontent.com/Vendicated/random-files/f6f550e4c58ac5f2012095a130406c2ab25b984d/fmkadmapgofadopljbjfkapdkoienihi.zip":`https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&x=id%3D${e}%26uc&prodversion=32`,i=await te(n,{headers:{"User-Agent":"Vencord (https://github.com/Vendicated/Vencord)"}});await Un(Fr(i),t).catch(console.error)}jr.session.defaultSession.loadExtension(t)}Ae||K.app.whenReady().then(()=>{K.protocol.registerFileProtocol("vencord",({url:i},o)=>{let a=i.slice(10);if(a.endsWith("/")&&(a=a.slice(0,-1)),a.startsWith("/themes/")){let s=a.slice(8),c=tt(z,s);if(!c){o({statusCode:403});return}o(c.replace(/\?v=\d+$/,""));return}switch(a){case"renderer.js.map":case"vencordDesktopRenderer.js.map":case"preload.js.map":case"vencordDesktopPreload.js.map":case"patcher.js.map":case"vencordDesktopMain.js.map":o((0,$r.join)(__dirname,a));break;default:o({statusCode:403})}});try{x.store.enableReactDevtools&&Hr("fmkadmapgofadopljbjfkapdkoienihi").then(()=>console.info("[Vencord] Installed React Developer Tools")).catch(i=>console.error("[Vencord] Failed to install React Developer Tools",i))}catch{}let e=(i,o)=>Object.keys(i).find(a=>a.toLowerCase()===o),t=i=>{let o={};return i.split(";").forEach(a=>{let[s,...c]=a.trim().split(/\s+/g);s&&!Object.prototype.hasOwnProperty.call(o,s)&&(o[s]=c)}),o},r=i=>Object.entries(i).filter(([,o])=>o?.length).map(o=>o.flat().join(" ")).join("; "),n=i=>{let o=e(i,"content-security-policy");if(o){let a=t(i[o][0]);for(let s of["style-src","connect-src","img-src","font-src","media-src","worker-src"])a[s]??=[],a[s].push("*","blob:","data:","vencord:","'unsafe-inline'");a["script-src"]??=[],a["script-src"].push("'unsafe-eval'","https://unpkg.com","https://cdnjs.cloudflare.com"),i[o]=[r(a)]}};K.session.defaultSession.webRequest.onHeadersReceived(({responseHeaders:i,resourceType:o},a)=>{if(i&&(o==="mainFrame"&&n(i),o==="stylesheet")){let s=e(i,"content-type");s&&(i[s]=["text/css"])}a({cancel:!1,responseHeaders:i})}),K.session.defaultSession.webRequest.onHeadersReceived=()=>{}});qr();
//# sourceURL=VencordPatcher
//# sourceMappingURL=vencord://patcher.js.map
/*! For license information please see patcher.js.LEGAL.txt */
