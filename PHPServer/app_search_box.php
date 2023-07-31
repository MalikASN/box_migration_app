
[

		<?php


$keyword = $_GET['keyword'];



			
            include("database_connection.php");

			$query = $connect->prepare("SELECT* from boxes where designation LIKE '%".$keyword."%'");
            $query->execute();
            $result = $query -> fetchAll();




            foreach( $result as $row ) {
				
		?>




		{
		"id":"<?php echo $row['id']; ?>",
		"designation":"<?php 
		$description = str_replace('"', "'", $row['designation']);
		echo utf8_encode($description); ?>"
		},
			<?php } ?>
		
]