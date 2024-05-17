<#import "partitials/common.ftl" as common>

<@common.page title="Регистрация">
    <div class="container">
        <div class="row mt-5">
            <div class="col text-center">
                <h4>Регистрация</h4>
            </div>
        </div>
        <form id="registrationForm" action="/registration-employee" method="post">
            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <#if credentials??>
                            <input class="form-control" type="text" id="credentialsInput" required="true" placeholder="credentials" name="credentials" value="${credentials}"/>
                        <#else>
                            <input class="form-control" type="text" id="credentialsInput" required="true" placeholder="credentials" name="credentials"/>
                        </#if>
                        <label id="credentialsInputLabel" for="credentialsInput">ФИО</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <#if username??>
                            <#if errorUsername??>
                                <input class="form-control is-invalid" type="email" id="emailInput" required="true" placeholder="a@a.com" name="username" value="${username}"/>
                            <#else>
                                <input class="form-control" type="email" id="emailInput" required="true" placeholder="a@a.com" name="username" value="${username}"/>
                            </#if>
                        <#else>
                            <input class="form-control" type="email" id="emailInput" required="true" placeholder="a@a.com" name="username"/>
                        </#if>
                        <#if errorUsername??>
                            <label id="emailInputLabel" for="emailInput" class="text-danger">Данная почта уже занята</label>
                        <#else>
                            <label id="emailInputLabel" for="emailInput">Эл. почта</label>
                        </#if>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <#if password??>
                            <input class="form-control" type="password" id="passwordInput" required="true" placeholder="a@a.com" name="password" value="${password}"/>
                        <#else>
                            <input class="form-control" type="password" id="passwordInput" required="true" placeholder="a@a.com" name="password"/>
                        </#if>

                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                        <label id="passwordInputLabel" for="passwordInput">Пароль</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <#if repeatPassword??>
                            <input class="form-control" type="password" id="repeatPasswordInput" required="true" placeholder="a@a.com" name="repeatPassword" value="${repeatPassword}"/>
                        <#else>
                            <input class="form-control" type="password" id="repeatPasswordInput" required="true" placeholder="a@a.com" name="repeatPassword"/>
                        </#if>
                        <label id="repeatPasswordInputLabel" for="repeatPasswordInput">Повторите пароль</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <#if telephone??>
                            <input class="form-control" type="tel" id="telephoneInput" required="true" placeholder="+375-33-333-33-33" name="telephone" value="${telephone}"/>
                        <#else>
                            <input class="form-control" type="tel" id="telephoneInput" required="true" placeholder="+375-33-333-33-33" name="telephone"/>
                        </#if>

                        <label id="telephoneInputLabel" for="telephoneInput">Номер телефона</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <#if errorKey??>
                            <input class="form-control is-invalid" type="text" minlength="16" maxlength="16" id="keyInput" required="true" placeholder="aaaabbbbAAAABBBB" name="key" value="${key}"/>
                            <label id="keyInputLabel" class="text-danger" for="keyInput">${errorKey}</label>
                        <#else>
                            <input class="form-control" type="text" minlength="16" maxlength="16" id="keyInput" required="true" placeholder="aaaabbbbAAAABBBB" name="key"/>
                            <label id="keyInputLabel" for="keyInput">Реферальный код</label>
                        </#if>
                    </div>
                </div>
            </div>

            <div class="d-flex mt-2 justify-content-center">
                <button class="btn btn-primary" onclick="validate()" type="button">Регистрация</button>
            </div>
        </form>

        <script>
            function isEmpty(str) {
                return !str.trim().length;
            }

            function validate() {
                var credentials = document.getElementById("credentialsInput").value;
                if(isEmpty(credentials)){
                    document.getElementById("credentialsInput").classList.add("is-invalid");
                    document.getElementById("credentialsInputLabel").textContent  = "Заполните это поле!";
                    document.getElementById("credentialsInputLabel").classList.add("text-danger");
                    return;
                }
                else{
                    document.getElementById("credentialsInput").classList.remove("is-invalid");
                    document.getElementById("credentialsInputLabel").textContent  = "ФИО";
                    document.getElementById("credentialsInputLabel").classList.remove("text-danger");
                }

                var username = document.getElementById("emailInput").value;
                if(isEmpty(username)){
                    document.getElementById("emailInput").classList.add("is-invalid");
                    document.getElementById("emailInputLabel").textContent  = "Заполните это поле!";
                    document.getElementById("emailInputLabel").classList.add("text-danger");
                    return;
                }
                else{
                    document.getElementById("emailInput").classList.remove("is-invalid");
                    document.getElementById("emailInputLabel").textContent  = "Эл. почта";
                    document.getElementById("emailInputLabel").classList.remove("text-danger");
                }

                var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

                if (!emailRegex.test(username)) {
                    document.getElementById("emailInput").classList.add("is-invalid");
                    document.getElementById("emailInputLabel").textContent  = "Введите корректное значение почты!";
                    document.getElementById("emailInputLabel").classList.add("text-danger");
                    return;
                }
                else{
                    document.getElementById("emailInput").classList.remove("is-invalid");
                    document.getElementById("emailInputLabel").textContent  = "Эл. почта";
                    document.getElementById("emailInputLabel").classList.remove("text-danger");
                }

                var password = document.getElementById("passwordInput").value;
                if(isEmpty(password)){
                    document.getElementById("passwordInput").classList.add("is-invalid");
                    document.getElementById("passwordInputLabel").textContent  = "Заполните это поле!";
                    document.getElementById("passwordInputLabel").classList.add("text-danger");
                    return;
                }
                else{
                    document.getElementById("passwordInput").classList.remove("is-invalid");
                    document.getElementById("passwordInputLabel").textContent  = "Пароль";
                    document.getElementById("passwordInputLabel").classList.remove("text-danger");
                }

                var passwordRepeat = document.getElementById("repeatPasswordInput").value;
                if(isEmpty(passwordRepeat)){
                    document.getElementById("repeatPasswordInput").classList.add("is-invalid");
                    document.getElementById("repeatPasswordInputLabel").textContent  = "Заполните это поле!";
                    document.getElementById("repeatPasswordInputLabel").classList.add("text-danger");
                    return;
                }
                else{
                    document.getElementById("repeatPasswordInput").classList.remove("is-invalid");
                    document.getElementById("repeatPasswordInputLabel").textContent  = "Повторите пароль";
                    document.getElementById("repeatPasswordInputLabel").classList.remove("text-danger");
                }

                if(password !== passwordRepeat){
                    document.getElementById("repeatPasswordInput").classList.add("is-invalid");
                    document.getElementById("repeatPasswordInputLabel").textContent  = "Пароли должны совпадать!";
                    document.getElementById("repeatPasswordInputLabel").classList.add("text-danger");
                    return;
                }
                else{
                    document.getElementById("repeatPasswordInput").classList.remove("is-invalid");
                    document.getElementById("repeatPasswordInputLabel").textContent  = "Повторите пароль";
                    document.getElementById("repeatPasswordInputLabel").classList.remove("text-danger");
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
                    document.getElementById("telephoneInputLabel").textContent  = "Номер телефона";
                    document.getElementById("telephoneInputLabel").classList.remove("text-danger");
                }

                var key = document.getElementById("keyInput").value;
                if(isEmpty(key)){
                    document.getElementById("keyInput").classList.add("is-invalid");
                    document.getElementById("keyInputLabel").textContent  = "Заполните это поле!";
                    document.getElementById("keyInputLabel").classList.add("text-danger");
                    return;
                }
                else{
                    document.getElementById("keyInput").classList.remove("is-invalid");
                    document.getElementById("keyInputLabel").textContent  = "Реферальный код";
                    document.getElementById("keyInputLabel").classList.remove("text-danger");
                }

                document.getElementById("registrationForm").submit();
            }
        </script>
    </div>
</@common.page>