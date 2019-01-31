<?php
include '../Conexion/Conexion.php';

switch ($_POST['accion']) {

	case 'guardar':
			    $sql = new MySQL();
			    $query="call  SP_GUARDA_OPERADORES('".utf8_decode($_POST['nombre'])."','".$_POST['noRegistro']."','".utf8_decode($_POST['contra'])."','".$_POST['tel']."','".$_POST['modelo']."','".$_POST['placas']."',".$_POST['id_empresa'].",".$_POST['id_operador'].")";
			    $res=$sql->query($query);
			    
			    if($row = mysqli_fetch_array($res,MYSQLI_ASSOC))
			    {
			    	if($row['estatus']=='guardado')
			    	{
			    		$data['estatus']='guardado';
						$data['nomenclatura']=$row['nomenclatura'];
			    	}
					else
						$data['estatus']='actualizado';
			    }
				$data['msj']='ok';
				echo json_encode($data);
		break;


	case 'obtener':
			    $sql = new MySQL();
			    $query="call  SP_ERP_OBTENER_CLIENTES()";
			    $res=$sql->query($query);
				$i=0;
				if($res->num_rows > 0) 
				{
					$resul['estaus']='true';
					while ($row = mysqli_fetch_array($res,MYSQLI_ASSOC)) {
						    $data[$i]['id_cliente']= $row['id_cliente'];
						    $data[$i]['nombre_cliente']= $row['nombre_cliente'];
							// $data[$i]['nombre_completo']= utf8_encode($row['nombre_completo']);
							// $data[$i]['telefono']= utf8_encode($row['telefono']);
							// $data[$i]['password']= $row['contrasena'];
							// $data[$i]['modelo']= $row['modelo'];
							// $data[$i]['placas']= $row['placas'];
							// $data[$i]['fecha_alta']= $row['fecha_alta'];
							// $data[$i]['latitud']= $row['latitud'];
							// $data[$i]['longitud']= $row['longitud'];
							// $data[$i]['contadorServicios']= ($row['contadorServicios']==null ? 0 : $row['contadorServicios']);

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
	}
