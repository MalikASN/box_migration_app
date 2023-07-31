
<?php


        if(isset($_POST['keyword'])){
            $keyword = $_POST['keyword'];



			
            include("database_connection.php");

		    $query = $connect->prepare("SELECT* from boxes where barcode = '".$keyword."' LIMIT 1");
            $query->execute();
            $result = $query -> fetch();
			echo "//".$result ["designation"];

 

            }else{
				
				echo'no keyword received';
			}

           
				
		?>

