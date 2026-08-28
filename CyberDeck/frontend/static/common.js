window.CD = {

token:
sessionStorage.getItem(
    "cyberdeck_token"
),

async api(url,options={}){

    options.headers=
        options.headers || {};

    if(this.token){

        options.headers[
            "Authorization"
        ]=
            "Bearer "
            + this.token;
    }

    const response=
        await fetch(
            url,
            options
        );

    if(
        response.status===401
        && location.pathname!=="/"
        && location.pathname!=="/invite"
    ){

        sessionStorage.removeItem(
            "cyberdeck_token"
        );

        location="/";

        throw new Error(
            "unauthorized"
        );
    }

    return response;
},

fmtBytes(value){

    value=Number(value||0);

    if(value>=1073741824)
        return(
            value/1073741824
        ).toFixed(2)+" GB";

    if(value>=1048576)
        return(
            value/1048576
        ).toFixed(2)+" MB";

    if(value>=1024)
        return(
            value/1024
        ).toFixed(2)+" KB";

    return value+" B";
},

fmtUptime(seconds){

    seconds=Number(
        seconds||0
    );

    const d=Math.floor(
        seconds/86400
    );

    const h=Math.floor(
        (seconds%86400)/3600
    );

    const m=Math.floor(
        (seconds%3600)/60
    );

    return `${d}d ${h}h ${m}m`;
},

async download(url,name){

    const response=
        await this.api(url);

    if(!response.ok){

        const data=
            await response.json()
            .catch(()=>({}));

        alert(
            data.detail
            || "download failed"
        );

        return;
    }

    const blob=
        await response.blob();

    const objectUrl=
        URL.createObjectURL(blob);

    const a=
        document.createElement(
            "a"
        );

    a.href=objectUrl;
    a.download=name;
    a.click();

    URL.revokeObjectURL(
        objectUrl
    );
}

};

if(
    !CD.token
    && location.pathname!=="/"
    && location.pathname!=="/invite"
){

    location="/";
}
