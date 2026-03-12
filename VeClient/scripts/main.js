$(document).ready(function () {
    const sesion = Cookies.get('user_session');
    if (sesion) {
        loadView("home");
    } else {
        loadView("login");
    }
});


$(document).on('click', '#btnLogout', function (e) {
    e.preventDefault();
    Cookies.remove('user_session');

    loadView("login");
});

$.ajaxSetup({
    beforeSend: function (xhr) {
        var token = Cookies.get('user_session');
        if (token) {
            xhr.setRequestHeader('Authorization', 'Bearer ' + token);
        }
    }
});

function verificarAcceso() {
    const sesion = Cookies.get('user_session');
    if (!sesion) {
        loadView("login");
        return false;
    }
    return true;
}

function loadView(viewName) {
    const urlHTML = "/" + viewName + ".html";
    const urlJS = "/Scripts/Views/" + viewName + ".js";

    if (viewName === "login") {
        $('#btnLogout').hide();
    }
    else {
        $('#btnLogout').show();
    }

    $("#main-content").load(urlHTML, function (response, status, xhr) {
        if (status === "success") {
            $.getScript(urlJS)
                .done(function () {
                })
                .fail(function () {
                });
        }
    });
}

function printReport() {
    var filtro = $('#table-clie').DataTable().search();

    window.open('ReportHandler.ashx?filtro=' + encodeURIComponent(filtro), '_blank');
}
