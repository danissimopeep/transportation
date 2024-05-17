<#import "../partitials/common.ftl" as common>

<@common.page title="Управление компанией">
    <div class="container mt-5">
        <a class="btn btn-primary" href="/client/company/edit">Редактировать</a>
        <div class="row text-center">
            <h2>${company.name}</h2>
        </div>
    </div>
    <div class="container">
        <div class="row mt-5 text-center">
            <#if company.description??>
                <h5>${company.description}</h5>
            <#else>
                <h5>Здесь будет ваше описание.</h5>
            </#if>
        </div>
    </div>
    <div class="container">
        <div class="row mt-5">
            <h5>Контакты:</h5>
        </div>
        <div class="row mt-2">
            <h6>Email: ${company.email}</h6>
        </div>
        <div class="row mt-2">
            <h6>Телефон: ${company.telephone}</h6>
        </div>
        <div class="row mt-2">
            <h6>Адрес: ${company.address}</h6>
        </div>
    </div>
</@common.page>