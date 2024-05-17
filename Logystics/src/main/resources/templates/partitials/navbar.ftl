<#macro adminNavbar>
    <nav class="navbar navbar-expand navbar-dark bg-primary justify-content-between">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">Logistics</a>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link link-light" href="/admin/clients">Пользователи</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/admin/registration-keys">Реферальные ключи</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/admin/tech-types">Категории</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/admin/techs">Автомобили</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/admin/orders">Заказы</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/logout">Выход</a>
                </li>
            </ul>
        </div>
    </nav>
</#macro>

<#macro managerNavbar>
    <nav class="navbar navbar-expand navbar-dark bg-primary justify-content-between">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">Logistics</a>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link link-light" href="/manager/orders">Заказы</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/manager/history">История</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/logout">Выход</a>
                </li>
            </ul>
        </div>
    </nav>
</#macro>

<#macro clientNavbar>
    <nav class="navbar navbar-expand navbar-dark bg-primary justify-content-between">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">Logistics</a>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link link-light" href="/client/company">Профиль компании</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/client/profile">Профиль</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/client/techs">Каталог</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/client/cart">Корзина</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/client/orders">Заказы</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/all/about">О нас</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/logout">Выход</a>
                </li>
            </ul>
        </div>
    </nav>
</#macro>

<#macro notAuthorizedNavbar>
    <nav class="navbar navbar-expand navbar-dark bg-primary justify-content-between">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">Logistics</a>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link link-light" href="/all/about">О нас</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/all/techs">Каталог</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/login">Вход</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link link-light" href="/registration-user">Регистрация</a>
                </li>
            </ul>
        </div>
    </nav>
</#macro>

