<#import "../partitials/common.ftl" as common>

<@common.page title="Управление аккаунтами">
    <div class="row mt-5">
        <div class="col text-center">
            <h4>Отправка сообщения:</h4>
        </div>
    </div>

    <form method="post" id="messageForm" action="/admin/message/${account.id}">
        <div class="container mt-5">
            <div class="row mt-3 align-items-center justify-content-center">
                <div class="col">
                    <div class="form-floating">
                        <input type="email" id="emailInput" name="username" readonly class="form-control" placeholder="Эл.почта" value="${account.username}">
                        <label id="emailInputLabel" for="emailInput">Почта</label>
                    </div>
                </div>
            </div>
            <div class="row mt-3 align-items-center justify-content-center">
                <div class="col">
                    <div class="form-floating">
                        <input type="text" id="titleInput" name="title" class="form-control" placeholder="Заголовок">
                        <label id="titleInputLabel" for="titleInput">Заголовок</label>
                    </div>
                </div>
            </div>
            <div class="row mt-3 align-items-center justify-content-center">
                <div class="col">
                    <textarea id="textInput" class="form-control" name="text" placeholder="Введите текст сообщения (максимум 500 символов)" required="true" rows="5"></textarea>
                </div>
            </div>
            <div class="row mt-3 align-items-center">
                <div class="d-flex justify-content-center">
                    <button class="btn btn-lg btn-primary" id="sendButton" onclick="validate()" type="button">Отправить</button>
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function isEmpty(str) {
            return !str.trim().length;
        }

        function validate() {
            var title = document.getElementById("titleInput").value;
            if(isEmpty(title)){
                document.getElementById("titleInput").classList.add("is-invalid");
                document.getElementById("titleInputLabel").textContent  = "Заполните это поле!";
                document.getElementById("titleInputLabel").classList.add("text-danger");
                return;
            }
            else{
                document.getElementById("titleInput").classList.remove("is-invalid");
                document.getElementById("titleInputLabel").textContent  = "Заголовок";
                document.getElementById("titleInputLabel").classList.remove("text-danger");
            }

            var text = document.getElementById("textInput").value;
            if(isEmpty(text)){
                document.getElementById("textInput").classList.add("is-invalid");
                return;
            }
            else if(text.length > 500){
                document.getElementById("textInput").classList.add("is-invalid");
                return;
            }
            else{
                document.getElementById("textInput").classList.remove("is-invalid");
            }

            document.getElementById("messageForm").submit();
        }
    </script>
</@common.page>