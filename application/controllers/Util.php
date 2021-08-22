<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;
require 'phpmailer/Exception.php';
require 'phpmailer/PHPMailer.php';
require 'phpmailer/SMTP.php';

class Util {
	
	public static function send_email($email, $subject, $body) {
		$mail = new PHPMailer(true);
		try {
    		//Server settings
    		$mail->SMTPDebug = 2;                      //Enable verbose debug output
    		$mail->isSMTP();                                            //Send using SMTP
    		$mail->Host       = 'banksampah.kerjabisa.com';                     //Set the SMTP server to send through
    		$mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    		$mail->Username   = 'admin@banksampah.kerjabisa.com';                     //SMTP username
    		$mail->Password   = '%lWwuVQ7F5Z4';                               //SMTP password
    		$mail->SMTPSecure = 'ssl';            //Enable implicit TLS encryption
    		$mail->Port       = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = 			PHPMailer::ENCRYPTION_STARTTLS`
    		//Recipients
    		$mail->setFrom('admin@banksampah.kerjabisa.com', 'Bank Sampah Admin');
    		$mail->addAddress($email, 'Recepient');     //Add a recipient
    		$mail->addReplyTo('admin@banksampah.kerjabisa.com', 'Bank Sampah Admin');
		    //Content
		    $mail->isHTML(true);                                  //Set email format to HTML
		    $mail->Subject = $subject;
		    $mail->Body    = $body;
		    $mail->send();
		} catch (Exception $e) {
    		echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
		}
	}
	
	public static function send_notification($to, $title, $body) {
		$url = "https://fcm.googleapis.com/fcm/send";
    	$serverKey = 'AAAAtp-qWaY:APA91bEGHbMoZjko76dI43GNXazF_-xPZ0r34cFwAd3HxS7N6wFUDLI_689M2B5IRimdwPDvMNGgzmg3ItJJqx2GRWipkchk0lNXJyRdlE1zE_mibUlByjWftOLEqyvljqLnT43tJ0vL';
    	$notification = array('title' => $title, 'body' => $body, 'sound' => 'default', 'badge' => '1');
    	$arrayToSend = array('to' => $to, 'notification' => $notification, 'priority'=>'high');
    	$json = json_encode($arrayToSend);
    	$headers = array();
    	$headers[] = 'Content-Type: application/json';
    	$headers[] = 'Authorization: key='. $serverKey;
    	$ch = curl_init();
    	curl_setopt($ch, CURLOPT_URL, $url);
    	curl_setopt($ch, CURLOPT_CUSTOMREQUEST,"POST");
    	curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
    	curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
    	$response = curl_exec($ch);
    	if ($response === FALSE) {
    		die('FCM Send Error: ' . curl_error($ch));
    	}
    	curl_close($ch);
    	echo $response;
	}
}
