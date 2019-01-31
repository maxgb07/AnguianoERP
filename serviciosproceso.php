 <?php 

session_start();
if(isset($_SESSION["usuario"]) ||isset($_SESSION["Admin"]))
{

?>
<!DOCTYPE html>
 <html lang="en">
 <head>
 	<meta charset="UTF-8">
 	<title>Anguiano ERP</title>
 	    <!-- Bootstrap -->
    <link href="vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- NProgress -->
    <link href="vendors/nprogress/nprogress.css" rel="stylesheet">
    <!-- iCheck -->
    <link href="vendors/iCheck/skins/flat/green.css" rel="stylesheet">
    <!-- Datatables -->
    <link href="vendors/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
    <link href="vendors/datatables.net-buttons-bs/css/buttons.bootstrap.min.css" rel="stylesheet">
    <link href="vendors/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css" rel="stylesheet">
    <link href="vendors/datatables.net-responsive-bs/css/responsive.bootstrap.min.css" rel="stylesheet">
    <link href="vendors/datatables.net-scroller-bs/css/scroller.bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="vendors/pnotify/dist/pnotify.custom.css">
    <!-- Custom Theme Style -->
    <link href="build/css/custom.min.css" rel="stylesheet">
 </head>
<body class="nav-md">
    <div class="container body">
      <div class="main_container">
		<?php include 'sidebar.php' ?>
		<?php include 'topnavigation.php' ?>
        <!-- page content -->
        <div class="right_col" role="main">
          <div class="">
            <div class="clearfix"></div>
            <div class="row">
              <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Servicios en Proceso</h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li class="dropdown">
						<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modalRegistrarServicio"><i class="fa fa-plus"></i> Agregar Servicio</button>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr>
                          <th># Servicio</th>
                          <th>Nombe de Cliente</th>
                          <th>Marca</th>
                          <th>Modelo</th>
                          <th>Año</th>
                          <th>Fecha de Recepción</th>
                          <th>Descripción de Servicio</th>
                          <th>Operaciones</th>
                        </tr>
                      </thead>
                      	<tbody id="enProceso">
						</tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /page content -->
        <?php include 'footer.php' ?>
      </div>
    </div>

    <!-- Modal para Registrar Servicio -->
                  <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true" id="modalRegistrarServicio">
                    <div class="modal-dialog modal-lg">
                      <div class="modal-content">

                        <div class="modal-header">
                          <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
                          </button>
                          <h4 class="modal-title" id="myModalLabel">Registar Servicio</h4>
                        </div>
						<div class="modal-body">
							<div class="x_panel">
								<div class="x_content">
								<br>
									<form id="formAgregarServicio" action="" method="POST" class="form-horizontal form-label-left input_mask">

									<div class="col-md-6 col-sm-6 col-xs-12 form-group has-feedback">
									<input type="text" class="form-control has-feedback-left" id="nombre" name="nombre" placeholder="Nombre de Cliente*">
									<span class="fa fa-user form-control-feedback left" aria-hidden="true"></span>
									</div>

									<div class="col-md-6 col-sm-6 col-xs-12 form-group has-feedback">
									<input type="text" class="form-control" id="noTelefono" name="noTelefono" placeholder="Número de Telefono*">
									<span class="fa fa-phone form-control-feedback right" aria-hidden="true"></span>
									</div>

									<div class="col-md-6 col-sm-6 col-xs-12 form-group has-feedback">
									<input type="text" class="form-control has-feedback-left" id="email" name="email" placeholder="Correo Electronico">
									<span class="fa fa-envelope form-control-feedback left" aria-hidden="true"></span>
									</div>

									<div class="col-md-6 col-sm-6 col-xs-12 form-group has-feedback">
									<input type="text" class="form-control" id="noTelefonoAdicional" name="noTelefonoAdicional" placeholder="Número Telefono Adicional">
									<span class="fa fa-phone form-control-feedback right" aria-hidden="true"></span>
									</div>

									<div class="form-group">
										<label class="control-label col-md-3 col-sm-3 col-xs-12">Marca Vehiculo
										<span class="required">*</span>	
										</label>
										<div class="col-md-9 col-sm-9 col-xs-12">
										<input type="text" class="form-control" id="marcaVehiculo" name="marcaVehiculo" placeholder="Marca Vehiculo">
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3 col-sm-3 col-xs-12">Modelo Vehiculo
										<span class="required">*</span>
										</label>
										<div class="col-md-9 col-sm-9 col-xs-12">
										<input type="text" class="form-control" name="modeloVehiculo" id="modeloVehiculo" placeholder="Modelo Vehiculo">
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3 col-sm-3 col-xs-12">Año Vehiculo
										<span class="required">*</span>
										</label>
										<div class="col-md-9 col-sm-9 col-xs-12">
										<input type="text" class="form-control" name="anioVehiculo" id="anioVehiculo" placeholder="Año Vehiculo">
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3 col-sm-3 col-xs-12">Descripción Falla
										<span class="required">*</span>
										</label>
										<div class="col-md-9 col-sm-9 col-xs-12">
										<textarea id="descripcion" name="descripcion" class="resizable_textarea form-control" placeholder="Descripción de falla" style="margin: 0px -3.5px 0px 0px; width: 597px; height: 180px;"></textarea>
										</div>
									</div>
									<div class="ln_solid"></div>
									</form>
								</div>
								<span class="required">* Campos requeridos</span>
							</div>
						</div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                          <button type="button" class="btn btn-primary" id="guardarServicio">Guardar</button>
                        </div>

                      </div>
                    </div>
                  </div>
    <!-- /Modal para Registrar Servicio -->
    <!-- Modal para Finalizar Servicio -->
                  <div class="modal fade bs-example-modal-lg" id="modalFinalizarServicio" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                      <div class="modal-content">

                        <div class="modal-header">
                          <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
                          </button>
                          <h4 class="modal-title" id="myModalLabel">Finalizar Servicio</h4>
                        </div>
            <div class="modal-body">
              <div class="x_panel">
                <div class="x_content">
                <br>
                  <form id="formFinalizarServicio" action="" method="POST" class="form-horizontal form-label-left input_mask">
                  
                  <div class="col-md-6 col-sm-6 col-xs-12 form-group has-feedback">
                  <input type="text" class="form-control has-feedback-left" id="idServicio" name="idServicio" readonly="">
                  <span class="fa fa-car form-control-feedback right" aria-hidden="true"></span>
                  </div>

                  <div class="col-md-6 col-sm-6 col-xs-12 form-group has-feedback">
                  <input type="text" class="form-control has-feedback-left" id="placas" name="placas" placeholder="Placas Vehiculo*">
                  <span class="fa fa-car form-control-feedback left" aria-hidden="true"></span>
                  </div>

                  <div class="col-md-6 col-sm-6 col-xs-12 form-group has-feedback">
                  <input type="text" class="form-control" id="km" name="km" placeholder="Km Vehiculo*">
                  <span class="fa fa-car form-control-feedback right" aria-hidden="true"></span>
                  </div>

                  <div class="col-md-6 col-sm-6 col-xs-12 form-group has-feedback">
                  <input type="text" class="form-control has-feedback-left" id="unidadVehiculo" name="unidadVehiculo" placeholder="Número Unidad Vehiculo">
                  <span class="fa fa-car form-control-feedback left" aria-hidden="true"></span>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-md-3 col-sm-3 col-xs-12">Descripción Servicio Realizado
                    <span class="required">*</span>
                    </label>
                    <div class="col-md-9 col-sm-9 col-xs-12">
                    <textarea id="descripcion" name="descripcion" class="resizable_textarea form-control" placeholder="Descripción de Servicio Realizado" style="margin: 0px -3.5px 0px 0px; width: 597px; height: 180px;"></textarea>
                    </div>
                  </div>
                  <div class="ln_solid"></div>
                  </form>
                </div>
                <span class="required">* Campos requeridos</span>
              </div>
            </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                          <button type="button" class="btn btn-primary" id="finalizarServicio">Guardar</button>
                        </div>

                      </div>
                    </div>
                  </div>
    <!-- /Modal para Finalizar Servicio -->    

    <!-- jQuery -->
    <script src="vendors/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap -->
    <script src="vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <!-- FastClick -->
    <script src="vendors/fastclick/lib/fastclick.js"></script>
    <!-- NProgress -->
    <script src="vendors/nprogress/nprogress.js"></script>
    <!-- iCheck -->
    <script src="vendors/iCheck/icheck.min.js"></script>
    <!-- Datatables -->
    <script src="vendors/datatables.net/js/jquery.dataTables.min.js"></script>
    <script src="vendors/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
    <script src="vendors/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
    <script src="vendors/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
    <script src="vendors/datatables.net-buttons/js/buttons.flash.min.js"></script>
    <script src="vendors/datatables.net-buttons/js/buttons.html5.min.js"></script>
    <script src="vendors/datatables.net-buttons/js/buttons.print.min.js"></script>
    <script src="vendors/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>
    <script src="vendors/datatables.net-keytable/js/dataTables.keyTable.min.js"></script>
    <script src="vendors/datatables.net-responsive/js/dataTables.responsive.min.js"></script>
    <script src="vendors/datatables.net-responsive-bs/js/responsive.bootstrap.js"></script>
    <script src="vendors/datatables.net-scroller/js/dataTables.scroller.min.js"></script>
    <script src="vendors/jszip/dist/jszip.min.js"></script>
    <script src="vendors/pdfmake/build/pdfmake.min.js"></script>
    <script src="vendors/pdfmake/build/vfs_fonts.js"></script>

    <!-- Custom Theme Scripts -->
    <script src="build/js/custom.min.js"></script>
	<script type="text/javascript" src="vendors/jquery-validation/jquery.validate.js"></script>
	<script type="text/javascript" src="vendors/pnotify/dist/pnotify.custom.js"></script>
	<script type="text/javascript" src="js/serviciosproceso.js"></script>
  </body>
 </html> 
<?php
}else
  {
?>
<script>
  window.location.href="index.html";
</script>
<?php
}
?>