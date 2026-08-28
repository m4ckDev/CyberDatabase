const CACHE="cyberdeck-static-v1";

self.addEventListener(
"install",
event=>{
self.skipWaiting();
}
);

self.addEventListener(
"activate",
event=>{
event.waitUntil(
self.clients.claim()
);
}
);

self.addEventListener(
"fetch",
event=>{

const url=
new URL(
event.request.url
);

if(
event.request.method!=="GET"
|| url.pathname.startsWith(
"/api/"
)
){

return;
}

event.respondWith(
fetch(event.request)
.catch(
()=>caches.match(
event.request
)
)
);

}
);
