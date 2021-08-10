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
    		$mail->SMTPDebug = 0;                      //Enable verbose debug output
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
}
