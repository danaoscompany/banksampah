<?php

include "Util.php";

class Test extends CI_Controller {
	
	public function email() {
		Util::send_email("danaoscompany@gmail.com", "Test subject", "Test message");
	}
}
