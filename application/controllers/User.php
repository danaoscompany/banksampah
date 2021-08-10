<?php

include "Util.php";

class User extends CI_Controller {
	
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
}
