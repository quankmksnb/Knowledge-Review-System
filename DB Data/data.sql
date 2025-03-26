-- Insert settings (Roles & Categories)
INSERT INTO `setting` (`title`, `created_at`, `type`) VALUES
('Admin', NOW(), 'Role'),
('Teacher', NOW(), 'Role'),
('Student', NOW(), 'Role'),
('Training Manager', NOW(), 'Role'),
('Subject Manager', NOW(), 'Role'),
('Technology', NOW(), 'Category'), -- Changed from 'IT' to 'Technology'
('Business Administration', NOW(), 'Category'),
('Linguistics', NOW(), 'Category'),
('Fall 2024', NOW(), 'Semester'),
('Spring 2025', NOW(), 'Semester'),
('Module', NOW(), 'Config'),
('Domain', NOW(), 'Config'),
('Chapter', NOW(), 'Config');

-- Insert Users
INSERT INTO `user` (`full_name`, `avatar`, `username`, `password_hash`, `email`, `role_id`, `status`, `created_at`) VALUES 
('Administrator', NULL, 'admin', 'AzJ0pQDk26suhEs9vaIKikTIbJw=', 'admin@example.com', 1, 'Active', NOW()),
('Student', NULL, 'student', 'AzJ0pQDk26suhEs9vaIKikTIbJw=', 'admin@example.com', 3, 'Active', NOW()),
('John Doe', NULL, 'johndoe', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'johndoe@example.com', 2, 'Active', NOW()),
('Alice Smith', NULL, 'alicesmith', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'alicesmith@example.com', 3, 'Active', NOW()),
('Robert Brown', NULL, 'robertbrown', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'robertbrown@example.com', 3, 'Active', NOW()),
('Emily Davis', NULL, 'emilydavis', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'emilydavis@example.com', 2, 'Active', NOW()),
('Michael Wilson', NULL, 'michaelwilson', 'qpphyiMDgLDHCoWIRDq348IzeM0=', 'michaelwilson@example.com', 4, 'Active', NOW());

-- Insert Subjects
INSERT INTO `subject` (`manager_id`, `created_by`, `category_id`, `domain_id`, `name`, `code`, `description`, `created_at`) VALUES
(1, 1, 6, 6, 'Physics Fundamentals', 'PHYS01', 'Basic concepts of physics for high school students', NOW()),
(1, 1, 6, 6, 'Organic Chemistry', 'CHEM01', 'Introduction to organic chemistry principles', NOW()),
(1, 1, 6, 7, 'Computer Science Basics', 'CS01', 'Fundamentals of computer programming and algorithms', NOW()),
(1, 1, 6, 7, 'English Literature', 'ENG01', 'Study of classic and modern literature', NOW()),
(1, 1, 6, 7, 'World History', 'HIST01', 'Exploration of major historical events worldwide', NOW());

-- Insert Classes
INSERT INTO `class` (`subject_id`, `manager_id`, `semester_id`, `class_name`, `code`, `created_at`, `status`) VALUES 
(1, 4, 9, 'Physics Fundamentals', 'PHY1872', NOW(), 'Public'),
(2, 3, 9, 'DBF202_SE1873', 'DB1873', NOW(), 'Public'),
(1, 4, 10, 'WEB101_SE1874', 'WB1874', NOW(), 'Private'),
(2, 3, 10, 'SWE301_SE1875', 'SW1875', NOW(), 'Public'),
(1, 4, 10, 'GIT101_SE1876', 'GT1876', NOW(), 'Public');

-- Insert Class Students
INSERT INTO `class_student` (`class_id`, `user_id`, `status`, `modified_at`, `modified_by`) VALUES
(1, 2, 'Approved', NOW(), 2),
(1, 3, 'Unapproved', NOW(), 2),
(1, 4, 'Unapproved', NOW(), 2),
(1, 5, 'Unapproved', NOW(), 5),
(1, 6, 'Unapproved', NOW(), 6),
(2, 5, 'Unapproved', NOW(), 3),
(2, 6, 'Unapproved', NOW(), 3);

-- Insert Lessons with detailed content in the description
INSERT INTO `lesson` (`subject_id`, `created_by`, `title`, `description`, `created_at`, `video_url`) VALUES
(1, 1, 'Introduction to Quantum Physics', 
'This lesson introduces the fundamental principles of quantum physics. Topics covered include:
- **Wave-Particle Duality**: Understanding how particles such as electrons exhibit both wave-like and particle-like properties.
- **Quantum Superposition**: Exploring the concept that particles exist in multiple states simultaneously until measured.
- **Quantum Entanglement**: Learning about the phenomenon where particles become interconnected, such that the state of one instantly influences the state of another, regardless of distance.
- **Heisenberg Uncertainty Principle**: Discussing the limitation on simultaneously knowing the position and momentum of a particle with precision.
The lesson includes examples like the double-slit experiment to illustrate these concepts.', 
NOW(), 'https://www.youtube.com/watch?v=g550H4e5FCY'),

(1, 1, 'Quantum Mechanics: Advanced Concepts', 
'This lesson dives deeper into quantum mechanics with the following topics:
- **Schrödinger Equation**: Derivation and application of the time-dependent and time-independent Schrödinger equation to solve for the wavefunction of a quantum system.
- **Quantum States and Operators**: Understanding how operators act on quantum states to extract measurable quantities like energy and momentum.
- **Quantum Tunneling**: Exploring the phenomenon where particles can pass through energy barriers that they classically shouldn’t be able to cross, with applications in scanning tunneling microscopy.
- **Quantum Field Theory Basics**: An introduction to the framework that combines quantum mechanics with special relativity, focusing on particle interactions.
Practical examples include solving the particle-in-a-box problem and discussing the hydrogen atom.', 
NOW(), NULL),

(1, 1, 'Quantum Computing: The Future', 
'This lesson explores the principles and potential of quantum computing:
- **Qubits and Superposition**: How quantum bits (qubits) differ from classical bits by existing in a superposition of states, enabling parallel computation.
- **Quantum Gates**: Introduction to quantum gates (e.g., Hadamard, CNOT) and how they manipulate qubits to perform computations.
- **Quantum Algorithms**: Overview of algorithms like Shor’s algorithm for factoring large numbers and Grover’s algorithm for searching unsorted databases.
- **Applications of Quantum Computing**: Discussing potential uses in cryptography, optimization problems, and drug discovery.
- **Challenges**: Addressing current limitations, such as decoherence and error correction in quantum systems.
The lesson includes a case study on how quantum computing could revolutionize cryptography.', 
NOW(), NULL),

(1, 1, 'Quantum Physics Experiments', 
'This lesson focuses on hands-on experiments to understand quantum physics:
- **Double-Slit Experiment**: Demonstrating wave-particle duality by observing interference patterns when electrons pass through two slits.
- **Photoelectric Effect**: Experiment to verify the particle nature of light, showing how photons eject electrons from a metal surface, supporting Einstein’s quantum theory of light.
- **Stern-Gerlach Experiment**: Illustrating quantum spin by passing silver atoms through a magnetic field, revealing discrete spin states.
- **Bell’s Theorem Experiment**: Testing quantum entanglement and non-locality by measuring correlations between entangled particles.
The lesson includes step-by-step instructions for setting up these experiments in a lab setting and analyzing the results.', 
NOW(), NULL),

(1, 1, 'Mechanics: Newton’s Laws', 
'This lesson covers Newton’s laws of motion with detailed content:
- **First Law (Law of Inertia)**: An object at rest stays at rest, and an object in motion stays in motion with a constant velocity unless acted upon by a net external force. Examples include a book on a table and a hockey puck sliding on ice.
- **Second Law (F = ma)**: The acceleration of an object is directly proportional to the net force acting on it and inversely proportional to its mass. Includes solving problems like calculating the acceleration of a 2 kg object under a 10 N force.
- **Third Law (Action-Reaction)**: For every action, there is an equal and opposite reaction. Examples include the recoil of a gun and the propulsion of a rocket.
- **Applications**: Discussing real-world applications like car motion, friction, and tension in ropes.
The lesson includes practice problems and diagrams to illustrate each law.', 
NOW(), 'hhttps://www.youtube.com/watch?v=g550H4e5FCY&t=3s'),

(1, 1, 'Thermodynamics: Heat Transfer', 
'This lesson explores the principles of heat transfer in thermodynamics:
- **Conduction**: How heat transfers through a material without the movement of the material itself. Example: Heat transfer through a metal rod when one end is heated.
- **Convection**: Heat transfer by the movement of fluids (liquids or gases). Example: The circulation of warm air in a room heated by a radiator.
- **Radiation**: Heat transfer through electromagnetic waves, such as infrared radiation. Example: The warmth felt from the sun.
- **Laws of Thermodynamics**: Introduction to the first law (conservation of energy) and the second law (entropy increase in an isolated system).
- **Applications**: Discussing heat transfer in engineering systems like heat exchangers and insulators.
The lesson includes calculations, such as determining the rate of heat transfer through a wall using Fourier’s law.', 
NOW(), NULL),

(2, 2, 'Hydrocarbons: Alkanes', 
'This lesson covers the chemistry of alkanes, a type of hydrocarbon:
- **Structure of Alkanes**: Alkanes are saturated hydrocarbons with single bonds between carbon atoms (general formula: CnH2n+2). Examples include methane (CH4), ethane (C2H6), and propane (C3H6).
- **Nomenclature**: Learning IUPAC naming rules for alkanes, such as naming straight-chain and branched alkanes (e.g., 2-methylpropane).
- **Physical Properties**: Discussing boiling points, melting points, and solubility, which increase with molecular size due to stronger London dispersion forces.
- **Chemical Properties**: Exploring reactions of alkanes, including combustion (e.g., CH4 + 2O2 → CO2 + 2H2O) and halogenation (e.g., chlorination of methane to form chloromethane).
- **Applications**: Use of alkanes as fuels (e.g., gasoline, natural gas) and in the petrochemical industry.
The lesson includes practice problems on naming alkanes and balancing combustion reactions.', 
NOW(), 'https://www.youtube.com/watch?v=hydrocarbons101'),

(2, 2, 'Functional Groups: Alcohols', 
'This lesson introduces alcohols, a key functional group in organic chemistry:
- **Structure of Alcohols**: Alcohols contain a hydroxyl group (-OH) attached to a carbon atom (general formula: R-OH). Examples include methanol (CH3OH) and ethanol (C2H5OH).
- **Classification**: Primary, secondary, and tertiary alcohols based on the number of carbon atoms attached to the carbon bearing the -OH group.
- **Nomenclature**: IUPAC naming of alcohols, such as propan-1-ol and 2-methylpropan-2-ol.
- **Physical Properties**: High boiling points due to hydrogen bonding; solubility in water decreases with increasing carbon chain length.
- **Chemical Properties**: Reactions of alcohols, including dehydration to form alkenes (e.g., ethanol → ethene), oxidation to form aldehydes or ketones, and esterification with carboxylic acids.
- **Applications**: Use of ethanol in beverages, methanol in industrial solvents, and alcohols in pharmaceuticals.
The lesson includes examples of reaction mechanisms and practice naming exercises.', 
NOW(), NULL),

(3, 3, 'Introduction to Machine Learning', 
'This lesson provides an overview of machine learning concepts:
- **What is Machine Learning?**: Definition and types of machine learning: supervised learning (e.g., regression, classification), unsupervised learning (e.g., clustering, dimensionality reduction), and reinforcement learning.
- **Supervised Learning**: Using labeled data to train models. Example: Predicting house prices (regression) using features like size and location.
- **Unsupervised Learning**: Finding patterns in unlabeled data. Example: Clustering customers into segments based on purchasing behavior.
- **Key Algorithms**: Overview of algorithms like linear regression, decision trees, k-means clustering, and principal component analysis (PCA).
- **Evaluation Metrics**: Understanding accuracy, precision, recall, and mean squared error for evaluating model performance.
- **Applications**: Real-world uses in image recognition, natural language processing, and recommendation systems.
The lesson includes a simple example of training a linear regression model on a small dataset.', 
NOW(), NULL),

(3, 3, 'Deep Learning with Neural Networks', 
'This lesson explores deep learning and neural networks:
- **Neural Network Basics**: Structure of a neural network: input layer, hidden layers, and output layer. Neurons, weights, biases, and activation functions (e.g., sigmoid, ReLU).
- **Forward Propagation**: How data passes through the network to make predictions.
- **Backpropagation**: The process of updating weights using gradient descent to minimize the loss function.
- **Types of Neural Networks**: Feedforward neural networks, convolutional neural networks (CNNs) for image processing, and recurrent neural networks (RNNs) for sequential data.
- **Practical Implementation**: Building a simple neural network using Python and TensorFlow to classify handwritten digits (MNIST dataset).
- **Applications**: Use of deep learning in autonomous vehicles, speech recognition, and medical diagnosis.
The lesson includes a step-by-step coding example and a discussion of overfitting and regularization techniques.', 
NOW(), NULL),

(3, 3, 'Data Science: Practical Applications', 
'This lesson covers practical applications of data science:
- **Data Collection and Cleaning**: Techniques for gathering data (e.g., web scraping, APIs) and cleaning it (e.g., handling missing values, removing duplicates).
- **Exploratory Data Analysis (EDA)**: Using statistical methods and visualization (e.g., histograms, scatter plots) to understand data distributions and relationships.
- **Feature Engineering**: Creating new features (e.g., extracting the day of the week from a date) to improve model performance.
- **Modeling**: Applying machine learning models like random forests or gradient boosting to solve problems such as predicting customer churn.
- **Visualization and Communication**: Creating dashboards with tools like Tableau or Matplotlib to present findings to stakeholders.
- **Case Study**: Analyzing a retail dataset to identify factors driving sales and making recommendations to increase revenue.
The lesson includes Python code snippets for EDA and modeling.', 
NOW(), NULL),

(3, 3, 'Programming: Variables', 
'This lesson introduces the basics of variables in programming:
- **What are Variables?**: Variables as containers for storing data values. Example: `x = 5` assigns the value 5 to the variable `x`.
- **Data Types**: Common data types like integers (`int`), floating-point numbers (`float`), strings (`str`), and booleans (`bool`).
- **Declaring Variables**: Syntax for declaring variables in Python (e.g., `name = "Alice"`), Java (e.g., `String name = "Alice";`), and C++ (e.g., `string name = "Alice";`).
- **Variable Scope**: Understanding local vs. global variables and their accessibility within a program.
- **Operations with Variables**: Performing arithmetic operations (e.g., `sum = x + y`), string concatenation (e.g., `greeting = "Hello, " + name`), and logical operations.
- **Best Practices**: Naming conventions (e.g., using meaningful names like `student_age` instead of `sa`) and avoiding reserved keywords.
The lesson includes coding exercises to practice declaring and manipulating variables in Python.', 
NOW(), 'https://www.youtube.com/watch?v=variables101');

-- Insert Configs (Chapters)
INSERT INTO `config` (`subject_id`, `type_id`, `description`, `status`) VALUES
(1, 13, 'Chapter 1: Physics Basics', 'Active'),
(1, 13, 'Chapter 2: Thermodynamics', 'Active'),
(1, 13, 'Chapter 3: Quantum Physics', 'Active'),
(2, 13, 'Chapter 1: Hydrocarbons', 'Active'),
(2, 13, 'Chapter 2: Functional Groups', 'Active'),
(2, 13, 'Chapter 3: Reactions', 'Active'),
(3, 13, 'Chapter 1: Programming Basics', 'Active'),
(3, 13, 'Chapter 2: Data Structures', 'Active');

-- Insert Lesson Configs (Linking Lessons to Chapters)
INSERT INTO `lesson_config` (`lesson_id`, `config_id`) VALUES
-- Subject 1 (Physics Fundamentals) Chapters
(1, 3),  -- Introduction to Quantum Physics -> Chapter 3: Quantum Physics
(2, 3),  -- Quantum Mechanics: Advanced Concepts -> Chapter 3: Quantum Physics
(3, 3),  -- Quantum Computing: The Future -> Chapter 3: Quantum Physics
(4, 3),  -- Quantum Physics Experiments -> Chapter 3: Quantum Physics
(5, 1),  -- Mechanics: Newton’s Laws -> Chapter 1: Physics Basics
(6, 2),  -- Thermodynamics: Heat Transfer -> Chapter 2: Thermodynamics

-- Subject 2 (Organic Chemistry) Chapters
(7, 4),  -- Hydrocarbons: Alkanes -> Chapter 1: Hydrocarbons
(8, 5),  -- Functional Groups: Alcohols -> Chapter 2: Functional Groups

-- Subject 3 (Computer Science Basics) Chapters
(9, 7),   -- Introduction to Machine Learning -> Chapter 1: Programming Basics
(10, 8),  -- Deep Learning with Neural Networks -> Chapter 2: Data Structures
(11, 7),  -- Data Science: Practical Applications -> Chapter 1: Programming Basics
(12, 7);  -- Programming: Variables -> Chapter 1: Programming Basics

INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 1, 'active', 'What does the wave-particle duality principle state about electrons?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Electrons always behave as particles and never as waves.', false),
(LAST_INSERT_ID(), 'Electrons exhibit both wave-like and particle-like properties depending on the experiment.', true),
(LAST_INSERT_ID(), 'Electrons only behave as waves and cannot act as particles.', false),
(LAST_INSERT_ID(), 'Electrons are neither waves nor particles but a third type of entity.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 1, 'active', 'In quantum entanglement, what happens when the state of one particle is measured?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'The state of the other particle remains unchanged.', false),
(LAST_INSERT_ID(), 'The state of the other particle is instantly determined, regardless of distance.', true),
(LAST_INSERT_ID(), 'The particles become disentangled and behave independently.', false),
(LAST_INSERT_ID(), 'The measurement has no effect on either particle.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 1, 'active', 'What does the Heisenberg Uncertainty Principle state about a particle’s position and momentum?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'They can both be measured with infinite precision simultaneously.', false),
(LAST_INSERT_ID(), 'The more precisely the position is known, the less precisely the momentum can be known.', true),
(LAST_INSERT_ID(), 'They are completely independent of each other.', false),
(LAST_INSERT_ID(), 'Measuring one does not affect the other.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 2, 'active', 'What is the primary purpose of the Schrödinger equation in quantum mechanics?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'To calculate the speed of a particle in a quantum system.', false),
(LAST_INSERT_ID(), 'To determine the wavefunction of a quantum system, describing its behavior.', true),
(LAST_INSERT_ID(), 'To measure the exact position and momentum of a particle simultaneously.', false),
(LAST_INSERT_ID(), 'To describe the classical trajectory of a particle.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 2, 'active', 'What phenomenon allows particles to pass through energy barriers in quantum tunneling?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'The particle gains enough energy to overcome the barrier.', false),
(LAST_INSERT_ID(), 'The particle’s wavefunction has a non-zero probability of existing on the other side of the barrier.', true),
(LAST_INSERT_ID(), 'The barrier is lowered by external forces.', false),
(LAST_INSERT_ID(), 'The particle splits into two smaller particles to pass through.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 2, 'active', 'What does quantum field theory combine to describe particle interactions?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Classical mechanics and general relativity.', false),
(LAST_INSERT_ID(), 'Quantum mechanics and special relativity.', true),
(LAST_INSERT_ID(), 'Thermodynamics and quantum mechanics.', false),
(LAST_INSERT_ID(), 'Electromagnetism and classical physics.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 3, 'active', 'How does a qubit differ from a classical bit in quantum computing?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'A qubit can only be in a state of 0 or 1, like a classical bit.', false),
(LAST_INSERT_ID(), 'A qubit can exist in a superposition of 0 and 1 states simultaneously.', true),
(LAST_INSERT_ID(), 'A qubit cannot perform computations.', false),
(LAST_INSERT_ID(), 'A qubit is always in a fixed state.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 3, 'active', 'What is the primary purpose of Shor’s algorithm in quantum computing?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'To search unsorted databases efficiently.', false),
(LAST_INSERT_ID(), 'To factor large numbers exponentially faster than classical algorithms.', true),
(LAST_INSERT_ID(), 'To optimize machine learning models.', false),
(LAST_INSERT_ID(), 'To simulate quantum systems.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 3, 'active', 'What is a major challenge in quantum computing related to decoherence?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'It causes qubits to lose their quantum state due to environmental interactions.', true),
(LAST_INSERT_ID(), 'It increases the speed of quantum computations.', false),
(LAST_INSERT_ID(), 'It prevents qubits from entering superposition.', false),
(LAST_INSERT_ID(), 'It eliminates the need for error correction.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 4, 'active', 'What does the double-slit experiment demonstrate about electrons?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Electrons always behave as particles.', false),
(LAST_INSERT_ID(), 'Electrons exhibit wave-particle duality by creating an interference pattern.', true),
(LAST_INSERT_ID(), 'Electrons do not interact with light.', false),
(LAST_INSERT_ID(), 'Electrons cannot pass through slits.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 4, 'active', 'What does the photoelectric effect experiment demonstrate about light?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Light behaves solely as a wave.', false),
(LAST_INSERT_ID(), 'Light has a particle nature, as photons eject electrons from a metal surface.', true),
(LAST_INSERT_ID(), 'Light cannot interact with matter.', false),
(LAST_INSERT_ID(), 'Light’s intensity does not affect electron emission.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 4, 'active', 'What does the Stern-Gerlach experiment reveal about quantum spin?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Quantum spin is continuous and can take any value.', false),
(LAST_INSERT_ID(), 'Quantum spin is discrete, showing distinct spin states when particles pass through a magnetic field.', true),
(LAST_INSERT_ID(), 'Quantum spin does not exist in particles.', false),
(LAST_INSERT_ID(), 'Quantum spin is unaffected by magnetic fields.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 5, 'active', 'According to Newton’s First Law, what happens to a book on a table if no net external force acts on it?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'The book accelerates in a random direction.', false),
(LAST_INSERT_ID(), 'The book remains at rest.', true),
(LAST_INSERT_ID(), 'The book moves with constant acceleration.', false),
(LAST_INSERT_ID(), 'The book decelerates due to gravity.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 5, 'active', 'A 2 kg object experiences a net force of 10 N. What is its acceleration according to Newton’s Second Law?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), '2 m/s²', false),
(LAST_INSERT_ID(), '5 m/s²', true),
(LAST_INSERT_ID(), '10 m/s²', false),
(LAST_INSERT_ID(), '20 m/s²', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 5, 'active', 'When a rocket propels upward, what is the reaction force according to Newton’s Third Law?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'The rocket’s weight pulling it downward.', false),
(LAST_INSERT_ID(), 'The exhaust gases being pushed downward by the rocket.', true),
(LAST_INSERT_ID(), 'The air resistance acting on the rocket.', false),
(LAST_INSERT_ID(), 'The gravitational pull of the Earth.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 6, 'active', 'What is the primary mechanism of heat transfer in conduction?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Heat transfer through the movement of fluids.', false),
(LAST_INSERT_ID(), 'Heat transfer through a material without the movement of the material itself.', true),
(LAST_INSERT_ID(), 'Heat transfer through electromagnetic waves.', false),
(LAST_INSERT_ID(), 'Heat transfer through the emission of light.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 6, 'active', 'How does convection transfer heat in a room heated by a radiator?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Through direct contact between the radiator and the air.', false),
(LAST_INSERT_ID(), 'Through the circulation of warm air rising and cooler air sinking.', true),
(LAST_INSERT_ID(), 'Through electromagnetic radiation emitted by the radiator.', false),
(LAST_INSERT_ID(), 'Through the radiator absorbing heat from the air.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(1, 6, 'active', 'What does the Second Law of Thermodynamics state about entropy in an isolated system?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Entropy decreases over time.', false),
(LAST_INSERT_ID(), 'Entropy remains constant.', false),
(LAST_INSERT_ID(), 'Entropy increases over time.', true),
(LAST_INSERT_ID(), 'Entropy is unrelated to energy.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(2, 7, 'active', 'What is the general formula for alkanes?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'CnHn', false),
(LAST_INSERT_ID(), 'CnH2n+2', true),
(LAST_INSERT_ID(), 'CnH2n', false),
(LAST_INSERT_ID(), 'CnH2n-2', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(2, 7, 'active', 'What is the IUPAC name for the alkane with the structure CH3-CH(CH3)-CH3?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Propane', false),
(LAST_INSERT_ID(), '2-Methylpropane', true),
(LAST_INSERT_ID(), 'Butane', false),
(LAST_INSERT_ID(), '2-Methylbutane', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(2, 7, 'active', 'What is the primary product of the complete combustion of methane (CH4)?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Carbon monoxide and water', false),
(LAST_INSERT_ID(), 'Carbon dioxide and water', true),
(LAST_INSERT_ID(), 'Carbon and hydrogen gas', false),
(LAST_INSERT_ID(), 'Soot and oxygen', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(2, 8, 'active', 'What functional group defines an alcohol?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Carbonyl group (-C=O)', false),
(LAST_INSERT_ID(), 'Hydroxyl group (-OH)', true),
(LAST_INSERT_ID(), 'Carboxyl group (-COOH)', false),
(LAST_INSERT_ID(), 'Alkene group (C=C)', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(2, 8, 'active', 'How is ethanol (CH3CH2OH) classified as an alcohol?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Primary alcohol', true),
(LAST_INSERT_ID(), 'Secondary alcohol', false),
(LAST_INSERT_ID(), 'Tertiary alcohol', false),
(LAST_INSERT_ID(), 'Quaternary alcohol', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(2, 8, 'active', 'What is the product when ethanol undergoes dehydration to form an alkene?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Ethane', false),
(LAST_INSERT_ID(), 'Ethene', true),
(LAST_INSERT_ID(), 'Ethanal', false),
(LAST_INSERT_ID(), 'Ethanoic acid', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 9, 'active', 'Which type of machine learning uses labeled data to train models?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Unsupervised learning', false),
(LAST_INSERT_ID(), 'Supervised learning', true),
(LAST_INSERT_ID(), 'Reinforcement learning', false),
(LAST_INSERT_ID(), 'Semi-supervised learning', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 9, 'active', 'What is an example of a supervised learning task?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Clustering customers into segments based on purchasing behavior.', false),
(LAST_INSERT_ID(), 'Predicting house prices using features like size and location.', true),
(LAST_INSERT_ID(), 'Finding patterns in unlabeled data.', false),
(LAST_INSERT_ID(), 'Optimizing a robot’s actions through trial and error.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 9, 'active', 'Which metric measures the proportion of correctly predicted positive cases in a classification model?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Mean squared error', false),
(LAST_INSERT_ID(), 'Precision', true),
(LAST_INSERT_ID(), 'Accuracy', false),
(LAST_INSERT_ID(), 'Recall', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 10, 'active', 'What is the role of an activation function in a neural network?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'To initialize the weights of the network.', false),
(LAST_INSERT_ID(), 'To introduce non-linearity, allowing the network to learn complex patterns.', true),
(LAST_INSERT_ID(), 'To reduce the number of neurons in the network.', false),
(LAST_INSERT_ID(), 'To calculate the loss function.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 10, 'active', 'What is the purpose of backpropagation in training a neural network?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'To pass data forward through the network.', false),
(LAST_INSERT_ID(), 'To update weights using gradient descent to minimize the loss function.', true),
(LAST_INSERT_ID(), 'To initialize the biases of the network.', false),
(LAST_INSERT_ID(), 'To increase the number of hidden layers.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 10, 'active', 'Which type of neural network is best suited for image processing tasks?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Recurrent Neural Network (RNN)', false),
(LAST_INSERT_ID(), 'Convolutional Neural Network (CNN)', true),
(LAST_INSERT_ID(), 'Feedforward Neural Network', false),
(LAST_INSERT_ID(), 'Self-Organizing Map (SOM)', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 11, 'active', 'What is a common step in data cleaning before modeling?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Creating visualizations of the data.', false),
(LAST_INSERT_ID(), 'Handling missing values by imputing or removing them.', true),
(LAST_INSERT_ID(), 'Training a machine learning model.', false),
(LAST_INSERT_ID(), 'Reducing the dataset size by sampling.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 11, 'active', 'What is an example of feature engineering in a dataset with dates?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'Removing all date-related columns.', false),
(LAST_INSERT_ID(), 'Extracting the day of the week from a date to use as a new feature.', true),
(LAST_INSERT_ID(), 'Converting dates to random numbers.', false),
(LAST_INSERT_ID(), 'Ignoring date columns in the analysis.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 11, 'active', 'What is a common tool used for creating dashboards to visualize data science findings?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'TensorFlow', false),
(LAST_INSERT_ID(), 'Tableau', true),
(LAST_INSERT_ID(), 'Scikit-learn', false),
(LAST_INSERT_ID(), 'Pandas', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 12, 'active', 'What is the purpose of a variable in programming?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'To store data values that can be used and modified in a program.', true),
(LAST_INSERT_ID(), 'To define the structure of a program.', false),
(LAST_INSERT_ID(), 'To execute loops and conditionals.', false),
(LAST_INSERT_ID(), 'To create functions.', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 12, 'active', 'Which data type would you use to store the value "Hello, World!" in Python?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'int', false),
(LAST_INSERT_ID(), 'float', false),
(LAST_INSERT_ID(), 'str', true),
(LAST_INSERT_ID(), 'bool', false);
INSERT INTO `question` (`subject_id`, `lesson_id`, `status`, `content`, `img_link`) VALUES
(3, 12, 'active', 'What is the difference between a local and a global variable?', NULL);

INSERT INTO `answer_option` (`question_id`, `content`, `is_answer`) VALUES
(LAST_INSERT_ID(), 'A local variable is accessible throughout the program, while a global variable is limited to a function.', false),
(LAST_INSERT_ID(), 'A local variable is defined inside a function and is only accessible there, while a global variable is accessible throughout the program.', true),
(LAST_INSERT_ID(), 'A local variable cannot be modified, while a global variable can.', false),
(LAST_INSERT_ID(), 'There is no difference between local and global variables.', false);

INSERT INTO question_config (question_id, config_id) VALUES
-- Subject 1 (Physics Fundamentals, subject_id = 1)
(1, 3),   -- Question 1 (Lesson 1: Introduction to Quantum Physics) -> Chapter 3: Quantum Physics
(2, 3),   -- Question 2 (Lesson 1: Introduction to Quantum Physics) -> Chapter 3: Quantum Physics
(3, 3),   -- Question 3 (Lesson 1: Introduction to Quantum Physics) -> Chapter 3: Quantum Physics
(4, 3),   -- Question 4 (Lesson 2: Quantum Mechanics: Advanced Concepts) -> Chapter 3: Quantum Physics
(5, 3),   -- Question 5 (Lesson 2: Quantum Mechanics: Advanced Concepts) -> Chapter 3: Quantum Physics
(6, 3),   -- Question 6 (Lesson 2: Quantum Mechanics: Advanced Concepts) -> Chapter 3: Quantum Physics
(7, 3),   -- Question 7 (Lesson 3: Quantum Computing: The Future) -> Chapter 3: Quantum Physics
(8, 3),   -- Question 8 (Lesson 3: Quantum Computing: The Future) -> Chapter 3: Quantum Physics
(9, 3),   -- Question 9 (Lesson 3: Quantum Computing: The Future) -> Chapter 3: Quantum Physics
(10, 3),  -- Question 10 (Lesson 4: Quantum Physics Experiments) -> Chapter 3: Quantum Physics
(11, 3),  -- Question 11 (Lesson 4: Quantum Physics Experiments) -> Chapter 3: Quantum Physics
(12, 3),  -- Question 12 (Lesson 4: Quantum Physics Experiments) -> Chapter 3: Quantum Physics
(13, 1),  -- Question 13 (Lesson 5: Mechanics: Newton’s Laws) -> Chapter 1: Physics Basics
(14, 1),  -- Question 14 (Lesson 5: Mechanics: Newton’s Laws) -> Chapter 1: Physics Basics
(15, 1),  -- Question 15 (Lesson 5: Mechanics: Newton’s Laws) -> Chapter 1: Physics Basics
(16, 2),  -- Question 16 (Lesson 6: Thermodynamics: Heat Transfer) -> Chapter 2: Thermodynamics
(17, 2),  -- Question 17 (Lesson 6: Thermodynamics: Heat Transfer) -> Chapter 2: Thermodynamics
(18, 2),  -- Question 18 (Lesson 6: Thermodynamics: Heat Transfer) -> Chapter 2: Thermodynamics

-- Subject 2 (Organic Chemistry, subject_id = 2)
(19, 4),  -- Question 19 (Lesson 7: Hydrocarbons: Alkanes) -> Chapter 1: Hydrocarbons
(20, 4),  -- Question 20 (Lesson 7: Hydrocarbons: Alkanes) -> Chapter 1: Hydrocarbons
(21, 4),  -- Question 21 (Lesson 7: Hydrocarbons: Alkanes) -> Chapter 1: Hydrocarbons
(22, 5),  -- Question 22 (Lesson 8: Functional Groups: Alcohols) -> Chapter 2: Functional Groups
(23, 5),  -- Question 23 (Lesson 8: Functional Groups: Alcohols) -> Chapter 2: Functional Groups
(24, 5),  -- Question 24 (Lesson 8: Functional Groups: Alcohols) -> Chapter 2: Functional Groups

-- Subject 3 (Computer Science Basics, subject_id = 3)
(25, 7),  -- Question 25 (Lesson 9: Introduction to Machine Learning) -> Chapter 1: Programming Basics
(26, 7),  -- Question 26 (Lesson 9: Introduction to Machine Learning) -> Chapter 1: Programming Basics
(27, 7),  -- Question 27 (Lesson 9: Introduction to Machine Learning) -> Chapter 1: Programming Basics
(28, 8),  -- Question 28 (Lesson 10: Deep Learning with Neural Networks) -> Chapter 2: Data Structures
(29, 8),  -- Question 29 (Lesson 10: Deep Learning with Neural Networks) -> Chapter 2: Data Structures
(30, 8),  -- Question 30 (Lesson 10: Deep Learning with Neural Networks) -> Chapter 2: Data Structures
(31, 7),  -- Question 31 (Lesson 11: Data Science: Practical Applications) -> Chapter 1: Programming Basics
(32, 7),  -- Question 32 (Lesson 11: Data Science: Practical Applications) -> Chapter 1: Programming Basics
(33, 7),  -- Question 33 (Lesson 11: Data Science: Practical Applications) -> Chapter 1: Programming Basics
(34, 7),  -- Question 34 (Lesson 12: Programming: Variables) -> Chapter 1: Programming Basics
(35, 7),  -- Question 35 (Lesson 12: Programming: Variables) -> Chapter 1: Programming Basics
(36, 7);  -- Question 36 (Lesson 12: Programming: Variables) -> Chapter 1: Programming Basics

INSERT INTO term (lesson_id, content) VALUES
(1, 'Variable: A storage location with a name and a value.'),
(1, 'Data Type: Specifies the type of data a variable can hold.'),
(1, 'Loop: A control structure that repeats a block of code.'),
(1, 'Conditional Statement: Executes different code blocks based on conditions.'),
(1, 'Algorithm: A step-by-step procedure for solving a problem.'),
(1, 'Syntax: The set of rules that define the structure of a programming language.'),
(1, 'Debugging: The process of finding and fixing errors in code.'),
(1, 'IDE: Integrated Development Environment - a software application for programming.');

-- Terms for lesson_id 2 (Object-Oriented Programming)
INSERT INTO term (lesson_id, content) VALUES
(2, 'Class: A blueprint for creating objects.'),
(2, 'Object: An instance of a class.'),
(2, 'Inheritance: Mechanism to derive new classes from existing ones.'),
(2, 'Polymorphism: Ability of objects to take on multiple forms.'),
(2, 'Encapsulation: Bundling data and methods within a class.'),
(2, 'Abstraction: Hiding complex implementation details.'),
(2, 'Method: A function associated with an object.');

-- Terms for lesson_id 3 (Advanced OOP)
INSERT INTO term (lesson_id, content) VALUES
(3, 'Design Pattern: A reusable solution to a common software design problem.'),
(3, 'Dependency Injection: A technique for achieving loose coupling between classes.'),
(3, 'Reflection: The ability of a program to inspect and modify its own structure and behavior at runtime.'),
(3, 'Concurrency: The ability of a program to execute multiple tasks simultaneously.'),
(3, 'Serialization: The process of converting an object into a stream of bytes.'),
(3, 'Garbage Collection: Automatic memory management in some programming languages.');

-- Terms for lesson_id 4 (Introduction to Quantum Physics)
INSERT INTO term (lesson_id, content) VALUES
(4, 'Wave-particle duality: The concept that every particle or quantum entity may be described as either a particle or a wave.'),
(4, 'Quantum entanglement: A physical phenomenon that occurs when pairs or groups of particles are generated or interact in ways such that the quantum state of each particle cannot be described independently.'),
(4, 'Superposition: The principle that a quantum system can exist in multiple states simultaneously.'),
(4, 'Quantum tunneling: A quantum mechanical phenomenon where a particle tunnels through a barrier that it classically could not surmount.'),
(4, 'Heisenberg uncertainty principle: States that certain pairs of physical properties, like position and momentum, cannot both be known to arbitrary precision.');

-- Terms for lesson_id 5 (Quantum Mechanics: Advanced Concepts)
INSERT INTO term (lesson_id, content) VALUES
(5, 'Schrödinger equation: A linear partial differential equation that describes the wave function or state function of a quantum-mechanical system.'),
(5, 'Quantum field theory: A theoretical framework in which quantum mechanical systems are described by fields.'),
(5, 'Dirac equation: A relativistic wave equation derived by Paul Dirac in 1928, which describes all spin-1⁄2 massive particles.'),
(5, 'Quantum chromodynamics: The theory of the strong interaction between quarks and gluons, the fundamental constituents of composite hadrons.');

-- Terms for lesson_id 6 (Modern Art History)
INSERT INTO term (lesson_id, content) VALUES
(6, 'Impressionism: A 19th-century art movement characterized by relatively small, thin, yet visible brush strokes.'),
(6, 'Post-Impressionism: A predominantly French art movement that developed roughly between 1886 and 1905.'),
(6, 'Cubism: An early-20th-century art movement pioneered by Pablo Picasso and Georges Braque.'),
(6, 'Abstract Expressionism: A post–World War II art movement in American painting, developed in New York City in the 1940s.');

-- Terms for lesson_id 7 (Art Techniques: Mastering Oil Painting)
INSERT INTO term (lesson_id, content) VALUES
(7, 'Glazing: A technique used by painters to add a transparent layer of paint over another layer of paint.'),
(7, 'Impasto: Paint applied thickly.'),
(7, 'Sfumato: A painting technique for softening the transition between colours.'),
(7, 'Chiaroscuro: The use of strong contrasts between light and dark, usually bold contrasts affecting a whole composition.');

-- Terms for lesson_id 8 (Introduction to Machine Learning)
INSERT INTO term (lesson_id, content) VALUES
(8, 'Supervised learning: A type of machine learning where an algorithm learns from labeled data.'),
(8, 'Unsupervised learning: A type of machine learning where an algorithm learns from unlabeled data.'),
(8, 'Regression: A statistical process for estimating the relationships among variables.'),
(8, 'Classification: A process of predicting the class of given data points.');

-- Terms for lesson_id 9 (Deep Learning with Neural Networks)
INSERT INTO term (lesson_id, content) VALUES
(9, 'Neural network: A series of algorithms that endeavors to recognize underlying relationships in a set of data through a process that mimics the way the human brain operates.'),
(9, 'Deep learning: A subset of machine learning in artificial intelligence that has networks capable of learning unsupervised from data that is unstructured or unlabeled.'),
(9, 'Convolutional neural network: A class of deep neural networks, most commonly applied to analyzing visual imagery.'),
(9, 'Recurrent neural network: A class of neural network that allows previous outputs to be used as inputs while having hidden states.');

-- Terms for lesson_id 10 (Data Science: Practical Applications)
INSERT INTO term (lesson_id, content) VALUES
(10, 'Data mining: The process of discovering patterns in large data sets involving methods at the intersection of machine learning, statistics, and database systems.'),
(10, 'Data visualization: The graphical representation of information and data.'),
(10, 'Predictive analytics: The branch of the advanced analytics which is used to make predictions about unknown future events.'),
(10, 'Big data: Data sets that are too large or complex for traditional data-processing application software to adequately deal with.');

-- Terms for lesson_id 11 (Quantum Physics Experiments)
INSERT INTO term (lesson_id, content) VALUES
(11, 'Double-slit experiment: Demonstrates that matter can display characteristics of both waves and particles.'),
(11, 'Stern–Gerlach experiment: Demonstrates that the spatial orientation of angular momentum is quantized.'),
(11, 'EPR paradox: A thought experiment questioning the completeness of quantum mechanics.');

INSERT INTO user_flashcard (user_id, term_id) VALUES
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10);
INSERT INTO user_flashcard (user_id, term_id) VALUES
(2,36);