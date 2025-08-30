-- ========================

-- DATABASE: EduTrack
-- ========================

-- USERS TABLE
CREATE TABLE auth_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(150) UNIQUE NOT NULL,

    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    is_staff BOOLEAN DEFAULT FALSE,
    is_superuser BOOLEAN DEFAULT FALSE,

    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ROLES
CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);


-- USER PROFILE (extends auth_user)
CREATE TABLE user_profile (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    role_id INT NOT NULL REFERENCES role(id) ON DELETE CASCADE,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    gender VARCHAR(10),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DEPARTMENTS
CREATE TABLE department (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- PROGRAMS (e.g., BSCS, BSMath)
CREATE TABLE program (
    id SERIAL PRIMARY KEY,
    department_id INT NOT NULL REFERENCES department(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- COURSES
CREATE TABLE course (
    id SERIAL PRIMARY KEY,

    program_id INT REFERENCES program(id) ON DELETE CASCADE,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    credits INT DEFAULT 3
);

-- SUBJECTS (modules inside a course)
CREATE TABLE subject (
    id SERIAL PRIMARY KEY,
    course_id INT NOT NULL REFERENCES course(id) ON DELETE CASCADE,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- CLASSROOMStamp
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for DELETE operations
CREATE OR REPLACE FUNCTION log_audi_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_udit (
        table_nae,
        oeration,
        old_data,
        new_data,
        changed_by,
        changed_at
    ) VALUES (
        TG_TABLE_NAME,
        'DELETE',
        row_to_json(OLD),
        NULL,
        current_user,
        current_timestamp
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for all tables that need auditing
CREATE TRIGGER audit_student_insert
    AFTER INSERT ON student
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_insert();

CREATE TRIGGER audit_student_update
    AFTER UPDATE ON student
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_update();

CREATE TRIGGER audit_student_delete
    AFTER DELETE ON student
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_delete();

CREATE TRIGGER audit_course_insert
CREATE TABLE classroom (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    capacity INT
);

-- CLASS SCHEDULE
CREATE TABLE class_schedule (
    id SERIAL PRIMARY KEY,
    subject_id INT NOT NULL REFERENCES subject(id) ON DELETE CASCADE,
    teacher_id INT NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    classroom_id INT REFERENCES classroom(id),
    day_of_week VARCHAR(10) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

-- ENROLLMENTS
CREATE TABLE enrollment (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    course_id INT NOT NULL REFERENCES course(id) ON DELETE CASCADE,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'active'
);

-- ATTENDANCE
CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    subject_id INT NOT NULL REFERENCES subject(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('present', 'absent', 'late', 'excused'))
);

-- ASSIGNMENTS
CREATE TABLE assignment (
    id SERIAL PRIMARY KEY,
    subject_id INT NOT NULL REFERENCES subject(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE
);

-- SUBMISSIONS
CREATE TABLE submission (
    id SERIAL PRIMARY KEY,
    assignment_id INT NOT NULL REFERENCES assignment(id) ON DELETE CASCADE,
    student_id INT NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    file_path VARCHAR(255),
    grade NUMERIC(5,2)
);

-- GRADES
CREATE TABLE grade (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    subject_id INT NOT NULL REFERENCES subject(id) ON DELETE CASCADE,
    grade NUMERIC(5,2) NOT NULL,
    remarks VARCHAR(100)
);

-- STUDENT TABLE
CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    enrollment_number VARCHAR(50) UNIQUE NOT NULL,
    admission_date DATE DEFAULT CURRENT_DATE,
    guardian_name VARCHAR(100),
    guardian_contact VARCHAR(20),
    year_level VARCHAR(50),      -- e.g., "Freshman", "Sophomore"
    section VARCHAR(50),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'graduated', 'suspended')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- LMS CONTENT
CREATE TABLE lms_content (
    id SERIAL PRIMARY KEY,
    subject_id INT NOT NULL REFERENCES subject(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content_type VARCHAR(50) NOT NULL CHECK (content_type IN ('video', 'pdf', 'ppt', 'doc', 'quiz')),
    file_path VARCHAR(255),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ANNOUNCEMENTS
CREATE TABLE announcement (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT REFERENCES auth_user(id)
);

-- LOG TABLE (Audit trail)
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES auth_user(id),
    action VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
