<?php

include "Util.php";

class User extends CI_Controller {
	
	public function index() {
		echo "OK";
	}
	
	public function get_news_categories() {
		echo json_encode($this->db->query("SELECT * FROM `news_categories` ORDER BY `category_en`")->result_array());
	}
	
	public function get_news_by_category_id() {
		$categoryID = $this->input->post('category_id');
		echo json_encode($this->db->query("SELECT * FROM `news` WHERE `news_category_id`=" . $categoryID . " ORDER BY `date` DESC")
			->result_array());
	}
	
	public function get_nearest_banks() {
		$latitude = doubleval($this->input->post('latitude'));
		$longitude = doubleval($this->input->post('longitude'));
		$banks = $this->db->query("SELECT *, SQRT(POW(69.1 * (latitude - " . $latitude . "), 2) + POW(69.1 * (" . $longitude . " - longitude) * COS(latitude / 57.3), 2)) AS distance FROM `banks` ORDER BY distance")->result_array();
		for ($i=0; $i<sizeof($banks); $i++) {
			$banks[$i]['images'] = $this->db->query("SELECT * FROM `bank_images` WHERE `bank_id`=" . $banks[$i]['id'])->result_array();
		}
		echo json_encode($banks);
	}
	
	public function get_banks() {
		$banks = $this->db->query("SELECT * FROM `banks` ORDER BY `title`")->result_array();
		for ($i=0; $i<sizeof($banks); $i++) {
			$banks[$i]['images'] = $this->db->query("SELECT * FROM `bank_images` WHERE `bank_id`=" . $banks[$i]['id'])->result_array();
		}
		echo json_encode($banks);
	}
	
	public function get_open_banks() {
		$time = $this->input->post('time');
		$banks = $this->db->query("SELECT * FROM `banks` WHERE TIMEDIFF('" . $time . "', `open_hour`)>0 AND TIMEDIFF(`close_hour`, '" . $time . "')>0")->result_array();
		for ($i=0; $i<sizeof($banks); $i++) {
			$banks[$i]['images'] = $this->db->query("SELECT * FROM `bank_images` WHERE `bank_id`=" . $banks[$i]['id'])->result_array();
		}
		echo json_encode($banks);
	}
	
	public function get_informations() {
		$informations = $this->db->query("SELECT * FROM `informations` ORDER BY `date` DESC LIMIT 10")->result_array();
		echo json_encode($informations);
	}
	
	public function get_materials() {
		$materials = $this->db->query("SELECT * FROM `materials` ORDER BY `date` DESC")->result_array();
		echo json_encode($materials);
	}
	
	public function send_verification_code() {
		$email = $this->input->post('email');
		$verificationCode = $this->input->post('verification_code');
		Util::send_email($email, "Your Bank Sampah verification code: " . $verificationCode,
			"Please enter this 6-digit verification code into the available field: <b>" . $verificationCode . "</b>");
	}
	
	public function signup_as_nasabah() {
		$name = $this->input->post('name');
		$email = $this->input->post('email');
		$phone = $this->input->post('phone');
		$password = $this->input->post('password');
		$address = $this->input->post('address');
		$this->db->insert('users', array(
			'name' => $name,
			'email' => $email,
			'phone' => $phone,
			'password' => $password,
			'address' => $address,
			'role' => 'nasabah',
			'email_verified' => 0
		));
	}
	
	public function signup_as_bsu() {
		$name = $this->input->post('name');
		$email = $this->input->post('email');
		$phone = $this->input->post('phone');
		$password = $this->input->post('password');
		$address = $this->input->post('address');
		$this->db->insert('banks', array(
			'title' => $name,
			'phone' => $phone,
			'address' => $address
		));
		$bankID = $this->db->insert_id();
		$this->db->insert('users', array(
			'bank_id' => $bankID,
			'name' => $name,
			'email' => $email,
			'phone' => $phone,
			'password' => $password,
			'address' => $address,
			'role' => 'bsu',
			'email_verified' => 0
		));
	}
	
	public function verify_user_email() {
		$email = $this->input->post('email');
		$this->db->query("UPDATE `users` SET `email_verified`=1 WHERE `email`='" . $email . "'");
	}
	
	public function login() {
		$email = $this->input->post('email');
		$password = $this->input->post('password');
		$users = $this->db->query("SELECT * FROM `users` WHERE `email`='" . $email . "' AND `password`='" . $password . "'")
			->result_array();
		if (sizeof($users) > 0) {
			$user = $users[0];
			$user['response_code'] = 1;
			echo json_encode($user);
		} else {
			echo json_encode(array(
				'response_code' => -1
			));
		}
	}
	
	public function get_monthly_statistics() {
		$month = intval($this->input->post('month'));
		$year = intval($this->input->post('year'));
		$transactions = $this->db->query("SELECT *, SUM(weight) as total_weights FROM `transactions` WHERE MONTH(`date`)=" . $month . " AND YEAR(`date`)=" . $year . " GROUP BY `item_id`")->result_array();
		echo json_encode($transactions);
	}
	
	public function get_exchange_rates() {
		$limit = intval($this->input->post('limit'));
		$exchangeRates = $this->db->query("SELECT * FROM `exchange_rates` LIMIT " . $limit)->result_array();
		echo json_encode($exchangeRates);
	}
	
	public function get_bank_admins() {
		$limit = intval($this->input->post('limit'));
		$bankAdmins = $this->db->query("SELECT * FROM `bank_admins` LIMIT " . $limit)->result_array();
		for ($i=0; $i<sizeof($bankAdmins); $i++) {
			$bankAdmins[$i]['role'] = $this->db->query("SELECT * FROM `bank_admin_roles` WHERE `id`=" . $bankAdmins[$i]['role_id'])
				->row_array();
		}
		echo json_encode($bankAdmins);
	}
	
	public function get_item_categories() {
		$categories = $this->db->query("SELECT * FROM `items`")->result_array();
		echo json_encode($categories);
	}
	
	public function get_default_categories() {
		$bankID = intval($this->input->post('bank_id'));
		$categories = $this->db->query("SELECT * FROM `items` WHERE `bank_id`=" . $bankID)->result_array();
		if (sizeof($categories) == 0) {
			$categories = $this->db->query("SELECT * FROM `default_items`")->result_array();
		}
		echo json_encode($categories);
	}
	
	public function get_transactions() {
		$userID = intval($this->input->post('user_id'));
		$status = $this->input->post('status');
		$transactions = $this->db->query("SELECT * FROM `transactions` WHERE `status`='" . $status . "' AND `user_id`=" . $userID . " ORDER BY `date` DESC")->result_array();
		for ($i=0; $i<sizeof($transactions); $i++) {
			$transactions[$i]['bank'] = $this->db->query("SELECT * FROM `banks` WHERE `id`=" . $transactions[$i]['bank_id'])->row_array();
			$items = json_decode($transactions[$i]['items'], true);
			if ($items != null) {
				for ($j=0; $j<sizeof($items); $j++) {
					$items[$j]['item'] = $this->db->query("SELECT * FROM `items` WHERE `id`=" . $items[$j]['item_id'])->row_array();
				}
			}
			$transactions[$i]['items'] = $items;
		}
		echo json_encode($transactions);
	}
	
	public function add_transaction() {
		$userID = intval($this->input->post('user_id'));
		$bankID = intval($this->input->post('bank_id'));
		$items = $this->input->post('items');
		$date = $this->input->post('date');
		$this->db->insert('transactions', array(
			'user_id' => $userID,
			'bank_id' => $bankID,
			'items' => $items,
			'date' => $date,
			'status' => 'waiting_request_received'
		));
		$bankUser = $this->db->query("SELECT * FROM `users` WHERE `bank_id`=" . $bankID)->row_array();
		Util::send_notification($bankUser['fcm_key'], "Request Antar Sampah", "Seorang user melakukan request pengantaran sampah, klik untuk mengecek daftar barangnya");
	}
	
	public function get_settings() {
		echo json_encode($this->db->query("SELECT * FROM `settings` LIMIT 1")->row_array());
	}
	
	public function get_item_by_id() {
		$id = $this->input->post('id');
		$item = $this->db->query("SELECT * FROM `items` WHERE `id`=" . $id)->row_array();
		echo json_encode($item);
	}
	
	public function cancel_transaction_request() {
		$id = $this->input->post('id');
		$this->db->query("UPDATE `transactions` SET `status`='cancelled' WHERE `id`=" . $id);
	}
	
	public function update_fcm_key() {
		$userID = intval($this->input->post('user_id'));
		$fcmKey = $this->input->post('fcm_key');
		$this->db->query("UPDATE `users` SET `fcm_key`='" . $fcmKey . "' WHERE `id`=" . $userID);
	}
}
