<?php


include("database_connection.php");



 if(empty($_POST["user_email"]) || empty($_POST["user_password"]))
 {
  echo'both fields required';
 }
 else
 {
  $query = "
  SELECT * FROM users 
  WHERE user_email = :user_email
  ";
  $statement = $connect->prepare($query);
  $statement->execute(
   array(
    'user_email' => $_POST["user_email"]
   )
  );
  $count = $statement->rowCount();
  if($count > 0)
  {
   $result = $statement->fetchAll();
   foreach($result as $row)
   {
    if(password_verify($_POST["user_password"], $row["user_password"]))
    {
	 echo 'success';
    }
    else
    {
     echo $row["user_password"]."vs".$_POST["user_password"].' is a wrong password';
    }
   }
  }
  else
  {
   echo'No such user';
  }
 }



?>