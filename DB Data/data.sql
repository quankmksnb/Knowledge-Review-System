-- Insert settings (Roles & Categories)
INSERT INTO setting (title, created_at, type) VALUES
('Admin', NOW(), 'Role'),
('Teacher', NOW(), 'Role'),
('Student', NOW(), 'Role'),
('Training Manager', NOW(), 'Role'),
('Subject Manager', NOW(), 'Role'),
('IT', NOW(), 'Category'),
('Business Administration', NOW(), 'Category'),
('Linguistics', NOW(), 'Category'),
('Fall 2024', NOW(), 'Semester'),
('Spring 2025', NOW(), 'Semester');

-- Insert Users
INSERT INTO `user` (`full_name`, `avatar`, `username`, `password_hash`, `email`, `role_id`, `status`, `created_at`)
VALUES 
('Administrator', NULL, 'admin', 'AzJ0pQDk26suhEs9vaIKikTIbJw=', 'admin@example.com', 1, 'Active', NOW()),
('John Doe', NULL, 'johndoe', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'johndoe@example.com', 2, 'Active', NOW()),
('Alice Smith', NULL, 'alicesmith', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'alicesmith@example.com', 3, 'Active', NOW()),
('Robert Brown', NULL, 'robertbrown', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'robertbrown@example.com', 3, 'Active', NOW()),
('Emily Davis', NULL, 'emilydavis', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'emilydavis@example.com', 2, 'Active', NOW()),
('Michael Wilson', NULL, 'michaelwilson', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'michaelwilson@example.com', 4, 'Active', NOW());

-- Insert Subjects
INSERT INTO subject (manager_id, created_by, category_id, domain_id, name, code, description, created_at) VALUES
(1, 1, 6, 6, 'Physics Fundamentals', 'PHYS01', 'Basic concepts of physics for high school students', NOW()),
(1, 1, 6, 6, 'Organic Chemistry', 'CHEM01', 'Introduction to organic chemistry principles', NOW()),
(1, 1, 6, 7, 'Computer Science Basics', 'CS01', 'Fundamentals of computer programming and algorithms', NOW()),
(1, 1, 6, 7, 'English Literature', 'ENG01', 'Study of classic and modern literature', NOW()),
(1, 1, 6, 7, 'World History', 'HIST01', 'Exploration of major historical events worldwide', NOW());

-- Insert Classes (Ensure Manager IDs exist)
INSERT INTO krsdb.`class` (subject_id, manager_id, semester_id, class_name, code, created_at, status) 
VALUES ('1', '3', '9', 'FER202_SE1870', 'SE1870', NOW(), 'Public'),
('2', '4', '9', 'ECC201_SE1870', 'GD1871', NOW(), 'Public');

-- Insert Class Students (Ensure User IDs exist)
INSERT INTO `class_student` (`class_id`, `user_id`, `status`, `modified_at`, `modified_by`)
VALUES
(1, 2, 'Approved', NOW(), 2),
(1, 3, 'Unapproved', NOW(), 2),
(1, 4, 'Unapproved', NOW(), 2),
(2, 5, 'Unapproved', NOW(), 3),
(2, 6, 'Unapproved', NOW(), 3),
(1, 2, 'Unapproved', NOW(), 4),
(1, 3, 'Unapproved', NOW(), 4),
(1, 4, 'Unapproved', NOW(), 5),
(1, 5, 'Unapproved', NOW(), 5),
(1, 6, 'Unapproved', NOW(), 6);

-- Insert Sample Lessons for class_id = 1
INSERT INTO lesson (subject_id, created_by, title, description, created_at) 
VALUES
(1, 1, 'Introduction to Programming', 'Basics of programming concepts', NOW()),
(1, 1, 'Object-Oriented Programming', 'Understanding OOP principles', NOW());

-- Retrieve lesson IDs
SET @lesson1_id = LAST_INSERT_ID();
INSERT INTO lesson (subject_id, created_by, title, description, created_at) 
VALUES (1, 1, 'Advanced OOP', 'Deep dive into OOP concepts', NOW());
SET @lesson2_id = LAST_INSERT_ID();
INSERT INTO `lesson` (`subject_id`, `created_by`, `title`, `description`, `created_at`, `modified_at`, `modified_by`)
VALUES 
(1, 1, 'Introduction to Quantum Physics', 'This lesson covers the fundamental principles of quantum physics including wave-particle duality and quantum entanglement.', NOW(), NOW(), 1),
(1, 1, 'Quantum Mechanics: Advanced Concepts', 'An in-depth look at advanced quantum mechanics topics such as the Schrödinger equation and quantum field theory.', NOW(), NOW(), 1),
(2, 2, 'Modern Art History', 'Explore the development of modern art from Impressionism to Abstract Expressionism.', NOW(), NOW(), 2),
(2, 2, 'Art Techniques: Mastering Oil Painting', 'Learn advanced oil painting techniques used by master artists.', NOW(), NOW(), 2),
(3, 3, 'Introduction to Machine Learning', 'An overview of machine learning concepts and algorithms, including supervised and unsupervised learning.', NOW(), NOW(), 3),
(3, 3, 'Deep Learning with Neural Networks', 'Detailed study of deep learning techniques using neural networks and practical implementation.', NOW(), NOW(), 3),
(1, 1, 'Quantum Computing: The Future', 'Examine the principles and potential of quantum computing technology.', NOW(), NOW(), 1),
(2, 2, 'Art Criticism and Theory', 'Analysis of art criticism theories and methodologies for evaluating artworks.', NOW(), NOW(), 2),
(3, 3, 'Data Science: Practical Applications', 'Learn how to apply data science techniques to real-world problems.', NOW(), NOW(), 3),
(1, 1, 'Quantum Physics Experiments', 'Hands-on experiments to understand and explore quantum physics concepts.', NOW(), NOW(), 1);


INSERT INTO `question` (`subject_id`, `lesson_id`, `content`)
VALUES 
(1, 1, 'What is wave-particle duality and how does it affect our understanding of quantum physics?'),
(1, 2, 'Explain the Schrödinger equation and its significance in quantum mechanics.'),
(2, 3, 'Discuss the key characteristics and impact of Impressionism on modern art.'),
(2, 4, 'What are the main techniques used in oil painting by master artists?'),
(3, 5, 'Describe the differences between supervised and unsupervised learning algorithms.'),
(3, 6, 'How do neural networks contribute to advancements in deep learning?'),
(1, 7, 'What are the main principles behind quantum computing and its potential applications?'),
(2, 8, 'Analyze the role of art criticism in shaping public perception of artworks.'),
(3, 9, 'How can data science techniques be applied to solve problems in healthcare?'),
(1, 10, 'What experiments can demonstrate the principles of quantum entanglement?');

-- Insert Sample Terms
INSERT INTO term (lesson_id, content) VALUES
(@lesson1_id, 'Variable: A storage location with a name and a value'),
(@lesson1_id, 'Function: A block of reusable code that performs a task'),
(@lesson2_id, 'Class: A blueprint for creating objects'),
(@lesson2_id, 'Inheritance: Mechanism to derive new classes from existing ones');

-- Insert Sample Questions
INSERT INTO question (subject_id, lesson_id, content) VALUES
(1, @lesson1_id, 'What is a variable in programming?'),
(1, @lesson1_id, 'What is the purpose of functions?'),
(1, @lesson2_id, 'What is an object in OOP?'),
(1, @lesson2_id, 'Explain the concept of polymorphism.');

-- Sample Answers for Questions

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
-- Answers for Question 1
(1, 'Option A for Question 1', FALSE),
(1, 'Option B for Question 1', TRUE),  -- Correct Answer
(1, 'Option C for Question 1', FALSE),
(1, 'Option D for Question 1', FALSE),

-- Answers for Question 2
(2, 'Option A for Question 2', FALSE),
(2, 'Option B for Question 2', FALSE),
(2, 'Option C for Question 2', TRUE),  -- Correct Answer
(2, 'Option D for Question 2', FALSE),

-- Answers for Question 3
(3, 'Option A for Question 3', FALSE),
(3, 'Option B for Question 3', FALSE),
(3, 'Option C for Question 3', FALSE),
(3, 'Option D for Question 3', TRUE),  -- Correct Answer

-- Answers for Question 4
(4, 'Option A for Question 4', TRUE),  -- Correct Answer
(4, 'Option B for Question 4', FALSE),
(4, 'Option C for Question 4', FALSE),
(4, 'Option D for Question 4', FALSE);

