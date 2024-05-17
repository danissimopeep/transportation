<#import "../partitials/common.ftl" as common>

<@common.page title="Реферальные ключи">
    <div class="row mt-5">
        <div class="col text-center">
            <h4>Реферальные ключи:</h4>
        </div>
    </div>

    <#if regKeys??>
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
                            <form method="post" action="/manager/keys/regenerate/${k.id}">
                                <input type="submit" class="btn btn-primary" value="Обновить">
                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                            </form>

                        </td>
                        <td class="col-1">
                            <form method="post" action="/manager/keys/delete/${k.id}">
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

    <form method="post" action="/manager/keys/generate">
        <div class="container mt-5">
            <div class="row g-3 align-items-center justify-content-end">
                <div class="col-auto">
                    <label for="usernameInput" class="col-form-label">Сгенерировать новый ключ для:</label>
                </div>
                <div class="col-5 col-lg-3">
                    <div class="form-floating">
                        <input type="email" id="usernameInput" class="form-control" placeholder="email@mail.com" name="username" required>
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

</@common.page>