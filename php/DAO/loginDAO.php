<?php
include '../Conexion/Conexion.php';
	$sql = new MySQL();
	$query="select * from  usuarios  where nombre_usuario ='".$_POST["username"]."' and contrasena_usuario = '".$_POST["password"]."'";
	$res = $sql->query($query);

	while ($row = mysqli_fetch_array($res,MYSQLI_ASSOC))
	{
		session_start();
		$data["login_status"] ="success";
		$_SESSION["id_usuario"] = $row['id_usuario'];
		$_SESSION["usuario"] = $row['nombre_usuario'];
		//$_SESSION["id_empresa"] = $row['id_empresa'];
		echo json_encode($data);
	}
?>