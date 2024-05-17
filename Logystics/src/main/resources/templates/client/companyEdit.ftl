<#import "../partitials/common.ftl" as common>

<@common.page title="Редактирование данных компании">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-auto">
                <a class="btn btn-primary" href="/client/company">Назад</a>
            </div>
        </div>
        <form id="companyEditForm" method="post" action="/client/company/edit">
            <div class="row mt-3">
                <div class="col-10 offset-1">
                    <div class="form-floating">
                        <#if name??>
                            <input class="form-control" type="text" id="nameInput" required placeholder="name" name="name" value="${name}"/>
                        <#else>
                            <input class="form-control" type="text" id="nameInput" required placeholder="name" name="name"/>
                        </#if>
                        <label id="nameInputLabel" for="nameInput">Название компании</label>
                    </div>
                </div>
            </div>
            <div class="row mt-2">
                <div class="col-10 offset-1">
                    <div class="form-floating">
                        <#if email??>
                            <input class="form-control" type="email" id="emailInput" required placeholder="email" name="email" value="${email}"/>
                        <#else>
                            <input class="form-control" type="email" id="emailInput" required placeholder="email" name="email"/>
                        </#if>
                        <label id="emailInputLabel" for="emailInput">Контактная почта</label>
                    </div>
                </div>
            </div>
            <div class="row mt-2">
                <div class="col-10 offset-1">
                    <div class="form-floating">
                        <#if address??>
                            <input class="form-control" type="text" id="addressInput" required placeholder="address" name="address" value="${address}"/>
                        <#else>
                            <input class="form-control" type="text" id="addressInput" required placeholder="address" name="address"/>
                        </#if>
                        <label id="addressInputLabel" for="addressInput">Контактный адрес</label>
                    </div>
                </div>
            </div>
            <div class="row mt-2">
                <div class="col-10 offset-1">
                    <div class="form-floating">
                        <#if telephone??>
                            <input class="form-control" type="tel" id="telephoneInput" required placeholder="telephone" name="telephone" value="${telephone}"/>
                        <#else>
                            <input class="form-control" type="tel" id="telephoneInput" required placeholder="telephone" name="telephone"/>
                        </#if>
                        <label id="telephoneInputLabel" for="telephoneInput">Контактный телефон</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-10 offset-1">
                    <#if description??>
                        <textarea id="descriptionInput" class="form-control" name="description" maxlength="1000" placeholder="Введите описание" required rows="10">${description}</textarea>
                    <#else>
                        <textarea id="descriptionInput" class="form-control" name="description" maxlength="1000" placeholder="Введите описание" required rows="10"></textarea>
                    </#if>
                </div>
            </div>

            <div class="d-flex mt-2 justify-content-center">
                <button class="btn btn-primary" onclick="validate()" type="button">Сохранить</button>
                <input type="hidden" name="_csrf" value="${_csrf.token}" />
            </div>
        </form>
    </div>

    <script>
        function isEmpty(str) {
            return !str.trim().length;
        }

        function validate() {
            var name = document.getElementById("nameInput").value;
            if(isEmpty(name)){
                document.getElementById("nameInput").classList.add("is-invalid");
                document.getElementById("nameInputLabel").textContent  = "Заполните это поле!";
                document.getElementById("nameInputLabel").classList.add("text-danger");
                return;
            }
            else{
                document.getElementById("nameInput").classList.remove("is-invalid");
                document.getElementById("nameInputLabel").textContent  = "Название компании";
                document.getElementById("nameInputLabel").classList.remove("text-danger");
            }

            var email = document.getElementById("emailInput").value;
            var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if(isEmpty(email)){
                document.getElementById("emailInput").classList.add("is-invalid");
                document.getElementById("emailInputLabel").textContent  = "Заполните это поле!";
                document.getElementById("emailInputLabel").classList.add("text-danger");
                return;
            }
            else if (!emailRegex.test(email)) {
                document.getElementById("emailInput").classList.add("is-invalid");
                document.getElementById("emailInputLabel").textContent  = "Введите корректное значение почты!";
                document.getElementById("emailInputLabel").classList.add("text-danger");
                return;
            }
            else{
                document.getElementById("emailInput").classList.remove("is-invalid");
                document.getElementById("emailInputLabel").textContent  = "Контактная почта";
                document.getElementById("emailInputLabel").classList.remove("text-danger");
            }

            var address = document.getElementById("addressInput").value;
            if(isEmpty(address)){
                document.getElementById("addressInput").classList.add("is-invalid");
                document.getElementById("addressInputLabel").textContent  = "Заполните это поле!";
                document.getElementById("addressInputLabel").classList.add("text-danger");
                return;
            }
            else{
                document.getElementById("addressInput").classList.remove("is-invalid");
                document.getElementById("addressInputLabel").textContent  = "Контактный адрес";
                document.getElementById("addressInputLabel").classList.remove("text-danger");
            }

            var telephone = document.getElementById("telephoneInput").value;
            if(isEmpty(telephone)){
                document.getElementById("telephoneInput").classList.add("is-invalid");
                document.getElementById("telephoneInputLabel").textContent  = "Заполните это поле!";
                document.getElementById("telephoneInputLabel").classList.add("text-danger");
                return;
            }
            else{
                document.getElementById("telephoneInput").classList.remove("is-invalid");
                document.getElementById("telephoneInputLabel").textContent  = "Контактный телефон";
                document.getElementById("telephoneInputLabel").classList.remove("text-danger");
            }

            var description = document.getElementById("descriptionInput").value;
            if(isEmpty(description)){
                document.getElementById("descriptionInput").classList.add("is-invalid");
                return;
            }
            else{
                document.getElementById("nameInput").classList.remove("is-invalid");
            }

            document.getElementById("companyEditForm").submit();
        }
    </script>
</@common.page>