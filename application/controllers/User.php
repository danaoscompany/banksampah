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
		echo json_encode($banks);
	}
	
	public function get_informations() {
		$informations = $this->db->query("SELECT * FROM `informations` ORDER BY `date` DESC")->result_array();
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
}
