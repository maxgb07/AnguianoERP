function initTool()
{
  $( '[data-toggle=popover]' ).popover();
  $( '[data-toggle=tooltip],[rel=tooltip]' ).tooltip({ container: 'body' });
}
function obtenerServiciosEnProceso()
{

   $.ajax({

            type: "POST",
            url: "php/DAO/serviciosDAO.php",
            data: "accion=obtener&finalizado="+0,
            async: false,
            dataType: "json",
            success: function(datos) {
             LimpiaTabla("datatable-responsive");
             if(datos.estaus !=='false'){ 
             var data ='';
               $.each(datos.data, function(i, item) {
                  data+='<tr>';
                  data+='<td>'+item.id_servicio+'</td>';
                  data+='<td>'+item.nombre_cliente+'</td>';
                  data+='<td>'+item.marca_vehiculo+'</td>';
                  data+='<td>'+item.modelo_vehiculo+'</td>';
                  data+='<td>'+item.anio_vehiculo+'</td>';
                  data+='<td>'+item.fecha_inicio_servicio+'</td>';
                  data+='<td>'+item.descripcion_servicio+'</td>';
                  data+='<td><a id="'+item.id_servicio+'" onclick="showModal('+item.id_servicio+')" title="Servicio Terminado"><i class="fa fa-check fa-lg" style="margin-left: 20px;"></i></a><a href="#" title="Eliminar Servicio"><i class="fa fa-trash fa-lg" style="margin-left: 20px;"></i></a><a href="#" title="Editar Servicio"><i class="fa fa-edit fa-lg" style="margin-left: 20px;"></i></a></td>';
                  data+='</tr>';
                  	initTool();
                });

                $("#enProceso").html(data);
                InicializaTabla("datatable-responsive");
            }else
           		 InicializaTabla("datatable-responsive");
        }
	   });
}

function LimpiaTabla(tabla)
{
   $('#'+tabla).DataTable().clear().destroy();
}

function InicializaTabla(tabla)
{
    
     $('#'+tabla).DataTable({
      "order": [[ 0, "desc" ]],
      "language": {
            "lengthMenu": "Muestra _MENU_ registros por pagina",
            "zeroRecords": "No existen registros",
            "sInfo":"Mostrando _START_ a _END_ de _TOTAL_ registros",
            "infoEmpty": "No existe informacion para mostrar",
            "infoFiltered": "(filtered from _MAX_ total records)",
            "search":         "Buscar:",
            "paginate": {
                            "first":      "First",
                            "last":       "Last",
                            "next":       "Siguiente",
                            "previous":   "Anterior"
                        },
        },
        "bDestroy": true, // es necesario para poder ejecutar la funcion LimpiaTabla()
     });
}

function GuardarServicio()
{
  if($("#formAgregarServicio").valid())
  {
      $.ajax({
              type: "POST",
              url: "php/DAO/serviciosDAO.php",
              data: "accion=guardar&"+$("#formAgregarServicio").serialize(),
              async: false,
              dataType: "json",
              success: function(datos) {
                $(".bs-example-modal-lg").modal('hide');
                      if(datos.msj=='ok')
                      {
                        if(datos.estatus=='guardado'){
                          notificacion('success','Servicio Registrado Correctamente');
                          obtenerServiciosEnProceso();
                        }
                        else{
                            notificacion('success','Operador actualizado exitosamente');
                          obtenerServiciosEnProceso();
                        }
                      }
                     else
                     {
                        notificacion('error','Error al Registrar Servicio');
                     }
                  } 
              });
  }

}
function FinalizarServicio()
{
    if($("#formAgregarServicio").valid())
  {
      $.ajax({
              type: "POST",
              url: "php/DAO/serviciosDAO.php",
              data: "accion=finalizar&"+$("#formFinalizarServicio").serialize(),
              async: false,
              dataType: "json",
              success: function(datos) {
                $("#modalFinalizarServicio").modal('hide');
                      if(datos.msj=='ok')
                      {
                        if(datos.estatus=='finalizado'){
                          notificacion('success','Servicio Finalizado Correctamente');
                          obtenerServiciosEnProceso();
                        }
                        else{
                            notificacion('error','Error al Finalizar Servicio');
                          obtenerServiciosEnProceso();
                        }
                      }
                     else
                     {
                        notificacion('error','Error al Finalizar Servicio');
                     }
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
function showModal(id)
{
    var id_servicio = id;
    document.getElementById("idServicio").value = id_servicio;
    $('#modalFinalizarServicio').modal({ keyboard: false });
    $('#modalFinalizarServicio').modal('show');
}
$( document ).ready(function() {
 obtenerServiciosEnProceso();
 InicializaTabla("datatable-responsive");
 $('#guardarServicio').click(function(e) {
        GuardarServicio();
  });
  $('#finalizarServicio').click(function(e) {
        FinalizarServicio();
  });
});

