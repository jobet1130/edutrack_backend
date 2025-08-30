-- Create trigger for INSERT operations
CREATE OR REPLACE FUNCTION log_audit_insert() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_audit (
        table_name,
        operation,
        old_data,
        new_data,
        changed_by,
        changed_at
    ) VALUES (
        TG_TABLE_NAME,
        'INSERT',
        NULL,
        row_to_json(NEW),
        current_user,
        current_timestamp
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for UPDATE operations
CREATE OR REPLACE FUNCTION log_audit_update() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_audit (
        table_name,
        operation,
        old_data,
        new_data,
        changed_by,
        changed_at
    ) VALUES (
        TG_TABLE_NAME,
        'UPDATE',
        row_to_json(OLD),
        row_to_json(NEW),
        current_user,
        current_timestamp
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for DELETE operations
CREATE OR REPLACE FUNCTION log_audit_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_audit (
        table_name,
        operation,
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
    AFTER INSERT ON course
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_insert();

CREATE TRIGGER audit_course_update
    AFTER UPDATE ON course
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_update();

CREATE TRIGGER audit_course_delete
    AFTER DELETE ON course
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_delete();

CREATE TRIGGER audit_enrollment_insert
    AFTER INSERT ON enrollment
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_insert();

CREATE TRIGGER audit_enrollment_update
    AFTER UPDATE ON enrollment
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_update();

CREATE TRIGGER audit_enrollment_delete
    AFTER DELETE ON enrollment
    FOR EACH ROW
    EXECUTE FUNCTION log_audit_delete();
