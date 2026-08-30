window.CD = {

token: sessionStorage.getItem("cyberdeck_token"),

modules: [
["dashboard","/dashboard"],
["network","/network"],
["machines","/machines"],
["tools","/tools"],
["terminal","/terminal"],
["chats","/chats"],
["labs","/labs"],
["jobs","/jobs"],
["captures","/captures"],
["assets","/assets"],
["learn","/learn"],
["files","/files"],
["notes","/notes"],
["notifications","/notifications"],
["logs","/logs"],
["search","/search"],
["system","/system"],
["settings","/settings"],
["install","/install"]
],

async api(url,options={}){

this.token=sessionStorage.getItem("cyberdeck_token");

options.headers=options.headers || {};

if(this.token){
options.headers["Authorization"]="Bearer "+this.token;
}

const response=await fetch(url,options);

if(
response.status===401
&& location.pathname!=="/"
&& location.pathname!=="/invite"
){
sessionStorage.removeItem("cyberdeck_token");
location="/";
throw new Error("unauthorized");
}

return response;
},

async json(url,options={}){

const response=await this.api(url,options);

let data={};

try{
data=await response.json();
}catch(e){}

if(!response.ok){
throw new Error(data.detail || ("request failed: "+response.status));
}

return data;
},

fmtBytes(value){

value=Number(value||0);

if(value>=1073741824)
return (value/1073741824).toFixed(2)+" GB";

if(value>=1048576)
return (value/1048576).toFixed(2)+" MB";

if(value>=1024)
return (value/1024).toFixed(2)+" KB";

return value+" B";
},

fmtUptime(seconds){

seconds=Number(seconds||0);

const d=Math.floor(seconds/86400);
const h=Math.floor((seconds%86400)/3600);
const m=Math.floor((seconds%3600)/60);

return `${d}d ${h}h ${m}m`;
},

escape(value){

const div=document.createElement("div");
div.textContent=String(value ?? "");
return div.innerHTML;
},

async download(url,name){

const response=await this.api(url);

if(!response.ok){

const data=await response.json().catch(()=>({}));

this.toast(
data.detail || "download failed"
);

return;
}

const blob=await response.blob();
const objectUrl=URL.createObjectURL(blob);
const a=document.createElement("a");

a.href=objectUrl;
a.download=name;
a.click();

URL.revokeObjectURL(objectUrl);
},

toast(message){

let box=document.getElementById("cd-toast");

if(!box){
box=document.createElement("div");
box.id="cd-toast";
box.className="cd-toast";
document.body.appendChild(box);
}

box.textContent=message;
box.classList.add("show");

clearTimeout(this._toastTimer);

this._toastTimer=setTimeout(()=>{
box.classList.remove("show");
},2600);
},

logout(){

sessionStorage.removeItem("cyberdeck_token");
location="/";
},

pref(name,defaultValue=null){

const value=localStorage.getItem("cd_"+name);
return value===null ? defaultValue : value;
},

setPref(name,value){

localStorage.setItem("cd_"+name,String(value));
},

applyPreferences(){

document.body.classList.toggle(
"compact",
this.pref("compact","0")==="1"
);
},

installOfflineIndicator(){

let banner=document.getElementById("cd-offline");

if(!banner){
banner=document.createElement("div");
banner.id="cd-offline";
banner.className="cd-offline";
banner.textContent="network connection unavailable";
document.body.appendChild(banner);
}

const update=()=>{
banner.classList.toggle("show",!navigator.onLine);
};

window.addEventListener("online",update);
window.addEventListener("offline",update);

update();
},

async installHealth(){

if(
location.pathname==="/"
|| location.pathname==="/invite"
){
return;
}

const header=document.querySelector("header");

if(!header || document.getElementById("cd-health")){
return;
}

const chip=document.createElement("span");

chip.id="cd-health";
chip.textContent="api ...";

header.appendChild(chip);

try{

const health=await this.json("/api/health");

chip.textContent=
health.status==="online"
? "api online"
: "api "+health.status;

chip.classList.toggle(
"online",
health.status==="online"
);

}catch(e){

chip.textContent="api offline";
}
},

installPalette(){

if(
location.pathname==="/"
|| location.pathname==="/invite"
){
return;
}

const overlay=document.createElement("div");
overlay.className="cd-palette";
overlay.id="cd-palette";

overlay.innerHTML=`
<div class="cd-palette-card">
<input
id="cd-palette-input"
autocomplete="off"
placeholder="jump to module..."
>
<div id="cd-command-list" class="cd-command-list"></div>
</div>
`;

document.body.appendChild(overlay);

const input=document.getElementById("cd-palette-input");
const list=document.getElementById("cd-command-list");

let filtered=[...this.modules];
let selected=0;

const draw=()=>{

const q=input.value.trim().toLowerCase();

filtered=this.modules.filter(
item=>item[0].includes(q)
);

if(selected>=filtered.length){
selected=0;
}

list.innerHTML="";

filtered.forEach((item,index)=>{

const row=document.createElement("div");

row.className=
"cd-command"+
(index===selected ? " active" : "");

const name=document.createElement("span");
name.textContent=item[0];

const key=document.createElement("span");
key.className="cd-key";
key.textContent=item[1];

row.appendChild(name);
row.appendChild(key);

row.onclick=()=>{
location=item[1];
};

list.appendChild(row);
});
};

const open=()=>{

overlay.classList.add("open");
input.value="";
selected=0;
draw();

setTimeout(()=>input.focus(),0);
};

const close=()=>{
overlay.classList.remove("open");
};

input.addEventListener("input",()=>{
selected=0;
draw();
});

input.addEventListener("keydown",event=>{

if(event.key==="ArrowDown"){
event.preventDefault();
selected=Math.min(selected+1,filtered.length-1);
draw();
}

if(event.key==="ArrowUp"){
event.preventDefault();
selected=Math.max(selected-1,0);
draw();
}

if(event.key==="Enter" && filtered[selected]){
location=filtered[selected][1];
}

if(event.key==="Escape"){
close();
}
});

overlay.addEventListener("click",event=>{
if(event.target===overlay){
close();
}
});

document.addEventListener("keydown",event=>{

const tag=(document.activeElement?.tagName || "").toLowerCase();

const typing=
tag==="input"
|| tag==="textarea"
|| tag==="select";

if(
(event.ctrlKey || event.metaKey)
&& event.key.toLowerCase()==="k"
){
event.preventDefault();
open();
return;
}

if(event.key==="/" && !typing){
event.preventDefault();
open();
}

if(event.key==="Escape"){
close();
}
});

draw();
},

registerSW(){

if("serviceWorker" in navigator){
navigator.serviceWorker.register("/sw.js").catch(()=>{});
}
},

init(){

this.applyPreferences();
this.installOfflineIndicator();
this.installHealth();
this.installPalette();
this.registerSW();
}

};

if(
!CD.token
&& location.pathname!=="/"
&& location.pathname!=="/invite"
){
location="/";
}

document.addEventListener(
"DOMContentLoaded",
()=>CD.init()
);
