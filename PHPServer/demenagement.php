

<?php



include("database_connection.php");
$conn = mysqli_connect("localhost","root","","capturedoc");



if(!isset($_POST['new_box'])){
	

	if(isset($_POST['box_barcode'])&&isset($_POST['box_geo'])&&isset($_POST['box_barcode'])){
	


		try {
	
			$barcode=$_POST['box_barcode'];
			$geo=$_POST['box_geo'];
			$designation=$_POST['box_design'];
			
			
			$sql ="UPDATE boxes SET geolocalisation = '".$geo."'";
			
			//if(isset($_POST['box_design'])){
			//	$sql.=", designation = '".$designation."'";
			//};
			
			$sql.= " WHERE barcode = '".$barcode."'";
			
			
			$sth = $conn->query($sql);
			echo 'success';
	
		} catch(PDOException $e) {
			echo $e;
		}

	}else{
		
		echo'no data received';
		
	}




}else{
	//ADD NEW BOX
	
	try{
		$sql ="INSERT INTO boxes (barcode, geolocalisation, designation) VALUES ('".$_POST['box_barcode']."'
		, '".$_POST['box_geo']."', '".$_POST['box_design']."')";
		
		$sth = $conn->query($sql);
	    echo 'added';
	}
	
	catch(PDOException $e) {
       echo $e;
}
	
	
	
}

 
?>