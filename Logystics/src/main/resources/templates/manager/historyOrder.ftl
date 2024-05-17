<#import "../partitials/common.ftl" as common>

<@common.page title="Заказ">
    <div class="row mt-5">
        <div class="col text-center">
            <a class="btn btn-primary btn-sm" href="/manager/history">Назад</a>
            <h4>Заказ:</h4>
            <h6>Клиент: ${order.request.clientProfile.credentials}</h6>
            <h6>Телефон: ${order.request.clientProfile.telephone}</h6>
            <h6>Компания: ${order.request.clientProfile.company.name}</h6>
            <h6>Адрес: ${order.request.clientProfile.company.address}</h6>
            <h6>Email: ${order.request.clientProfile.company.email}</h6>
        </div>
    </div>

    <div class="container mt-3">
        <h5>Статус: ${order.status.getStrValue()}</h5>
        <h6>Описание: ${order.description}</h6>
    </div>

    <div class="container mt-3">
        <table class="table table-striped table-hover table-sm">
            <thead>
            <tr>
                <th>#</th>
                <th></th>
                <th>Название</th>
                <th>Тип</th>
                <th>Стоимость</th>
                <th>Количество</th>
                <th></th>
            </tr>
            </thead>
            <#list order.request.cardItems as t>
                <tr>
                    <th class="col-1" scope="row">${t_index + 1}.</th>
                    <td class="col-3">
                        <#if t.tech.getFirstImage()??>
                            <img src="/img/${t.tech.getFirstImage().path}" height="100" width="200">
                        <#else>
                            <img src="../../img/noimage.jpg" height="100" width="200">
                        </#if>
                    </td>
                    <td class="col-2">${t.tech.name}</td>
                    <td class="col-2">${t.tech.techType.name}</td>
                    <td class="col-1">${t.tech.cost} руб.</td>
                    <td class="col-2">${t.count}</td>
                    <td class="col-1"><a class="btn btn-primary btn-sm" href="/all/tech/${t.tech.id}">Подробнее</a></td>
                </tr>
            </#list>
        </table>

        <div class="row mt-5">
            <h4>
                Полная стоимость: ${order.request.getTotalCost()} руб.
            </h4>
        </div>
        <div class="row mt-5 text-center">
            <#if order.request.description??>
                <h5>${order.request.description}</h5>
            </#if>
        </div>

        <#if order.activeRequestCheckpoints??>
            <div class="mt-5">
                <table class="table table-striped table-hover table-sm">
                    <thead>
                        <tr>
                            <th>История:</th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                    </thead>
                    <#list order.activeRequestCheckpoints as t>
                        <tr>
                            <th class="col-1" scope="row">${t_index + 1}.</th>
                            <td class="col-2">${t.getLocalDate()}:</td>
                            <td class="col-2">Изменился из ${t.oldStatus.getStrValue()}</td>
                            <td class="col-2">на ${t.newStatus.getStrValue()}.</td>
                            <td class="col-2">${t.description}</td>
                        </tr>
                    </#list>
                </table>
            </div>
        </#if>

        <div class="mt-5">

        </div>
    </div>

    <script>
        function validate() {
            var text = document.getElementById("textInput").value;
            if(text.length > 1000){
                document.getElementById("textInput").classList.add("is-invalid");
                return;
            }
            else{
                document.getElementById("textInput").classList.remove("is-invalid");
            }

            document.getElementById("updateForm").submit();
        }
    </script>
</@common.page>