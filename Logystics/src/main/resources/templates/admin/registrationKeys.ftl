<#import "../partitials/common.ftl" as common>

<@common.page title="Реферальные ключи">
    <div class="row mt-5">
        <div class="col text-center">
            <h4>Реферальные ключи менеджеров:</h4>
        </div>
    </div>

    <#if regKeys??>
        <div class="container mt-5">
            <div class="row g-2 align-items-center justify-content-end">
                <div class="col-5 col-lg-3">
                    <#if searchUsername??>
                        <input type="email" id="usernameSearchInput" class="form-control" placeholder="Эл.почта..." value="${searchUsername}">
                    <#else>
                        <input type="email" id="usernameSearchInput" class="form-control" placeholder="Эл.почта...">
                    </#if>

                </div>
                <div class="col-auto">
                    <button class="btn btn-sm btn-primary" onclick="onSearch()" type="button">Поиск</button>
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                </div>
            </div>
        </div>
        <div class="container mt-3">
            <table class="table table-striped table-hover">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Email</th>
                    <th>Ключ</th>
                    <th></th>
                    <th></th>
                </tr>
                </thead>
                <#list regKeys as k>
                    <tr>
                        <th class="col-1" scope="row">${k_index + 1}.</th>
                        <td class="col-1">${k.username}</td>
                        <td class="col-1">${k.key}</td>
                        <td class="col-1">
                            <form method="post" action="/admin/registration-keys/regenerate/${k.id}">
                                <input type="submit" class="btn btn-primary" value="Обновить">
                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                            </form>

                        </td>
                        <td class="col-1">
                            <form method="post" action="/admin/registration-keys/delete/${k.id}">
                                <input type="submit" class="btn btn-danger" value="Удалить">
                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                            </form>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    <#else>
        <div class="row mt-5">
            <div class="col text-center">
                <h6>Список ключей пуст</h6>
            </div>
        </div>
    </#if>

    <form method="post" action="/admin/registration-keys/generate">
        <div class="container mt-5">
            <div class="row g-3 align-items-center justify-content-end">
                <div class="col-auto">
                    <label for="usernameInput" class="col-form-label">Сгенерировать новый ключ для:</label>
                </div>
                <div class="col-5 col-lg-3">
                    <div class="form-floating">
                        <input type="email" id="usernameInput" class="form-control" placeholder="email@mail.com" name="username" required="true">
                        <label for="usernameInput">Эл.почта</label>
                    </div>
                </div>
                <div class="col-auto">
                    <input type="submit" class="btn btn-primary" value="Сгенерировать">
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function onSearch() {

            var username = document.getElementById("usernameSearchInput").value;
            var request = username == null? "//localhost:8080/admin/registration-keys" :
                                            "//localhost:8080/admin/registration-keys?username="+username;

            window.location.href = request;
        }
    </script>
    </div>

</@common.page>