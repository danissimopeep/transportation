<#import "../partitials/common.ftl" as common>
<#import "../partitials/carousel.ftl" as carousels>

<@common.page title=tech.name>
    <div class="container mt-5">
        <div class="row g-2">
            <div class="col-7">
                <div class="row">
                    <#if images??>
                        <@carousels.carousel height=400 images=images/>
                    <#else>
                        <@carousels.carouselDefault height=400/>
                    </#if>
                </div>
            </div>

            <div class="col-4 offset-1">
                <div class="row">
                    <h2>${tech.name}</h2>
                </div>
                <div class="row mt-2">
                    <h6>${tech.cost} руб.</h6>
                </div>
                <div class="mt-2">
                    <a class="btn btn-primary" href="/admin/techs">Назад</a>
                </div>
                <div class="mt-2">
                    <a class="btn btn-primary" href="/admin/tech/edit/${tech.id}">Редактировать</a>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row mt-5 text-center">
            <#if description??>
                <h5>${description}</h5>
            <#else>
                <h5>Здесь будет ваше описание.</h5>
            </#if>
        </div>
    </div>
</@common.page>