<#import "../partitials/common.ftl" as common>

<@common.page title="Профиль">
    <div class="container">
        <div class="row mt-5">
            <div class="col text-center">
                <h4>Профиль</h4>
            </div>
        </div>
        <form id="editProfileForm" action="/client/profile" method="post">
            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input class="form-control" type="text" id="credentialsInput" required placeholder="credentials" name="credentials" value="${profile.credentials}"/>
                        <label id="credentialsInputLabel" for="credentialsInput">ФИО</label>
                    </div>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-8 col-md-6 offset-2 offset-md-3">
                    <div class="form-floating">
                        <input class="form-control" type="tel" id="telephoneInput" required placeholder="+375-33-333-33-33" name="telephone" value="${profile.telephone}"/>
                        <label id="telephoneInputLabel" for="telephoneInput">Номер телефона</label>
                    </div>
                </div>
            </div>

            <div class="d-flex mt-2 justify-content-center">
                <button class="btn btn-primary" onclick="validate()" type="button">Сохранить</button>
                <input type="hidden" name="_csrf" value="${_csrf.token}" />
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

                document.getElementById("editProfileForm").submit();
            }
        </script>
    </div>
</@common.page>