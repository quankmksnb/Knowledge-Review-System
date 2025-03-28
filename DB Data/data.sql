-- Insert settings (Roles & Categories)
INSERT INTO `setting` (`title`, `created_at`, `type`) VALUES
('Admin', NOW(), 'Role'),
('Teacher', NOW(), 'Role'),
('Student', NOW(), 'Role'),
('Training Manager', NOW(), 'Role'),
('Subject Manager', NOW(), 'Role'),
('Module', NOW(), 'Config'),
('Domain', NOW(), 'Config'),
('Chapter', NOW(), 'Config'),
('Technology', NOW(), 'Category'),
('Business Administration', NOW(), 'Category'),
('Linguistics', NOW(), 'Category'),
('Health Sciences', NOW(), 'Category'),
('Engineering', NOW(), 'Category'),
('Arts & Humanities', NOW(), 'Category'),
('Law & Political Science', NOW(), 'Category'),
('Social Sciences', NOW(), 'Category'),
('Natural Sciences', NOW(), 'Category'),
('Mathematics & Statistics', NOW(), 'Category'),
('Education', NOW(), 'Category'),
('Psychology', NOW(), 'Category'),
('Environmental Science', NOW(), 'Category'),
('Media & Communication', NOW(), 'Category'),
('Hospitality & Tourism', NOW(), 'Category'),
('Medical & Life Sciences', NOW(), 'Category'),
('Computer Science', NOW(), 'Category'),
('Finance & Accounting', NOW(), 'Category'),
('Marketing & Management', NOW(), 'Category'),
('Architecture & Design', NOW(), 'Category'),
('Agriculture & Forestry', NOW(), 'Category'),
('Fall 2024', Now(), 'Semester'),
('Spring 2025', NOW(), 'Semester');

-- Insert Users
INSERT INTO `user` (`full_name`, `avatar`, `username`, `password_hash`, `email`, `role_id`, `status`, `created_at`) VALUES 
('Administrator', NULL, 'admin', 'AzJ0pQDk26suhEs9vaIKikTIbJw=', 'admin@example.com', 1, 'Active', NOW()),
('Student', NULL, 'student', 'AzJ0pQDk26suhEs9vaIKikTIbJw=', 'admin@example.com', 3, 'Active', NOW()),
('Teacher', NULL, 'teacher', 'AzJ0pQDk26suhEs9vaIKikTIbJw=', 'teacher@example.com', 2, 'Active', NOW()),
('John Doe', NULL, 'johndoe', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'johndoe@example.com', 2, 'Active', NOW()),
('Alice Smith', NULL, 'alicesmith', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'alicesmith@example.com', 3, 'Active', NOW()),
('Robert Brown', NULL, 'robertbrown', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'robertbrown@example.com', 3, 'Active', NOW()),
('Emily Davis', NULL, 'emilydavis', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'emilydavis@example.com', 2, 'Active', NOW()),
('Michael Wilson', NULL, 'michaelwilson', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'michaelwilson@example.com', 4, 'Active', NOW());

-- Insert Subjects (One per Category)
INSERT INTO `subject` (`manager_id`, `created_by`, `category_id`, `domain_id`, `name`, `code`, `description`, `created_at`) VALUES
-- Technology
(1, 1, 9, 9, 'Artificial Intelligence', 'AI01', 'Introduction to machine learning and AI principles.', NOW()),
-- Business Administration
(1, 1, 10, 10, 'Corporate Finance', 'BA01', 'Fundamentals of corporate finance and investment.', NOW()),
-- Linguistics
(1, 1, 11, 11, 'Applied Linguistics', 'LNG01', 'Study of language in real-world contexts.', NOW()),
-- Health Sciences
(1, 1, 12, 12, 'Human Anatomy', 'HS01', 'Comprehensive study of human anatomy and physiology.', NOW()),
-- Engineering
(1, 1, 13, 13, 'Electrical Engineering', 'ENG01', 'Introduction to circuits, signals, and systems.', NOW()),
-- Arts & Humanities
(1, 1, 14, 14, 'World Literature', 'AH01', 'Exploration of classical and modern literary works.', NOW()),
-- Law & Political Science
(1, 1, 15, 15, 'International Law', 'LPS01', 'Study of legal principles governing international relations.', NOW()),
-- Social Sciences
(1, 1, 16, 16, 'Sociology', 'SS01', 'Examination of human society and social behavior.', NOW()),
-- Natural Sciences
(1, 1, 17, 17, 'Physics Fundamentals', 'NS01', 'Basic concepts of physics and their applications.', NOW()),
-- Mathematics & Statistics
(1, 1, 18, 18, 'Probability & Statistics', 'MS01', 'Introduction to probability theory and statistical methods.', NOW()),
-- Education
(1, 1, 19, 19, 'Educational Psychology', 'EDU01', 'Study of how people learn and teaching methods.', NOW()),
-- Psychology
(1, 1, 20, 20, 'Cognitive Psychology', 'PSY01', 'Exploration of human thought and cognitive processes.', NOW()),
-- Environmental Science
(1, 1, 21, 21, 'Environmental Studies', 'ES01', 'Understanding environmental issues and sustainability.', NOW()),
-- Media & Communication
(1, 1, 22, 22, 'Mass Communication', 'MC01', 'Analysis of media influence and communication theories.', NOW()),
-- Hospitality & Tourism
(1, 1, 23, 23, 'Hotel Management', 'HT01', 'Principles of hospitality and tourism industry.', NOW()),
-- Medical & Life Sciences
(1, 1, 24, 24, 'Microbiology', 'MLS01', 'Study of microorganisms and their applications.', NOW()),
-- Computer Science
(1, 1, 25, 25, 'Data Structures & Algorithms', 'CS01', 'Introduction to efficient data organization and algorithms.', NOW()),
-- Finance & Accounting
(1, 1, 26, 26, 'Financial Accounting', 'FA01', 'Basics of accounting and financial reporting.', NOW()),
-- Marketing & Management
(1, 1, 27, 27, 'Digital Marketing', 'MM01', 'Fundamentals of online marketing and SEO.', NOW()),
-- Architecture & Design
(1, 1, 28, 28, 'Architectural Design', 'AD01', 'Introduction to design principles and architecture.', NOW()),
-- Agriculture & Forestry
(1, 1, 29, 29, 'Sustainable Agriculture', 'AF01', 'Principles of eco-friendly and efficient farming.', NOW());
-- Insert Classes for Fall 2024 and Spring 2025
INSERT INTO `class` (`subject_id`, `manager_id`, `semester_id`, `class_name`, `code`, `created_at`, `status`) VALUES 

-- Technology
(1, 3, 30, 'Artificial Intelligence - Fall', 'AI01-F24', NOW(), 'Public'),
-- Business Administration
(2, 3, 30, 'Corporate Finance - Fall', 'BA01-F24', NOW(), 'Private'),
-- Linguistics
(3, 3, 30, 'Applied Linguistics - Fall', 'LNG01-F24', NOW(), 'Public'),
-- Health Sciences
(4, 6, 30, 'Human Anatomy - Fall', 'HS01-F24', NOW(), 'Private'),
-- Engineering
(5, 3, 30, 'Electrical Engineering - Fall', 'ENG01-F24', NOW(), 'Public'),
-- Arts & Humanities
(6, 6, 30, 'World Literature - Fall', 'AH01-F24', NOW(), 'Private'),
-- Law & Political Science
(7, 1, 30, 'International Law - Fall', 'LPS01-F24', NOW(), 'Public'),
-- Social Sciences
(8, 3, 30, 'Sociology - Fall', 'SS01-F24', NOW(), 'Private'),
-- Natural Sciences
(9, 6, 30, 'Physics Fundamentals - Fall', 'NS01-F24', NOW(), 'Public'),
-- Mathematics & Statistics
(10, 1, 30, 'Probability & Statistics - Fall', 'MS01-F24', NOW(), 'Private'),
-- Education
(11, 3, 31, 'Educational Psychology - Spring', 'EDU01-S25', NOW(), 'Public'),
-- Psychology
(12, 6, 31, 'Cognitive Psychology - Spring', 'PSY01-S25', NOW(), 'Private'),
-- Environmental Science
(13, 1, 31, 'Environmental Studies - Spring', 'ES01-S25', NOW(), 'Public'),
-- Media & Communication
(14, 3, 31, 'Mass Communication - Spring', 'MC01-S25', NOW(), 'Private'),
-- Hospitality & Tourism
(15, 6, 31, 'Hotel Management - Spring', 'HT01-S25', NOW(), 'Public'),
-- Medical & Life Sciences
(16, 1, 31, 'Microbiology - Spring', 'MLS01-S25', NOW(), 'Private'),
-- Computer Science
(17, 3, 31, 'Data Structures & Algorithms - Spring', 'CS01-S25', NOW(), 'Public'),

-- Finance & Accounting
(18, 6, 31, 'Financial Accounting - Spring', 'FA01-S25', NOW(), 'Private'),

-- Marketing & Management
(19, 1, 31, 'Digital Marketing - Spring', 'MM01-S25', NOW(), 'Public'),

-- Architecture & Design
(20, 3, 31, 'Architectural Design - Spring', 'AD01-S25', NOW(), 'Private'),

-- Agriculture & Forestry
(21, 6, 31, 'Sustainable Agriculture - Spring', 'AF01-S25', NOW(), 'Public');


-- Insert Class Students
INSERT INTO `class_student` (`class_id`, `user_id`, `status`, `modified_at`, `modified_by`) VALUES
(1, 2, 'Approved', NOW(), 2),
(1, 3, 'Unapproved', NOW(), 2),
(1, 4, 'Unapproved', NOW(), 2),
(1, 5, 'Unapproved', NOW(), 5),
(1, 6, 'Unapproved', NOW(), 6),
(2, 5, 'Unapproved', NOW(), 3),
(2, 6, 'Unapproved', NOW(), 3);