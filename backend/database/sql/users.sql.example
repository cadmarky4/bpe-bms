-- Drop existing tables that might conflict
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS barangay_officials;

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

-- Create missing tables only if they don't exist
CREATE TABLE IF NOT EXISTS residents (
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
    status TEXT DEFAULT 'ACTIVE',
    household_id TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

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

-- Barangay Officials table
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
    address TEXT,
    notes TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
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

-- Insert sample barangay officials
INSERT OR IGNORE INTO barangay_officials (
    id, position, first_name, last_name, status, 
    term_start, term_end, created_at, updated_at
) VALUES 
('official-001', 'BARANGAY_CAPTAIN', 'Maria', 'Santos', 'ACTIVE', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-002', 'BARANGAY_SECRETARY', 'Ana', 'Rodriguez', 'ACTIVE', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-003', 'BARANGAY_TREASURER', 'Roberto', 'Mendoza', 'ACTIVE', '2023-01-01', '2026-12-31', datetime('now'), datetime('now'));