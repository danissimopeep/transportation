<#import "../partitials/common.ftl" as common>

<@common.page title="Управление категориями">
    <div class="row mt-5">
        <div class="col text-center">
            <h4>Категории:</h4>
        </div>
    </div>

    <#if techTypes??>
        <div class="container mt-3">
            <table class="table table-striped table-hover table-sm">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Название</th>
                    <th>Количество товаров</th>
                    <th></th>
                </tr>
                </thead>
                <#list techTypes as tech>
                    <tr>
                        <th class="col-2" scope="row">${tech_index + 1}</th>
                        <td class="col-6">${tech.name}</td>
                        <td class="col-3">${tech.getCountOfTechs()}</td>
                        <#if tech.getCountOfTechs() != 0>
                            <td class="col-1">
                                <form method="post" action="/admin/tech-types/delete/${tech.id}">
                                    <input type="submit" class="btn btn-sm btn-primary" disabled value="Удалить">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                                </form>
                            </td>
                        <#else>
                            <td class="col-1">
                                <form method="post" action="/admin/tech-types/delete/${tech.id}">
                                    <input type="submit" class="btn btn-sm btn-primary" value="Удалить">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                                </form>
                            </td>
                        </#if>
                    </tr>
                </#list>
            </table>
        </div>
    <#else>
        <div class="row mt-5">
            <div class="col text-center">
                <h6>Нет ни одной категории.</h6>
            </div>
        </div>
    </#if>
    <form method="post" id="addTypeForm" action="/admin/tech-types/add">
        <div class="container mt-5">
            <div class="row align-items-center justify-content-start">
                <div class="col-auto">
                    <label for="newsletterInput" id="newsletterInputLabel" class="col-form-label">Добавить категорию:</label>
                </div>
            </div>
            <div class="row align-items-center justify-content-start">
                <div class="col-4">
                    <div class="form-floating">
                        <#if errorText??>
                            <input class="form-control is-invalid" type="text" id="nameInput" required placeholder="Название" name="name" value="${name}"/>
                            <label id="nameInputLabel" for="nameInput" class="text-danger">${errorText}</label>
                        <#else>
                            <input class="form-control" type="text" id="nameInput" required placeholder="Название" name="name"/>
                            <label id="nameInputLabel" for="nameInput">Название</label>
                        </#if>
                    </div>
                </div>
            </div>
            <div class="row align-items-center justify-content-start mt-2">
                <div class="col-2">
                    <button class="btn btn-primary" id="newsletterButton" onclick="validate()" type="button">Отправить</button>
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function isEmpty(str) {
            return !str.trim().length;
        }

        function onSearch() {

            var search = document.getElementById("searchInput").value;
            var request = search == null? "//localhost:8080/admin/tech-types" :
                "//localhost:8080/admin/tech-types?search="+search;

            window.location.href = request;
        }


        function validate() {
            var name = document.getElementById("nameInput").value;
            if(isEmpty(name)){
                document.getElementById("nameInput").classList.add("is-invalid");
                document.getElementById("nameInputLabel").textContent  = "Заполните поле!";
                document.getElementById("nameInputLabel").classList.add("text-danger");
                return;
            }
            else{
                document.getElementById("nameInput").classList.remove("is-invalid");
                document.getElementById("nameInputLabel").textContent  = "Название";
                document.getElementById("nameInputLabel").classList.remove("text-danger");
            }

            document.getElementById("addTypeForm").submit();
        }
    </script>
</@common.page>