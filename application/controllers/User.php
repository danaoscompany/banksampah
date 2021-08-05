<?php

class User extends CI_Controller {
	
	public function get_news_categories() {
		echo json_encode($this->db->query("SELECT * FROM `news_categories` ORDER BY `category_en`")->result_array());
	}
	
	public function get_news_by_category_id() {
		$categoryID = $this->input->post('category_id');
		echo json_encode($this->db->query("SELECT * FROM `news` WHERE `news_category_id`=" . $categoryID . " ORDER BY `date` DESC")
			->result_array());
	}
}
