<#import "../partitials/common.ftl" as common>

<@common.page title="Управление авто">
    <div class="row mt-5">
        <div class="col text-center">
            <h4>Автомобили:</h4>
        </div>
    </div>

    <#if techTypes??>
        <div class="container mt-5">
            <div class="row g-2 align-items-center justify-content-end">
                <div class="col-5 col-lg-3">
                    <#if search??>
                        <input type="email" id="searchInput" class="form-control" placeholder="Поиск..." value="${search}">
                    <#else>
                        <input type="email" id="searchInput" class="form-control" placeholder="Поиск...">
                    </#if>

                </div>
                <div class="col-auto">
                    <button class="btn btn-sm btn-primary" onclick="onSearch()" type="button">Поиск</button>
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                </div>
            </div>
        </div>
        <div class="container mt-3">
            <#if count!=0>
                <table class="table table-striped table-hover table-sm">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th></th>
                        <th>Название</th>
                        <th>Тип</th>
                        <th>Стоимость</th>
                        <th></th>
                        <th></th>
                    </tr>
                    </thead>
                    <#assign i=1>
                    <#list techTypes as typ>
                        <#list typ.techs as t>
                            <tr>
                                <th class="col-1" scope="row">${i}.</th>
                                <#assign i=i+1>
                                <td class="col-3">
                                    <#if t.getFirstImage()??>
                                        <img src="/img/${t.getFirstImage().path}" height="100" width="200">
                                    <#else>
                                        <img src="../../img/noimage.jpg" height="100" width="200">
                                    </#if>
                                </td>
                                <td class="col-2">${t.name}</td>
                                <td class="col-3">${typ.name}</td>
                                <td class="col-3">${t.cost} руб.</td>
                                <td class="col-3"><a class="btn btn-primary btn-sm" href="/admin/tech/${t.id}">Подробнее</a></td>
                                <td class="col-1">
                                    <form method="post" action="/admin/tech/delete/${t.id}">
                                        <input type="submit" class="btn btn-sm btn-danger" value="Удалить">
                                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                                    </form>
                                </td>
                            </tr>
                        </#list>
                    </#list>
                </table>
            <#else>
                <div class="col text-center">
                    <h6>Нет ни одной записи.</h6>
                </div>
            </#if>
        </div>
        <form method="post" id="addForm" action="/admin/tech/add">
            <div class="container mt-5">
                <div class="row align-items-center justify-content-start">
                    <div class="col-auto">
                        <label for="newsletterInput" id="newsletterInputLabel" class="col-form-label">Добавить товар:</label>
                    </div>
                </div>
                <div class="row align-items-center justify-content-start">
                    <div class="col-auto">
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
                    <div class="col-auto">
                        <select class="form-select" name="techTypeId" id="techTypeInput" required aria-label="Категория">
                            <option selected disabled value="-1">Выберите категорию</option>
                            <#list allTechTypes as t>
                                <option value="${t.id}">${t.name}</option>
                            </#list>
                        </select>
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
                <h6>Нет ни одной категории.</h6>
                <a class="btn btn-primary" href="/admin/tech-types">Добавить категорию</a>
            </div>
        </div>
    </#if>

    <script>
        function isEmpty(str) {
            return !str.trim().length;
        }

        function onSearch() {

            var search = document.getElementById("searchInput").value;
            var request = search == null? "//localhost:8080/admin/techs" :
                "//localhost:8080/admin/techs?search="+search;

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

            var id = document.getElementById("techTypeInput").value;
            if(id==-1){
                document.getElementById("techTypeInput").classList.add("is-invalid");
                return;
            }
            else{
                document.getElementById("techTypeInput").classList.remove("is-invalid");
            }

            document.getElementById("addForm").submit();
        }
    </script>
</@common.page>