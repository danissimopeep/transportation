<#import "partitials/common.ftl" as common>

<@common.page title="Регистрация">
    <div class="container">
        <div class="row mt-5">
            <div class="col text-center">
                <h4>Подтвердите свою учетную запись</h4>
            </div>
        </div>
        <form id="confirmationForm" action="/confirmation" method="post">
            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input readonly class="form-control is-valid" type="text" id="credentialsInput" required="true" placeholder="credentials" name="credentials" value="${credentials}"/>
                        <label id="credentialsInputLabel" for="credentialsInput" class="text-success">ФИО</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input readonly class="form-control is-valid" type="email" id="emailInput" required="true" placeholder="a@a.com" name="username" value="${username}"/>
                        <label id="emailInputLabel" for="emailInput" class="text-success">Эл. почта</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input readonly class="form-control is-valid" type="password" id="passwordInput" required="true" placeholder="a@a.com" name="password" value="${password}"/>
                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                        <label id="passwordInputLabel" for="passwordInput" class="text-success">Пароль</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input readonly class="form-control is-valid" type="password" id="repeatPasswordInput" required="true" placeholder="a@a.com" name="repeatPassword" value="${repeatPassword}"/>
                        <label id="repeatPasswordInputLabel" for="repeatPasswordInput" class="text-success">Повторите пароль</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input readonly class="form-control is-valid" type="tel" id="telephoneInput" required="true" placeholder="+375-33-333-33-33" name="telephone" value="${telephone}"/>
                        <label id="telephoneInputLabel" for="telephoneInput" class="text-success">Номер телефона</label>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col text-center">
                    <h7>Вам на почту был выслан код подтверждения для проверки подлинности.</h7>

                </div>
            </div>

            <div class="row">
                <div class="col text-center">
                    <p class="small">Пожалуйста, введите его в поле ниже.</p>
                </div>
            </div>

            <div class="row">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <#if error??>
                            <input class="form-control is-invalid" type="text" minlength="16" maxlength="16" id="keyInput" required="true" placeholder="aaaabbbbAAAABBBB" name="key" value="${key}"/>
                            <label id="keyInputLabel" class="text-danger" for="keyInput">${error}</label>
                        <#else>
                            <input class="form-control" type="text" minlength="16" maxlength="16" id="keyInput" required="true" placeholder="aaaabbbbAAAABBBB" name="key"/>
                            <label id="keyInputLabel" for="keyInput">Код подтверждения</label>
                        </#if>
                    </div>
                </div>
            </div>

            <div class="d-flex mt-3 justify-content-center">
                <button class="btn btn-success" onclick="validate()" type="button">Подтвердить</button>
            </div>

            <div class="d-flex mt-5 justify-content-center">
                <button class="btn btn-success" style="visibility: hidden">Подтвердить</button>
            </div>
        </form>

        <script>
            function isEmpty(str) {
                return !str.trim().length;
            }

            function validate() {
                var key = document.getElementById("keyInput").value;
                if(isEmpty(key)){
                    document.getElementById("keyInput").classList.add("is-invalid");
                    document.getElementById("keyInputLabel").textContent  = "Заполните это поле!";
                    document.getElementById("keyInputLabel").classList.add("text-danger");
                    return;
                }
                else{
                    document.getElementById("keyInput").classList.remove("is-invalid");
                    document.getElementById("keyInputLabel").textContent  = "Код подтверждения";
                    document.getElementById("keyInputLabel").classList.remove("text-danger");
                }

                document.getElementById("confirmationForm").submit();
            }
        </script>
    </div>
</@common.page>