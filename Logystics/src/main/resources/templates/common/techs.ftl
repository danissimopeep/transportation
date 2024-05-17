<#import "../partitials/common.ftl" as common>

<@common.page title="Автомобили">
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
                                <td class="col-3"><a class="btn btn-primary btn-sm" href="/all/tech/${t.id}">Подробнее</a></td>
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
    <#else>
        <div class="row mt-5">
            <div class="col text-center">
                <h6>Нет ни одной категории.</h6>
            </div>
        </div>
    </#if>

    <script>
        function onSearch() {

            var search = document.getElementById("searchInput").value;
            var request = search == null? "//localhost:8080/all/techs" :
                "//localhost:8080/all/techs?search="+search;

            window.location.href = request;
        }
    </script>
</@common.page>