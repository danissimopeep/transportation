<#import "../partitials/common.ftl" as common>

<@common.page title="Управление аккаунтами">
    <div class="row mt-5">
        <div class="col text-center">
            <h4>Заказы:</h4>
        </div>
    </div>

    <div class="container">
        <div class="mt-3">
            <div class="row align-items-center justify-content-start">
                <div class="col-auto">
                    <a class="btn btn-primary disabled" href="/client/orders">Активные</a>
                </div>
                <div class="col-auto">
                    <a class="btn btn-secondary" href="/client/history">История</a>
                </div>
            </div>
        </div>
    </div>

    <#if orders??>
        <div class="container mt-3">

            <table class="table table-striped table-hover table-sm">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Дата заказа</th>
                    <th>Статус</th>
                    <th>Менеджер</th>
                    <th></th>
                </tr>
                </thead>
                <#list orders as o>
                    <tr>
                        <th class="col-1" scope="row">${o_index + 1}.</th>
                        <td class="col-1">${o.request.getLocalCreationDate()}</td>
                        <td class="col-1">${o.getStrStatus()}</td>
                        <td class="col-3">
                                <#if o.managerProfile??>
                                    ${o.managerProfile.credentials}
                                <#else>
                                    Без менеджера
                                </#if>
                        </td>
                        <td class="col-1"><a class="btn btn-primary" href="/client/order/${o.id}">Подробнее</a></td>
                    </tr>
                </#list>
            </table>
        </div>
    <#else>
        <div class="row mt-5">
            <div class="col text-center">
                <h6>Список заказов пуст</h6>
            </div>
        </div>
    </#if>
</@common.page>