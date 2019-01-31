<?php
include '../Conexion/Conexion.php';

switch ($_POST['accion']) {

	case 'guardar':
				    $sql = new MySQL();
			    $query="call  SP_ERP_INSERTA_SERVICIO('".$_POST['nombre']."','".$_POST['noTelefono']."','".$_POST['email']."','".$_POST['noTelefonoAdicional']."','".$_POST['marcaVehiculo']."','".$_POST['modeloVehiculo']."','".$_POST['anioVehiculo']."','".$_POST['descripcion']."')";
			    $res=$sql->query($query);
			    if($row = mysqli_fetch_array($res,MYSQLI_ASSOC))
			    {
			    	if($row['estatus']=='guardado')
			    	{
			    		$data['estatus']='guardado';
			    	}
					else
						$data['estatus']='actualizado';
			    }
				$data['msj']='ok';
				echo json_encode($data);
		break;


	case 'obtener':

			    $sql = new MySQL();
			    $query="call  SP_ERP_OBTENER_SERVICIOS(".$_POST['finalizado'].")";
			    $resul['query']=$query;
			    $res=$sql->query($query);
				$i=0;
				if($res->num_rows > 0) 
				{
					$resul['estaus']='true';
					while ($row = mysqli_fetch_array($res,MYSQLI_ASSOC)) {
						    $data[$i]['id_servicio']= $row['id_servicio'];
						    $data[$i]['nombre_cliente']= $row['nombre_cliente'];
							$data[$i]['marca_vehiculo']= $row['marca_vehiculo'];
							$data[$i]['modelo_vehiculo']= $row['modelo_vehiculo'];
							$data[$i]['anio_vehiculo']= $row['anio_vehiculo'];
							$data[$i]['fecha_inicio_servicio']= $row['fecha_inicio_servicio'];
							$data[$i]['descripcion_servicio']= $row['descripcion_servicio'];
							$data[$i]['km_vehiculo']= $row['km_vehiculo'];
							$data[$i]['placas_vehiculo']= $row['placas_vehiculo'];
							$data[$i]['fecha_fin_servicio']= $row['fecha_fin_servicio'];
							$data[$i]['unidad_vehiculo']= $row['unidad_vehiculo'];
							// $data[$i]['distancia']= $row['distancia'];
							// $data[$i]['tiempo']= $row['tiempo'];
							// $data[$i]['descOr']= utf8_encode($row['descOr']);
							// $data[$i]['descDest']= utf8_encode($row['descDest']);
							// $data[$i]['desc_cancelacion']= utf8_encode($row['desc_cancelacion']);
							// $data[$i]['nombreCliente']= utf8_encode($row['nombreCliente']);
							// $data[$i]['nombreOperador']= utf8_encode($row['nombreOperador']);
							$i++;	

					}
					$resul['data']=$data;
				}else
				 	$resul['estaus']='false';

				echo json_encode($resul);
		break;

	case 'eliminar':
			    $sql = new MySQL();
			    $query="call  SP_ELIMINAR_OPERADOR(".$_POST['idOperador'].")";
			    $sql->query($query);
				$data['msj']='ok';
				echo json_encode($data);
		break;

	case 'finalizar':
						    $sql = new MySQL();
			    $query="call  SP_ERP_FINALIZA_SERVICIO('".$_POST['idServicio']."','".$_POST['placas']."','".$_POST['km']."','".$_POST['unidadVehiculo']."','".$_POST['descripcion']."')";
			    $res=$sql->query($query);
			    if($row = mysqli_fetch_array($res,MYSQLI_ASSOC))
			    {
			    	if($row['estatus']=='finalizado')
			    	{
			    		$data['estatus']='finalizado';
			    	}
					else
						$data['estatus']='error';
			    }
				$data['msj']='ok';
				echo json_encode($data);
		break;
	}
