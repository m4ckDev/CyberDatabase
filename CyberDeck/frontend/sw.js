const CACHE="cyberdeck-static-v2";

const STATIC=[
"/",
"/static/cyberdeck.css",
"/static/common.js",
"/manifest.webmanifest"
];

self.addEventListener("install",event=>{

event.waitUntil(
caches.open(CACHE)
.then(cache=>cache.addAll(STATIC))
.then(()=>self.skipWaiting())
);

});


self.addEventListener("activate",event=>{

event.waitUntil(
caches.keys()
.then(keys=>Promise.all(
keys
.filter(key=>key!==CACHE)
.map(key=>caches.delete(key))
))
.then(()=>self.clients.claim())
);

});


self.addEventListener("fetch",event=>{

const request=event.request;

if(request.method!=="GET"){
return;
}

const url=new URL(request.url);

if(url.origin!==location.origin){
return;
}

if(url.pathname.startsWith("/api/")){
return;
}

if(
url.pathname.startsWith("/static/")
|| url.pathname==="/manifest.webmanifest"
){

event.respondWith(
caches.match(request)
.then(cached=>{
return cached || fetch(request).then(response=>{

const copy=response.clone();

caches.open(CACHE)
.then(cache=>cache.put(request,copy));

return response;
});
})
);

return;
}


if(request.mode==="navigate"){

event.respondWith(
fetch(request)
.catch(()=>caches.match("/"))
);

}

});
