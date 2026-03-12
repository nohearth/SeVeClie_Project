$(document).off("submit", "#formLogin").on("submit", "#formLogin", function (e) {
    e.preventDefault();
    const user = {
        Username: $("#txt-user").val(),
        Password: $("#txt-pass").val()
    };

    $("#login-error").hide();

    $.ajax({
        url: "/api/account/login",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(user),
        success: function (res) {
            if (res.Success) {
                Cookies.set('user_session', res.Token, { expires: 1 });
                Cookies.set('user_name', res.Name, { expires: 1 });

                loadView("home");
            }
        },
        error: function () {
            $("#login-error").show();
        }
    });
});


$("#link-ir-registro").click(function (e) {
    e.preventDefault();
    loadView("register");
});