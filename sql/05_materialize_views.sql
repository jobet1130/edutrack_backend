-- Create materialized view for student performance metrics
CREATE MATERIALIZED VIEW student_performance_metrics AS
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    c.class_name,
    AVG(g.grade) as average_grade,
    COUNT(DISTINCT a.assignment_id) as completed_assignments,
    COUNT(DISTINCT att.attendance_id) as attendance_count
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN classes c ON e.class_id = c.class_id
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN assignments a ON g.assignment_id = a.assignment_id
LEFT JOIN attendance att ON s.student_id = att.student_id
GROUP BY s.student_id, s.first_name, s.last_name, c.class_name;

-- Create materialized view for class analytics
CREATE MATERIALIZED VIEW class_analytics AS
SELECT 
    c.class_id,
    c.class_name,
    t.teacher_id,
    t.first_name as teacher_first_name,
    t.last_name as teacher_last_name,
    COUNT(DISTINCT e.student_id) as total_students,
    AVG(g.grade) as class_average,
    COUNT(DISTINCT a.assignment_id) as total_assignments
FROM classes c
LEFT JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN enrollments e ON c.class_id = e.class_id
LEFT JOIN assignments a ON c.class_id = a.class_id
LEFT JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.class_id, c.class_name, t.teacher_id, t.first_name, t.last_name;

-- Create materialized view for attendance tracking
CREATE MATERIALIZED VIEW attendance_analytics AS
SELECT 
    c.class_id,
    c.class_name,
    s.student_id,
    s.first_name,
    s.last_name,
    COUNT(att.attendance_id) as total_present,
    ROUND(COUNT(att.attendance_id)::DECIMAL / 
          (SELECT COUNT(DISTINCT date) FROM attendance WHERE status = 'present') * 100, 2) 
    as attendance_percentage
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN classes c ON e.class_id = c.class_id
LEFT JOIN attendance att ON s.student_id = att.student_id AND att.status = 'present'
GROUP BY c.class_id, c.class_name, s.student_id, s.first_name, s.last_name;

-- Create refresh functions for materialized views
CREATE OR REPLACE FUNCTION refresh_all_mat_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW student_performance_metrics;
    REFRESH MATERIALIZED VIEW class_analytics;
    REFRESH MATERIALIZED VIEW attendance_analytics;
END;
$$ LANGUAGE plpgsql;
