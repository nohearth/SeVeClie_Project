var token = Cookies.get('user_session');

    function initTable() {
        $('#table-clie').DataTable({
            "processing": true,
            "serverSide": true,
            "ajax": {
                "url": "/api/seveclie/paginated",
                "type": "POST",
                "contentType": "application/json",
                "headers": { "Authorization": "Bearer " + token },
                "data": function (d) {
                    var params = {
                        page_size: d.length,
                        page_num: (d.start / d.length),
                        order_field: d.columns[d.order[0].column].data,
                        order_dir: d.order[0].dir,
                        filter_value: d.search.value
                    };
                    return JSON.stringify(params);
                },
                "dataSrc": function (res) {
                    res.recordsTotal = res.TotalRecords;
                    res.recordsFiltered = res.TotalRecords;

                    return res.Data;
                }
            },
            "columns": [
                { "data": "cedula" },
                { "data": "nombre" },
                { "data": "apellido" },
                { "data": "genero" },
                {
                    "data": "fecha_nac",
                    "ordenable": false,
                    "render": function(data) {
                        return new Intl.DateTimeFormat('es-ES').format(new Date(data));
                    }
                },
                { "data": "estado_civil" },
                { 
                    "data": "id_clie",
                    "ordenable": false,
                    "render": function(data) {
                        return `<button class="btn btn-sm btn-info" onclick="initUpdate('${data}')">Editar</button>
                            <button class ="btn btn-sm btn-danger" onclick="deleteClie('${data}')">Eliminar</button>`;
                    }
                }
            ]
        });

        loadCivilStatus();
    }

function initNew() {
    $("#formCliente")[0].reset();
    $("#modalTitulo").text("Crear Cliente");
    $("#modalCliente").modal("show");
}

function updateClie() {
    var id = $("#txtId").val();
    var clie = {
        id_clie: id,
        cedula: $("#txtCedula").val(),
        nombre: $("#txtNombre").val(),
        apellido: $("#txtApellido").val(),
        genero: $("#ddlGenero").val(),
        fecha_nac: $("#txtFechaNac").val(),
        id_estado_civil: $("#ddlEstadoCivil").val()
    };

    $.ajax({
        url: "/api/seveclie",
        type: "PUT", 
        contentType: "application/json",
        data: JSON.stringify(clie),
        success: function (res) {
            if (res.Success) {
                alert("Actualizado con éxito");
                $("#modalCliente").modal("hide");
                $('#table-clie').DataTable().ajax.reload();
            }
        }
    });
}

function loadCivilStatus() {
    
    $.ajax({
        url: "/api/catalog/civil-status",
        type: "GET",
        headers: { "Authorization": "Bearer " + token },
        success: function (res) {
            if (res.Success) {
                var ddl = $("#ddlEstadoCivil");
                ddl.empty().append('<option value="">Seleccione...</option>');
                $.each(res.Data, function (i, item) {
                    ddl.append($('<option>', {
                        value: item.Id,
                        text: item.Value
                    }));
                });
            }            
        },
        error: function () {
            console.error("No se pudo cargar la lista de estados civiles");
        }
    });
}

function deleteClie(id) {
    if (confirm("¿Está seguro de que desea eliminar este cliente?")) {
        $.ajax({
            url: '/api/seveclie/' + id,
            type: 'DELETE',
            success: function (res) {
                if (res.Success) {
                    alert("Cliente eliminado con éxito");
                    $('#table-clie').DataTable().ajax.reload();
                } else {
                    alert("Error: " + res.Message);
                }
            }
        });
    }
}

function initUpdate(id) {
    $.ajax({
        url: '/api/seveclie/' + id,
        type: 'GET',
        success: function (res) {
            if (res.Success) {
                var c = res.Data;

                $("#txtId").val(c.id_clie);
                $("#txtCedula").val(c.cedula);
                $("#txtNombre").val(c.nombre);
                $("#txtApellido").val(c.apellido);
                $("#ddlGenero").val(c.genero);
                $("#ddlEstadoCivil").val(c.id_estado_civil);


                if (c.fecha_nac) {
                    var fecha = c.fecha_nac.split('T')[0];
                    $("#txtFechaNac").val(fecha);
                }

                $("#modalTitulo").text("Editar Cliente");
                $("#modalCliente").modal("show");
            }
        }
    });
}

function saveClie() {
    var cliente = {
        id_clie: 0,
        cedula: $("#txtCedula").val(),
        nombre: $("#txtNombre").val(),
        apellido: $("#txtApellido").val(),
        genero: $("#ddlGenero").val(),
        fecha_nac: $("#txtFechaNac").val(),
        id_estado_civil: $("#ddlEstadoCivil").val()
    };

    // Validaciones básicas antes de enviar
    if (!cliente.cedula || !cliente.nombre) {
        alert("Por favor, complete los campos obligatorios.");
        return;
    }

    // 2. Petición AJAX
    $.ajax({
        url: "/api/seveclie",
        type: "POST",
        headers: { "Authorization": "Bearer " + token },
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(cliente),
        success: function (res) {
            if (res.Success) {
                alert(res.Message);
                $("#modalCliente").modal("hide");

                $('#table-clie').DataTable().ajax.reload();
            } else {
                alert("Error: " + res.Message);
            }
        },
        error: function (xhr) {
            console.error("Error al guardar:", xhr.responseText);
            alert("Ocurrió un error al procesar la solicitud.");
        }
    });
}

function sendInfo(key) {
    var Id = parseInt($("#txtId").val().trim()) || 1;

    if (Id === 0) {
        saveClie();
    } else {
        updateClie();
    }
}

$(document).ready(function () {
    initTable();
});