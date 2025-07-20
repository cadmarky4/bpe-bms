-- Drop existing tables that might conflict
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS barangay_officials;
DROP TABLE IF EXISTS residents;
DROP TABLE IF EXISTS household_members;

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

-- Residents table with all required columns
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
    employment_status TEXT,
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

-- Household members pivot table
CREATE TABLE household_members (
    id TEXT PRIMARY KEY,
    household_id TEXT NOT NULL,
    resident_id TEXT NOT NULL,
    relationship TEXT,
    created_at TEXT,
    updated_at TEXT,
    FOREIGN KEY (household_id) REFERENCES households(id),
    FOREIGN KEY (resident_id) REFERENCES residents(id)
);

-- Barangay Officials table with all columns
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

-- Create other necessary tables
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

-- Insert sample households
INSERT OR IGNORE INTO households (id, household_number, address, barangay, total_members, created_at, updated_at) VALUES 
('household-001', 'HH-001', '123 Main Street', 'Sikatuna Village', 4, datetime('now'), datetime('now')),
('household-002', 'HH-002', '456 Oak Avenue', 'Sikatuna Village', 3, datetime('now'), datetime('now')),
('household-003', 'HH-003', '789 Pine Road', 'Sikatuna Village', 2, datetime('now'), datetime('now'));

-- Insert sample residents with employment status
INSERT OR IGNORE INTO residents (
    id, first_name, last_name, age, gender, status, barangay, employment_status, 
    household_id, created_at, updated_at
) VALUES 
('resident-001', 'Maria', 'Garcia', 35, 'FEMALE', 'ACTIVE', 'Sikatuna Village', 'EMPLOYED', 'household-001', datetime('now'), datetime('now')),
('resident-002', 'Jose', 'Santos', 42, 'MALE', 'ACTIVE', 'Sikatuna Village', 'EMPLOYED', 'household-001', datetime('now'), datetime('now')),
('resident-003', 'Ana', 'Cruz', 28, 'FEMALE', 'ACTIVE', 'Sikatuna Village', 'UNEMPLOYED', 'household-002', datetime('now'), datetime('now')),
('resident-004', 'Pedro', 'Rodriguez', 65, 'MALE', 'ACTIVE', 'Sikatuna Village', 'RETIRED', 'household-002', datetime('now'), datetime('now')),
('resident-005', 'Carmen', 'Lopez', 15, 'FEMALE', 'ACTIVE', 'Sikatuna Village', 'STUDENT', 'household-003', datetime('now'), datetime('now')),
('resident-006', 'Roberto', 'Dela Cruz', 38, 'MALE', 'ACTIVE', 'Sikatuna Village', 'SELF_EMPLOYED', 'household-003', datetime('now'), datetime('now'));

-- Insert household members relationships
INSERT OR IGNORE INTO household_members (id, household_id, resident_id, relationship, created_at, updated_at) VALUES 
('hm-001', 'household-001', 'resident-001', 'HEAD', datetime('now'), datetime('now')),
('hm-002', 'household-001', 'resident-002', 'SPOUSE', datetime('now'), datetime('now')),
('hm-003', 'household-002', 'resident-003', 'HEAD', datetime('now'), datetime('now')),
('hm-004', 'household-002', 'resident-004', 'PARENT', datetime('now'), datetime('now')),
('hm-005', 'household-003', 'resident-005', 'CHILD', datetime('now'), datetime('now')),
('hm-006', 'household-003', 'resident-006', 'HEAD', datetime('now'), datetime('now'));

-- Insert sample barangay officials
INSERT OR IGNORE INTO barangay_officials (
    id, position, first_name, last_name, status, committee_assignment,
    term_start, term_end, created_at, updated_at
) VALUES 
('official-001', 'BARANGAY_CAPTAIN', 'Maria', 'Santos', 'ACTIVE', 'Executive Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-002', 'BARANGAY_SECRETARY', 'Ana', 'Rodriguez', 'ACTIVE', 'Peace and Order Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-003', 'BARANGAY_TREASURER', 'Roberto', 'Mendoza', 'ACTIVE', 'Finance Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-004', 'BARANGAY_COUNCILOR', 'Juan', 'Reyes', 'ACTIVE', 'Health Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-005', 'BARANGAY_COUNCILOR', 'Elena', 'Villanueva', 'ACTIVE', 'Education Committee', '2023-01-01', '2026-12-31', datetime('now'), datetime('now'));

-- Insert sample projects
INSERT OR IGNORE INTO projects (id, title, description, status, start_date, completion_percentage, created_at, updated_at) VALUES 
('project-001', 'Street Lighting Improvement', 'Installation of LED street lights', 'Active', '2025-01-01', 35, datetime('now'), datetime('now')),
('project-002', 'Community Health Center', 'Building new health facility', 'Active', '2025-02-01', 15, datetime('now'), datetime('now'));