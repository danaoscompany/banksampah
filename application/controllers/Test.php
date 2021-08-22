<?php

include "Util.php";

class Test extends CI_Controller {
	
	public function email() {
		Util::send_email("danaos.apps@gmail.com", "Your Bank Sampah verification code: 123456",
			"Please enter this 6-digit verification code into the available field: <b>123456</b>");
	}
	
	public function echo_test() {
		echo "This is test text.";
	}
	
	public function fcm() {
		Util::send_notification("dfo2NDyJRdqYPnPQJ4414v:APA91bEzuY25xLa26FK2ORmUcDzSBptHdvqD4FesiWRVccKc8F1xvqkPUn4qb5GS2rg7tAphU83GNklhsGGmouC0G9CJ11smz5aI5gfZXF_TocMyNTaHr7wrru_KhxYNOaSSzmc3K2g0", "This is title", "This is body");
	}
}
