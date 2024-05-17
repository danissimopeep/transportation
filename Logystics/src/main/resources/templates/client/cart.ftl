<#import "../partitials/common.ftl" as common>

<@common.page title="Заказ">
    <div class="row mt-5">
        <div class="col text-center">
            <h4>Заказ:</h4>
        </div>
    </div>

    <#if cartItems??>
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
                    <th></th>
                </tr>
                </thead>
                <#list cartItems as t>
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
                        <td class="col-2">
                            <div class="row">
                                <div class="col">
                                    <a class="btn btn-danger btn-sm" href="/client/cart/decrease/${t.tech.id}">-</a>
                                </div>
                                <div class="col">
                                    ${t.count}
                                </div>
                                <div class="col">
                                    <a class="btn btn-success btn-sm" href="/client/cart/increase/${t.tech.id}">+</a>
                                </div>
                            </div>
                        </td>
                        <td class="col-1"><a class="btn btn-primary btn-sm" href="/client/tech/${t.tech.id}">Подробнее</a></td>
                        <td class="col-1"><a class="btn btn-danger btn-sm" href="/client/cart/delete-item/${t.tech.id}">Удалить</a></td>
                    </tr>
                </#list>
            </table>

            <div class="row mt-5">
                <h4>
                    Полная стоимость: ${request.getTotalCost()} руб.
                </h4>
            </div>
            <div class="row mt-5">
                <form action="/client/add-order" method="post" id="orderForm">
                    <div class="row mt-3 align-items-center justify-content-center">
                        <div class="col">
                            <textarea id="textInput" class="form-control" name="description" placeholder="Введите описание, если необходимо (максимум 1000 символов)" rows="5"></textarea>
                        </div>
                    </div>
                    <div class="row mt-3 align-items-center">
                        <div class="d-flex justify-content-center">
                            <button class="btn btn-lg btn-primary" id="sendButton" onclick="validate()" type="button">Заказать</button>
                            <input type="hidden" name="_csrf" value="${_csrf.token}" />
                        </div>
                    </div>
                </form>
            </div>
        </div>
    <#else>
        <div class="row mt-5">
            <div class="col text-center">
                <h6>Нет ни одной записи в корзине.</h6>
            </div>
        </div>
    </#if>

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

            document.getElementById("orderForm").submit();
        }
    </script>
</@common.page>