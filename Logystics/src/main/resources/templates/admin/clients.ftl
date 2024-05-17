<#import "../partitials/common.ftl" as common>

<@common.page title="Управление аккаунтами">
    <div class="row mt-5">
        <div class="col text-center">
            <h4>Клиенты:</h4>
        </div>
    </div>

    <div class="container mt-3">
        <div class="row g-2 align-items-center justify-content-between">
            <div class="col-5">
                <div class="row g-2 align-items-center justify-content-start">
                    <div class="col-auto">
                        <a class="btn btn-primary disabled" href="/admin/clients">Клиенты</a>
                    </div>
                    <div class="col-auto">
                        <a class="btn btn-secondary" href="/admin/managers">Менеджеры</a>
                    </div>
                </div>
            </div>
            <div class="col-7">
                <div class="row g-2 align-items-center justify-content-end">
                    <div class="col-5 col-lg-3">
                        <#if search??>
                            <input type="text" id="searchInput" class="form-control" placeholder="Поиск..." value="${search}">
                        <#else>
                            <input type="text" id="searchInput" class="form-control" placeholder="Поиск...">
                        </#if>
                    </div>
                    <div class="col-auto">
                        <button class="btn btn-sm btn-primary" onclick="onSearch()" type="button">Поиск</button>
                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <#if clients??>

        <div class="container mt-3">
            <table class="table table-striped table-hover table-sm">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Email</th>
                    <th>ФИО</th>
                    <th>Телефон</th>
                    <th>Компания</th>
                    <th></th>
                    <th></th>
                </tr>
                </thead>
                <#list clients as u>
                    <tr>
                        <th class="col-1" scope="row">${u_index + 1}.</th>
                        <td class="col-2">${u.account.username}</td>
                        <td class="col-3">${u.credentials}</td>
                        <td class="col-2">${u.telephone}</td>
                        <td class="col-2">${u.company.name}</td>
                        <td class="col-1">
                            <form method="get" action="/admin/message/${u.account.id}">
                                <input type="submit" class="btn btn-sm btn-primary" value="Сообщение">
                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                            </form>
                        </td>
                        <td class="col-1">
                            <form method="post" action="/admin/accounts/${u.account.id}">
                                <#if u.account.isActive()>
                                    <input type="submit" class="btn btn-sm btn-success" value="Активен">
                                <#else>
                                    <input type="submit" class="btn btn-sm btn-danger" value="Заблокирован">
                                </#if>
                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                            </form>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
        <form method="post" id="newsletterForm" action="/admin/clients/newsletter">
            <div class="container mt-5">
                <div class="row align-items-center justify-content-start">
                    <div class="col-auto">
                        <label for="newsletterInput" id="newsletterInputLabel" class="col-form-label">Разослать сообщение:</label>
                    </div>
                </div>
                <div class="row align-items-center justify-content-start">
                    <div class="col-5 col-lg-3">
                        <textarea id="newsletterInput" class="form-control" name="text" placeholder="Введите текст сообщения (максимум 500 символов)" required="true" rows="5"></textarea>
                    </div>
                </div>
                <div class="row align-items-center justify-content-start mt-2">
                    <div class="col-auto">
                        <button class="btn btn-primary" id="newsletterButton" onclick="validate()" type="button">Отправить</button>
                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                    </div>
                </div>
            </div>
        </form>
    <#else>
        <div class="row mt-5">
            <div class="col text-center">
                <h6>Список клиентов пуст</h6>
            </div>
        </div>
    </#if>

    <script>
        function isEmpty(str) {
            return !str.trim().length;
        }

        function onSearch() {

            var search = document.getElementById("searchInput").value;
            var request = search == null? "//localhost:8080/admin/clients" :
                "//localhost:8080/admin/clients?search="+search;

            window.location.href = request;
        }

        function validate() {
            var text = document.getElementById("newsletterInput").value;
            if(isEmpty(text)){
                document.getElementById("newsletterInput").classList.add("is-invalid");
                document.getElementById("newsletterInputLabel").textContent  = "Напишите текст сообщения!";
                document.getElementById("newsletterInputLabel").classList.add("text-danger");
                document.getElementById("newsletterButton").classList.remove("btn-primary");
                document.getElementById("newsletterButton").classList.add("btn-danger");
                return;
            }
            else if(text.length > 500){
                document.getElementById("newsletterInput").classList.add("is-invalid");
                document.getElementById("newsletterInputLabel").textContent  = "Текст сообщения не может превышать 500 символов!";
                document.getElementById("newsletterInputLabel").classList.add("text-danger");
                document.getElementById("newsletterButton").classList.remove("btn-primary");
                document.getElementById("newsletterButton").classList.add("btn-danger");
                return;
            }
            else{
                document.getElementById("newsletterInput").classList.remove("is-invalid");
                document.getElementById("newsletterInputLabel").textContent  = "Разослать сообщение:";
                document.getElementById("newsletterInputLabel").classList.remove("text-danger");
                document.getElementById("newsletterButton").classList.remove("btn-danger");
                document.getElementById("newsletterButton").classList.add("btn-primary");
            }

            document.getElementById("newsletterForm").submit();
        }
    </script>
</@common.page>