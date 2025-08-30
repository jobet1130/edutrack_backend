-- Insert sample roles
INSERT INTO role (name) VALUES
('admin'),
('teacher'),
('student');

-- Insert sample departments
INSERT INTO department (name, description) VALUES
('Computer Science', 'Department of Computer Science and Information Technology'),
('Mathematics', 'Department of Mathematical Sciences'),
('Physics', 'Department of Physics and Astronomy');

-- Insert sample programs
INSERT INTO program (department_id, name, description) VALUES
(1, 'Bachelor of Science in Computer Science', 'Four-year undergraduate program in CS'),
(1, 'Master of Science in Information Technology', 'Graduate program in IT'),
(2, 'Bachelor of Science in Mathematics', 'Four-year undergraduate program in Mathematics');

-- Insert sample users (passwords are hashed)
INSERT INTO auth_user (username, password, email, first_name, last_name, is_active, is_staff, is_superuser) VALUES
('admin1', 'pbkdf2_sha256$123456$abcdef', 'admin@edutrack.com', 'Admin', 'User', true, true, true),
('teacher1', 'pbkdf2_sha256$123456$ghijkl', 'teacher1@edutrack.com', 'John', 'Smith', true, false, false),
('teacher2', 'pbkdf2_sha256$123456$mnopqr', 'teacher2@edutrack.com', 'Mary', 'Johnson', true, false, false),
('student1', 'pbkdf2_sha256$123456$stuvwx', 'student1@edutrack.com', 'James', 'Wilson', true, false, false),
('student2', 'pbkdf2_sha256$123456$yzabcd', 'student2@edutrack.com', 'Sarah', 'Brown', true, false, false);

-- Insert sample user profiles
INSERT INTO user_profile (user_id, role_id, phone, address, date_of_birth, gender) VALUES
(1, 1, '1234567890', '123 Admin St', '1980-01-01', 'Male'),
(2, 2, '2345678901', '456 Teacher Ave', '1985-02-15', 'Male'),
(3, 2, '3456789012', '789 Teacher Blvd', '1982-07-20', 'Female'),
(4, 3, '4567890123', '321 Student Ln', '2000-03-10', 'Male'),
(5, 3, '5678901234', '654 Student Rd', '2001-05-22', 'Female');

-- Insert sample courses
INSERT INTO course (program_id, code, name, description, credits) VALUES
(1, 'CS101', 'Introduction to Programming', 'Basic programming concepts and algorithms', 3),
(1, 'CS102', 'Data Structures', 'Fundamental data structures and algorithms', 4),
(2, 'IT501', 'Advanced Database Systems', 'Advanced concepts in database management', 3);

-- Insert sample subjects
INSERT INTO subject (course_id, code, name, description) VALUES
(1, 'CS101-1', 'Python Programming', 'Introduction to Python programming language'),
(1, 'CS101-2', 'Java Programming', 'Introduction to Java programming language'),
(2, 'CS102-1', 'Arrays and Linked Lists', 'Implementation and analysis of basic data structures');

-- Insert sample classrooms
INSERT INTO classroom (name, location, capacity) VALUES
('Room 101', 'Building A', 30),
('Lab 201', 'Building B', 25),
('Room 303', 'Building C', 40);

-- Insert sample class schedules
INSERT INTO class_schedule (subject_id, teacher_id, classroom_id, day_of_week, start_time, end_time) VALUES
(1, 2, 1, 'Monday', '09:00', '10:30'),
(2, 3, 2, 'Tuesday', '13:00', '14:30'),
(3, 2, 3, 'Wednesday', '15:00', '16:30');

-- Insert sample enrollments
INSERT INTO enrollment (student_id, course_id, status) VALUES
(4, 1, 'active'),
(5, 1, 'active'),
(4, 2, 'active');

-- Insert sample assignments
INSERT INTO assignment (subject_id, title, description, due_date) VALUES
(1, 'Python Basics', 'Create a simple calculator using Python', '2024-03-20'),
(2, 'Java OOP', 'Implement a class hierarchy', '2024-03-25'),
(3, 'Data Structure Implementation', 'Implement a linked list', '2024-03-30');

-- Insert sample attendance records
INSERT INTO attendance (student_id, subject_id, date, status) VALUES
(4, 1, '2024-03-01', 'present'),
(5, 1, '2024-03-01', 'present'),
(4, 2, '2024-03-02', 'late');

-- Insert sample grades
INSERT INTO grade (student_id, subject_id, grade, remarks) VALUES
(4, 1, 85.50, 'Good performance'),
(5, 1, 92.00, 'Excellent work'),
(4, 2, 78.50, 'Needs improvement');

-- Insert sample LMS content
INSERT INTO lms_content (subject_id, title, content_type, file_path) VALUES
(1, 'Python Basics Lecture', 'pdf', '/content/python_basics.pdf'),
(2, 'Java Tutorial Video', 'video', '/content/java_tutorial.mp4'),
(3, 'Data Structures Slides', 'ppt', '/content/data_structures.pptx');

-- Insert sample announcements
INSERT INTO announcement (title, content, created_by) VALUES
('Welcome to New Semester', 'Welcome to the Spring 2024 semester! Please check your course schedules.', 1),
('Midterm Schedule', 'Midterm examinations will be held from April 1-5, 2024.', 2),
('System Maintenance', 'The system will be down for maintenance on March 15, 2024, from 22:00-23:00.', 1);
