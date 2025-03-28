DROP DATABASE IF EXISTS `KRSDB`;
CREATE DATABASE `KRSDB`;

USE `KRSDB`;

CREATE TABLE `user` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `full_name` varchar(255),
  `avatar` varchar(255),
  `username` varchar(255) NOT NULL,
  `password_hash` varchar(32) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role_id` integer NOT NULL,
  `status` ENUM ('Active', 'Deactivated', 'NotVerified'),
  `created_at` timestamp,
  `modified_at` timestamp,
  `modified_by` integer
);

CREATE TABLE `setting` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `created_by` integer,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp,
  `type` ENUM ('Role', 'Category', 'Semester', 'Config'),
  `modified_at` timestamp,
  `modified_by` integer
);

CREATE TABLE `subject` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `manager_id` integer,
  `created_by` integer NOT NULL,
  `category_id` integer,
  `domain_id` integer,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `description` text,
  `created_at` timestamp,
  `modified_at` timestamp,
  `modified_by` integer,
  `status` ENUM ('Active', 'Inactive') DEFAULT 'Active'
);

CREATE TABLE `lesson` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `subject_id` integer NOT NULL,
  `created_by` integer NOT NULL,
  `title` varchar(255) NOT NULL,
  `video_url` varchar(255),
  `description` text,
  `created_at` timestamp,
  `modified_at` timestamp,
  `modified_by` integer
);

CREATE TABLE `config` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `subject_id` integer,
  `type_id` integer,
  `description` varchar(255),
  `status` ENUM ('Active', 'Inactive') DEFAULT 'Active'
);

CREATE TABLE `lesson_config` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `lesson_id` integer,
  `config_id` integer
);

CREATE TABLE `class` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `subject_id` integer,
  `manager_id` integer,
  `semester_id` integer,
  `class_name` varchar(255),
  `code` varchar(255),
  `created_at` timestamp,
  `created_by` integer,
  `modified_at` timestamp,
  `modified_by` integer,
  `status` ENUM ('Public', 'Private')
);

CREATE TABLE `class_student` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `class_id` integer,
  `user_id` integer,
  `modified_at` timestamp,
  `modified_by` integer,
  `status` ENUM ('Approved', 'Unapproved')
);

CREATE TABLE `subject_manager` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `subject_id` integer,
  `manager_id` integer,
  `time` TIMESTAMP,
  `action` ENUM ('active', 'inactive', 'modified')
);

CREATE TABLE `question` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `subject_id` integer,
  `lesson_id` integer,
  `status` ENUM ('active', 'inactive'),
  `content` varchar(255),
  `img_link` varchar(255)
);

CREATE TABLE `answer_option` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `question_id` integer,
  `content` varchar(255),
  `is_answer` boolean
);

CREATE TABLE `term` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `lesson_id` integer,
  `title` varchar(255),
  `content` varchar(255),
  `status` ENUM ('Active', 'Inactive')
);

CREATE TABLE `term_domain` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `term_id` integer,
  `domain_id` integer
);

CREATE TABLE `quiz` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `subject_id` integer,
  `user_id` integer
);

CREATE TABLE `quiz_question` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `quiz_id` integer,
  `user_id` integer,
  `question_id` integer
);

CREATE TABLE `quiz_answer` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `question_id` integer,
  `is_correct` boolean
);

CREATE TABLE `quiz_lesson` (
  `quiz_id` integer,
  `lesson_id` integer,
  `num_of_question` integer
);

CREATE TABLE `quiz_result` (
  `quiz_id` integer,
  `user_id` integer,
  `grade` double
);

CREATE TABLE `quiz_config` (
  `quiz_id` integer,
  `domain_id` integer,
  `num_of_question` integer
);

-- Create the new question_config table for many-to-many relationship
CREATE TABLE `question_config` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `config_id` integer NOT NULL,
  `question_id` integer NOT NULL
);

create table `user_flashcard` (
	`id` integer PRIMARY KEY AUTO_INCREMENT,
  `term_id` integer,
  `user_id` integer
);

ALTER TABLE `question_config` ADD FOREIGN KEY (`config_id`) REFERENCES `config` (`id`);

ALTER TABLE `question_config` ADD FOREIGN KEY (`question_id`) REFERENCES `question` (`id`);

ALTER TABLE `class_student` ADD FOREIGN KEY (`class_id`) REFERENCES `class` (`id`);

ALTER TABLE `class_student` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `setting` ADD FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `user` ADD FOREIGN KEY (`role_id`) REFERENCES `setting` (`id`);

ALTER TABLE `subject` ADD FOREIGN KEY (`category_id`) REFERENCES `setting` (`id`);

ALTER TABLE `subject` ADD FOREIGN KEY (`domain_id`) REFERENCES `setting` (`id`);

ALTER TABLE `lesson` ADD FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

ALTER TABLE `subject` ADD FOREIGN KEY (`manager_id`) REFERENCES `user` (`id`);

ALTER TABLE `subject` ADD FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `subject` ADD FOREIGN KEY (`modified_by`) REFERENCES `user` (`id`);

ALTER TABLE `class_student` ADD FOREIGN KEY (`modified_by`) REFERENCES `user` (`id`);

ALTER TABLE `class` ADD FOREIGN KEY (`modified_by`) REFERENCES `user` (`id`);

ALTER TABLE `class` ADD FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

ALTER TABLE `class` ADD FOREIGN KEY (`manager_id`) REFERENCES `user` (`id`);

ALTER TABLE `lesson_config` ADD FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`);

ALTER TABLE `lesson_config` ADD FOREIGN KEY (`config_id`) REFERENCES `config` (`id`);

ALTER TABLE `subject_manager` ADD FOREIGN KEY (`manager_id`) REFERENCES `user` (`id`);

ALTER TABLE `subject_manager` ADD FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

ALTER TABLE `question` ADD FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

ALTER TABLE `answer_option` ADD FOREIGN KEY (`question_id`) REFERENCES `question` (`id`);

ALTER TABLE `term` ADD FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`);

ALTER TABLE `term_domain` ADD FOREIGN KEY (`term_id`) REFERENCES `term` (`id`);

ALTER TABLE `term_domain` ADD FOREIGN KEY (`domain_id`) REFERENCES `config` (`id`);

ALTER TABLE `config` ADD FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

ALTER TABLE `config` ADD FOREIGN KEY (`type_id`) REFERENCES `setting` (`id`);

ALTER TABLE `class` ADD FOREIGN KEY (`semester_id`) REFERENCES `setting` (`id`);

ALTER TABLE `question` ADD FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`);

ALTER TABLE `quiz` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `quiz` ADD FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

ALTER TABLE `quiz_question` ADD FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`);

ALTER TABLE `quiz_question` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `quiz_question` ADD FOREIGN KEY (`question_id`) REFERENCES `question` (`id`);

ALTER TABLE `quiz_answer` ADD FOREIGN KEY (`question_id`) REFERENCES `quiz_question` (`id`);

ALTER TABLE `quiz_lesson` ADD FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`);

ALTER TABLE `quiz_lesson` ADD FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`);

ALTER TABLE `quiz_result` ADD FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`);

ALTER TABLE `quiz_result` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `quiz_config` ADD FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`);

ALTER TABLE `quiz_config` ADD FOREIGN KEY (`domain_id`) REFERENCES `setting` (`id`);

ALTER TABLE `user_flashcard` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `user_flashcard` ADD FOREIGN KEY (`term_id`) REFERENCES `term` (`id`);