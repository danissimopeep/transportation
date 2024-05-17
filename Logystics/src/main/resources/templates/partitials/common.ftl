<#import "navbar.ftl" as navbars>

<#macro page title>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
        <title>${title}</title>
    </head>
    <body>
    <#include "security.ftl">

    <#if isAuthorized>
        <#if isAdmin>
            <@navbars.adminNavbar/>
        <#else>  <#if isManager>
            <@navbars.managerNavbar/>
        <#else>
            <@navbars.clientNavbar/>
        </#if>
        </#if>
    <#else>
        <@navbars.notAuthorizedNavbar/>
    </#if>

    <#nested>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
    </body>
    </html>
</#macro>