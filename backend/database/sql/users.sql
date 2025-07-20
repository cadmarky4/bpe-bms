-- Drop existing tables that might conflict
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS barangay_officials;
DROP TABLE IF EXISTS residents;

-- Users table
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    username TEXT UNIQUE NOT NULL,
    email_verified_at TEXT,
    password TEXT NOT NULL,
    role TEXT NOT NULL,
    department TEXT NOT NULL,
    position TEXT,
    employee_id TEXT,
    is_active INTEGER DEFAULT 1,
    is_verified INTEGER DEFAULT 0,
    last_login_at TEXT,
    notes TEXT,
    remember_token TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Residents table with barangay column
CREATE TABLE residents (
    id TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    suffix TEXT,
    birth_date DATE,
    age INTEGER,
    gender TEXT,
    civil_status TEXT,
    occupation TEXT,
    phone TEXT,
    email TEXT,
    address TEXT,
    barangay TEXT,
    status TEXT DEFAULT 'ACTIVE',
    household_id TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Households table
CREATE TABLE IF NOT EXISTS households (
    id TEXT PRIMARY KEY,
    household_number TEXT UNIQUE,
    address TEXT,
    barangay TEXT,
    total_members INTEGER DEFAULT 0,
    head_of_family_id TEXT,
    status TEXT DEFAULT 'ACTIVE',
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Barangay Officials table with committee_assignment column
CREATE TABLE barangay_officials (
    id TEXT PRIMARY KEY,
    resident_id TEXT,
    position TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    term_start DATE,
    term_end DATE,
    status TEXT DEFAULT 'ACTIVE',
    contact_number TEXT,
    email TEXT,
    email_address TEXT,
    address TEXT,
    committee_assignment TEXT,
    profile_photo TEXT,
    notes TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Create missing tables if they don't exist
CREATE TABLE IF NOT EXISTS projects (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'Active',
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15,2),
    completion_percentage INTEGER DEFAULT 0,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS documents (
    id TEXT PRIMARY KEY,
    type TEXT NOT NULL,
    resident_id TEXT,
    document_number TEXT UNIQUE,
    issued_date DATE,
    purpose TEXT,
    status TEXT DEFAULT 'ISSUED',
    issued_by TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS audits (
    id TEXT PRIMARY KEY,
    user_type TEXT,
    user_id TEXT,
    event TEXT,
    auditable_type TEXT,
    auditable_id TEXT,
    old_values TEXT,
    new_values TEXT,
    url TEXT,
    ip_address TEXT,
    user_agent TEXT,
    tags TEXT,
    description TEXT,
    table_name TEXT,
    created_at TEXT,
    updated_at TEXT
);

-- Insert admin user
INSERT OR REPLACE INTO users (
    id, first_name, last_name, email, phone, username, password, 
    role, department, position, employee_id, is_active, is_verified,
    email_verified_at, created_at, updated_at
) VALUES (
    'admin-001',
    'Admin', 'User', 'admin@sikatuna.gov.ph', '+639171234567',
    'admin', '$2y$12$/iYJFd3zTUwMKUV/q8swxOc0GZ/q04dAj8gn8IXJxCN1NMFPHO4Va',
    'SUPER_ADMIN', 'ADMINISTRATION', 'System Administrator', 'EMP-001',
    1, 1, datetime('now'), datetime('now'), datetime('now')
);

-- Insert sample barangay officials with committee assignments
INSERT OR IGNORE INTO barangay_officials (
    id, position, first_name, last_name, status, committee_assignment,
    term_start, term_end, created_at, updated_at
) VALUES 
('official-001', 'BARANGAY_CAPTAIN', 'Maria', 'Santos', 'ACTIVE', 'Executive Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-002', 'BARANGAY_SECRETARY', 'Ana', 'Rodriguez', 'ACTIVE', 'Peace and Order Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-003', 'BARANGAY_TREASURER', 'Roberto', 'Mendoza', 'ACTIVE', 'Finance Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-004', 'BARANGAY_COUNCILOR', 'Juan', 'Reyes', 'ACTIVE', 'Health Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-005', 'BARANGAY_COUNCILOR', 'Elena', 'Villanueva', 'ACTIVE', 'Education Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now'));

-- Insert sample residents with barangay data
INSERT OR IGNORE INTO residents (
    id, first_name, last_name, age, gender, status, barangay, created_at, updated_at
) VALUES 
('resident-001', 'Maria', 'Garcia', 35, 'FEMALE', 'ACTIVE', 'Sikatuna Village', datetime('now'), datetime('now')),
('resident-002', 'Jose', 'Santos', 42, 'MALE', 'ACTIVE', 'Sikatuna Village', datetime('now'), datetime('now')),
('resident-003', 'Ana', 'Cruz', 28, 'FEMALE', 'ACTIVE', 'Sikatuna Village', datetime('now'), datetime('now')),
('resident-004', 'Pedro', 'Rodriguez', 65, 'MALE', 'ACTIVE', 'Sikatuna Village', datetime('now'), datetime('now')),
('resident-005', 'Carmen', 'Lopez', 15, 'FEMALE', 'ACTIVE', 'Sikatuna Village', datetime('now'), datetime('now'));

-- Insert sample projects
INSERT OR IGNORE INTO projects (id, title, description, status, start_date, completion_percentage, created_at, updated_at) VALUES 
('project-001', 'Street Lighting Improvement', 'Installation of LED street lights', 'Active', '2025-01-01', 35, datetime('now'), datetime('now')),
('project-002', 'Community Health Center', 'Building new health facility', 'Active', '2025-02-01', 15, datetime('now'), datetime('now'));