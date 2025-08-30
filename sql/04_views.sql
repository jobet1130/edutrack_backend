-- View: student_details
CREATE OR REPLACE VIEW student_details AS
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    s.date_of_birth,
    s.gender,
    s.email,
    s.phone_number,
    s.address,
    c.class_name,
    g.grade_level
FROM students s
JOIN classes c ON s.class_id = c.class_id
JOIN grades g ON c.grade_id = g.grade_id;

-- View: teacher_details
CREATE OR REPLACE VIEW teacher_details AS
SELECT 
    t.teacher_id,
    t.first_name,
    t.last_name,
    t.email,
    t.phone_number,
    s.subject_name,
    d.department_name
FROM teachers t
JOIN subjects s ON t.subject_id = s.subject_id
JOIN departments d ON t.department_id = d.department_id;

-- View: class_schedule
CREATE OR REPLACE VIEW class_schedule AS
SELECT 
    cs.schedule_id,
    c.class_name,
    s.subject_name,
    t.first_name || ' ' || t.last_name as teacher_name,
    cs.day_of_week,
    cs.start_time,
    cs.end_time,
    r.room_number
FROM class_schedules cs
JOIN classes c ON cs.class_id = c.class_id
JOIN subjects s ON cs.subject_id = s.subject_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN rooms r ON cs.room_id = r.room_id;

-- View: attendance_summary
CREATE OR REPLACE VIEW attendance_summary AS
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name as student_name,
    c.class_name,
    COUNT(a.attendance_id) as total_classes,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) as present_count,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) as absent_count,
    ROUND(CAST(SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS FLOAT) / 
          COUNT(a.attendance_id) * 100, 2) as attendance_percentage
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN classes c ON s.class_id = c.class_id
GROUP BY s.student_id, s.first_name, s.last_name, c.class_name;

-- View: grade_summary
CREATE OR REPLACE VIEW grade_summary AS
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name as student_name,
    sub.subject_name,
    ROUND(AVG(g.score), 2) as average_score,
    MAX(g.score) as highest_score,
    MIN(g.score) as lowest_score
FROM students s
JOIN grades_records g ON s.student_id = g.student_id
JOIN subjects sub ON g.subject_id = sub.subject_id
GROUP BY s.student_id, s.first_name, s.last_name, sub.subject_name;
