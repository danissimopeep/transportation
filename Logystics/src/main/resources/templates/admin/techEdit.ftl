<#import "../partitials/common.ftl" as common>
<#import "../partitials/carousel.ftl" as carousels>

<@common.page title="Редактирование карточки товара">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-auto">
                <a class="btn btn-primary" href="/admin/tech/${tech.id}">Назад</a>
            </div>
        </div>
        <form id="editForm" method="post" action="/admin/tech/edit/${tech.id}">
            <div class="row mt-3">
                <div class="col-10 offset-1">
                    <div class="form-floating">
                        <input class="form-control" type="text" id="nameInput" required placeholder="name" name="name" value="${tech.name}"/>
                        <label id="nameInputLabel" for="nameInput">Название</label>
                    </div>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-10 offset-1">
                    <div class="form-floating">
                        <input class="form-control" type="number" min="1" id="costInput" required placeholder="cost" name="cost" value="${tech.cost}"/>
                        <label id="costInputLabel" for="costInput">Стоимость</label>
                    </div>
                </div>
            </div>
            <div class="row mt-2">
                <div class="col-10 offset-1">
                    <textarea id="descriptionInput" class="form-control" name="description" maxlength="1000" placeholder="Введите описание (максимум 1000 символов)" required="true" rows="10">${tech.description}</textarea>
                </div>
            </div>

            <div class="d-flex mt-2 justify-content-center">
                <button class="btn btn-primary" onclick="validate()" type="button">Сохранить</button>
                <input type="hidden" name="_csrf" value="${_csrf.token}" />
            </div>
        </form>
    </div>

    <div class="container mt-5">
        <div class="row text-center">
            <h3>Фото:</h3>
        </div>

        <div class="row">
            <div class="col-8 offset-2">
                <#if tech.techImages??>
                    <div id="carousel" class="carousel slide">
                        <div class="carousel-inner">
                            <#list tech.techImages as i>
                                <#if i_index == 0>
                                    <div class="carousel-item active">
                                        <div class="card">
                                            <img src="/img/${i.path}" class="card-img-top d-block w-100" height="400">
                                            <div class="card-body">
                                                <form method="post" action="/admin/tech/image/delete/${i.id}">
                                                    <div class="d-flex justify-content-center">
                                                        <button class="btn btn-danger" type="submit">Удалить</button>
                                                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                <#else>
                                    <div class="carousel-item">
                                        <div class="card">
                                            <img src="/img/${i.path}" class="card-img-top d-block w-100"  height="400">
                                            <div class="card-body">
                                                <form method="post" action="/admin/tech/image/delete/${i.id}">
                                                    <div class="d-flex justify-content-center">
                                                        <button class="btn btn-danger" type="submit">Удалить</button>
                                                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </#if>
                            </#list>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#carousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Предыдущий</span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#carousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Следующий</span>
                        </button>
                    </div>
                <#else>
                    <div class="text-center">
                        <h6>Список фото пуст</h6>
                    </div>
                </#if>
            </div>
        </div>

        <div class="row mb-5 mt-5">
            <form id="addFileForm" method="post" action="/admin/tech/image/add/${id}" enctype="multipart/form-data">
                <label for="inputFile" id="inputFileLabel" class="form-label">Добавьте фото:</label>
                <input class="form-control" name="file" type="file" id="inputFile">

                <div class="d-flex mt-2 justify-content-center">
                    <button class="btn btn-primary" onclick="validateFile()" type="button">Добавить</button>
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                </div>
            </form>
        </div>
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
                document.getElementById("nameInputLabel").textContent  = "Название";
                document.getElementById("nameInputLabel").classList.remove("text-danger");
            }

            var cost = document.getElementById("costInput").value;
            if(isEmpty(cost)){
                document.getElementById("costInput").classList.add("is-invalid");
                document.getElementById("costInputLabel").textContent  = "Заполните это поле!";
                document.getElementById("costInputLabel").classList.add("text-danger");
                return;
            }
            else{
                document.getElementById("costInput").classList.remove("is-invalid");
                document.getElementById("costInputLabel").textContent  = "Стоимость";
                document.getElementById("costInputLabel").classList.remove("text-danger");
            }

            document.getElementById("editForm").submit();
        }

        function validateFile() {
            var file = document.getElementById("inputFile").files[0];
            if(!file){
                document.getElementById("inputFile").classList.add("is-invalid");
                document.getElementById("inputFileLabel").textContent  = "Заполните это поле!";
                document.getElementById("inputFileLabel").classList.add("text-danger");
                return;
            }
            else if(!/\.(jpg|jpeg|png|gif)$/i.test(file.name)){
                document.getElementById("inputFile").classList.add("is-invalid");
                document.getElementById("inputFileLabel").textContent  = "Выберите изображение!";
                document.getElementById("inputFileLabel").classList.add("text-danger");
                document.getElementById("inputFile").value = '';
                return;
            }
            else{
                document.getElementById("inputFile").classList.remove("is-invalid");
                document.getElementById("inputFileLabel").textContent  = "Добавьте фото:";
                document.getElementById("inputFileLabel").classList.remove("text-danger");
            }

            document.getElementById("addFileForm").submit();
        }
    </script>
</@common.page>