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
                    <a class="btn btn-primary disabled" href="/admin/orders">Активные</a>
                </div>
                <div class="col-auto">
                    <a class="btn btn-secondary" href="/admin/history">История</a>
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
                    <th>ФИО</th>
                    <th>Компания</th>
                    <th>Дата заказа</th>
                    <th>Статус</th>
                    <th></th>
                    <th>Менеджер</th>
                    <th></th>
                </tr>
                </thead>
                <#list orders as o>
                    <tr>
                        <th class="col-1" scope="row">${o_index + 1}.</th>
                        <td class="col-2">${o.request.clientProfile.credentials}</td>
                        <td class="col-2">${o.request.clientProfile.company.name}</td>
                        <td class="col-1">${o.request.getLocalCreationDate()}</td>
                        <td class="col-1">${o.getStrStatus()}</td>
                        <td class="col-1"><a class="btn btn-primary" href="/admin/order/${o.id}">Подробнее</a></td>
                        <form method="post" id="managerForm" action="/admin/order/set-manager/${o.id}">
                            <td class="col-3">
                                <select class="form-select" name="managerId" id="managerInput" required aria-label="Менеджер">
                                    <#if o.managerProfile??>
                                        <option selected disabled value="${o.managerProfile.id}">${o.managerProfile.credentials}</option>
                                    <#else>
                                        <option selected disabled value="-1">Без менеджера</option>
                                    </#if>
                                    <#if managers??>
                                        <#list managers as m>
                                            <option value="${m.id}">${m.credentials}</option>
                                        </#list>
                                    </#if>
                                </select>
                            </td>
                            <td class="col-1">
                                <input type="button" onclick="validate()" class="btn btn-sm btn-primary" value="Обновить">
                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                            </td>
                        </form>
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

    <script>
        function validate(){
            var id = document.getElementById("managerInput").value;
            if(id=='-1'){
                document.getElementById("managerInput").classList.add("is-invalid");
                return;
            }
            else{
                document.getElementById("managerInput").classList.remove("is-invalid");
            }

            document.getElementById("managerForm").submit();
        }
    </script>
</@common.page>