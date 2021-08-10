<?php

class Util {
	
	static void send_email($to, $subject, $message) {
		$headers = "From: admin@kerjabisa.com\r\n";
		$headers .= "Reply-To: admin@kerjabisa.com\r\n";
		$headers .= "MIME-Version: 1.0\r\n";
		$headers .= "Content-Type: text/html; charset=UTF-8\r\n";
		mail($to, $subject, $message, $headers);
	}
}
