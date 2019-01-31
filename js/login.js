function ValidaForm()
{
	if($("#frmLogin").valid())
	{
			$.ajax({
			url:/* baseurl +*/ 'php/DAO/loginDAO.php',
			method: 'POST',
			dataType: 'json',
			data: {
				username: $("#username").val(),
				password: $("#password").val(),
			},
			error: function()
			{
				notificacion('error','Usuario y/o Contraseña Incorrectos');
			},
			success: function(response)
			{
				window.location.href="dashboard.php"

			}
		});
	}
}

function  notificacion (tipo,msj)
{
	new PNotify({
    title: 'Anguiano ERP',
    text: msj,
    type: tipo,
	});
}

$(document).ready(function()
{

	$("#frmLogin").validate({

		rules: {
		    username: "required",
		    password: {required: true}
	  },

	  messages: {
		    username: "Porfavor especifique un usuario",
		    password:  "Porfavor especifique una contraseña",
	  },

		highlight: function( label ) {
			$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
		},
		success: function( label ) {
			$(label).closest('.form-group').removeClass('has-error');
			label.remove();
		},
		errorPlacement: function( error, element ) {
			var placement = element.closest('.input-group');
			if (!placement.get(0)) {
				placement = element;
			}
			if (error.text() !== '') {
				placement.after(error);
			}
		}
	});


});