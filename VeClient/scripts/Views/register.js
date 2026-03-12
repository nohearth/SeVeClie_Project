$("#btn-registrar-ajax").off("click").on("click", function () {
    const user = $("#reg-user").val();
    const pass = $("#reg-pass").val();
    const confirm = $("#reg-pass-confirm").val();
    const $msg = $("#msg-registro");

    if (!user || !pass) {
        $msg.text("Todos los campos son obligatorios").css("color", "orange").show();
        return;
    }

    if (pass !== confirm) {
        $msg.text("Las contraseñas no coinciden").css("color", "red").show();
        return;
    }

    const newUser = {
        Username: user,
        Password: pass
    };

    $.ajax({
        url: "/api/account/register",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(newUser),
        success: function (res) {
            $msg.text("¡Registro exitoso! Redirigiendo...").css("color", "green").show();
            setTimeout(function () {
                cargarVista("login");
            }, 1500);
        },
        error: function (xhr) {
            const errorMsg = xhr.responseJSON ? xhr.responseJSON.Message : "Error al registrar";
            $msg.text(errorMsg).css("color", "red").show();
        }
    });
});

$("#btn-volver-login").click(function (e) {
    e.preventDefault();
    loadView("login");
});