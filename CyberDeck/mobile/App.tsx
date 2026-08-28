import React, {
  useEffect,
  useState
} from "react";

import {
  ActivityIndicator,
  Pressable,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View
} from "react-native";

import * as SecureStore
from "expo-secure-store";

import {
  StatusBar
} from "expo-status-bar";


const API =
"http://192.168.0.124:8000";


export default function App(){

const [token,setToken]=
useState<string|null>(null);

const [loading,setLoading]=
useState(true);

const [username,setUsername]=
useState("");

const [password,setPassword]=
useState("");

const [screen,setScreen]=
useState("dashboard");

const [output,setOutput]=
useState("");

const [target,setTarget]=
useState("");


useEffect(()=>{

SecureStore.getItemAsync(
"cyberdeck_token"
).then(value=>{

setToken(value);
setLoading(false);

});

},[]);


async function api(
path:string,
options:any={}
){

options.headers=
options.headers||{};

if(token){

options.headers.Authorization=
"Bearer "+token;
}

const response=
await fetch(
API+path,
options
);

if(response.status===401){

await SecureStore.deleteItemAsync(
"cyberdeck_token"
);

setToken(null);

throw new Error(
"unauthorized"
);
}

return response;
}


async function login(){

setOutput("logging in...");

try{

const response=
await fetch(
API+"/api/login",
{
method:"POST",
headers:{
"Content-Type":
"application/json"
},
body:JSON.stringify({
username,
password
})
}
);

const data=
await response.json();

if(!response.ok){

setOutput(
data.detail||
"login failed"
);

return;
}

await SecureStore.setItemAsync(
"cyberdeck_token",
data.access_token
);

setToken(
data.access_token
);

setPassword("");
setOutput("");

}catch(error){

setOutput(
"connection failed"
);

}
}


async function logout(){

await SecureStore.deleteItemAsync(
"cyberdeck_token"
);

setToken(null);
setScreen("dashboard");
setOutput("");

}


async function get(
path:string,
name:string
){

setScreen(name);
setOutput("loading...");

try{

const response=
await api(path);

const data=
await response.json();

setOutput(
JSON.stringify(
data,
null,
2
)
);

}catch(error){

setOutput(
String(error)
);

}
}


async function runTool(
action:string
){

if(!target.trim()){

setOutput(
"enter target"
);

return;
}

setOutput(
"running..."
);

const response=
await api(
"/api/toolbox/run",
{
method:"POST",
headers:{
"Content-Type":
"application/json"
},
body:JSON.stringify({
action,
target:target.trim()
})
}
);

const data=
await response.json();

setOutput(
response.ok
? data.output
: data.detail
);
}


if(loading){

return(
<SafeAreaView style={styles.root}>
<ActivityIndicator />
</SafeAreaView>
);
}


if(!token){

return(
<SafeAreaView style={styles.root}>

<StatusBar style="light"/>

<View style={styles.login}>

<Text style={styles.logo}>
CYBERDECK
</Text>

<TextInput
style={styles.input}
placeholder="username"
placeholderTextColor="#555"
autoCapitalize="none"
value={username}
onChangeText={setUsername}
/>

<TextInput
style={styles.input}
placeholder="password"
placeholderTextColor="#555"
secureTextEntry
value={password}
onChangeText={setPassword}
/>

<Pressable
style={styles.button}
onPress={login}
>
<Text style={styles.text}>
login
</Text>
</Pressable>

<Text style={styles.muted}>
{output}
</Text>

</View>

</SafeAreaView>
);
}


return(
<SafeAreaView style={styles.root}>

<StatusBar style="light"/>

<View style={styles.header}>

<Text style={styles.logo}>
CYBERDECK
</Text>

<Pressable onPress={logout}>
<Text style={styles.muted}>
logout
</Text>
</Pressable>

</View>

<ScrollView
contentContainerStyle={
styles.content
}
>

<TextInput
style={styles.input}
placeholder="target"
placeholderTextColor="#555"
autoCapitalize="none"
value={target}
onChangeText={setTarget}
/>

<View style={styles.grid}>

<Menu
label="system"
onPress={()=>
get(
"/api/system/status",
"system"
)}
/>

<Menu
label="network"
onPress={()=>
get(
"/api/network/status",
"network"
)}
/>

<Menu
label="labs"
onPress={()=>
get(
"/api/labs",
"labs"
)}
/>

<Menu
label="rooms"
onPress={()=>
get(
"/api/rooms",
"rooms"
)}
/>

<Menu
label="jobs"
onPress={()=>
get(
"/api/jobs",
"jobs"
)}
/>

<Menu
label="assets"
onPress={()=>
get(
"/api/assets",
"assets"
)}
/>

<Menu
label="quick nmap"
onPress={()=>
runTool(
"nmap_quick"
)}
/>

<Menu
label="services"
onPress={()=>
runTool(
"nmap_service"
)}
/>

<Menu
label="traceroute"
onPress={()=>
runTool(
"trace"
)}
/>

<Menu
label="ping"
onPress={()=>
runTool(
"ping"
)}
/>

</View>

<Text style={styles.section}>
{screen}
</Text>

<Text selectable
style={styles.output}>
{output}
</Text>

</ScrollView>

</SafeAreaView>
);
}


function Menu(
props:{
label:string,
onPress:()=>void
}
){

return(
<Pressable
style={styles.card}
onPress={props.onPress}
>
<Text style={styles.text}>
{props.label}
</Text>
</Pressable>
);
}

}


const styles=
StyleSheet.create({

root:{
flex:1,
backgroundColor:"#000"
},

login:{
flex:1,
justifyContent:"center",
padding:30
},

header:{
height:70,
paddingHorizontal:22,
borderBottomWidth:1,
borderBottomColor:"#181818",
flexDirection:"row",
alignItems:"center",
justifyContent:"space-between"
},

content:{
padding:22,
paddingBottom:80
},

logo:{
color:"#ddd",
fontFamily:"Courier",
letterSpacing:3,
fontSize:14
},

input:{
borderBottomWidth:1,
borderBottomColor:"#333",
color:"#ddd",
fontFamily:"Courier",
paddingVertical:12,
marginBottom:18
},

button:{
borderWidth:1,
borderColor:"#333",
padding:12,
marginTop:10
},

text:{
color:"#aaa",
fontFamily:"Courier"
},

muted:{
color:"#666",
fontFamily:"Courier",
marginTop:15
},

grid:{
flexDirection:"row",
flexWrap:"wrap",
gap:8
},

card:{
borderWidth:1,
borderColor:"#222",
padding:15,
minWidth:"46%"
},

section:{
color:"#666",
fontFamily:"Courier",
marginTop:30,
marginBottom:10
},

output:{
color:"#aaa",
fontFamily:"Courier",
lineHeight:18
}

});
