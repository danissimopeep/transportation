<#import "partitials/common.ftl" as common>

<@common.page title="Авторизация">
    <div class="container">
        <div class="row mt-5">
            <div class="col text-center">
                <h4>Авторизация</h4>
            </div>
        </div>
        <form action="/login" method="post">
            <div class="row mt-4">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input class="form-control" type="email" id="emailInput" required="true" placeholder="a@a.com" name="username"/>
                        <label for="emailInput">Эл. почта</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input class="form-control" type="password" id="passwordInput" required="true" placeholder="a@a.com" name="password"/>
                        <label for="passwordInput">Пароль</label>
                    </div>
                </div>
            </div>

            <div class="row mt-3">
                <div class="col-2 offset-5">
                    <input class="form-control btn btn-primary" type="submit" value="Вход"/>
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                </div>
            </div>
        </form>

        <div class="d-flex mt-2 justify-content-center">
            <a href="/registration-user" class="link-secondary text-center align-text-bottom">Еще нет аккаунта?</a>
        </div>
    </div>
</@common.page>