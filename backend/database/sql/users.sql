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

-- Personal access tokens table
CREATE TABLE personal_access_tokens (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tokenable_type TEXT NOT NULL,
    tokenable_id TEXT NOT NULL,
    name TEXT NOT NULL,
    token TEXT UNIQUE NOT NULL,
    abilities TEXT,
    last_used_at TEXT,
    expires_at TEXT,
    created_at TEXT,
    updated_at TEXT
);

-- Residents table
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
    status TEXT DEFAULT 'ACTIVE',
    household_id TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Households table
CREATE TABLE households (
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

-- Appointments table
CREATE TABLE appointments (
    id TEXT PRIMARY KEY,
    resident_id TEXT,
    purpose TEXT,
    appointment_date DATE,
    appointment_time TIME,
    status TEXT DEFAULT 'PENDING',
    notes TEXT,
    assigned_to TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Blotters table  
CREATE TABLE blotters (
    id TEXT PRIMARY KEY,
    incident_type TEXT,
    incident_date DATE,
    incident_time TIME,
    location TEXT,
    complainant_id TEXT,
    respondent_info TEXT,
    description TEXT,
    status TEXT DEFAULT 'PENDING',
    assigned_officer TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Complaints table
CREATE TABLE complaints (
    id TEXT PRIMARY KEY,
    complainant_id TEXT,
    complaint_type TEXT,
    subject TEXT,
    description TEXT,
    status TEXT DEFAULT 'PENDING',
    priority TEXT DEFAULT 'MEDIUM',
    assigned_to TEXT,
    resolution TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Suggestions table
CREATE TABLE suggestions (
    id TEXT PRIMARY KEY,
    resident_id TEXT,
    title TEXT,
    description TEXT,
    category TEXT,
    status TEXT DEFAULT 'PENDING',
    response TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Tickets table
CREATE TABLE tickets (
    id TEXT PRIMARY KEY,
    ticket_number TEXT UNIQUE,
    resident_id TEXT,
    subject TEXT,
    description TEXT,
    category TEXT,
    priority TEXT DEFAULT 'MEDIUM',
    status TEXT DEFAULT 'OPEN',
    assigned_to TEXT,
    resolution TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Agendas table
CREATE TABLE agendas (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    meeting_date DATE,
    meeting_time TIME,
    location TEXT,
    status TEXT DEFAULT 'SCHEDULED',
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);

-- Settings table
CREATE TABLE settings (
    id TEXT PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT,
    description TEXT,
    created_at TEXT,
    updated_at TEXT
);

-- Insert admin user
INSERT INTO users (
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

-- Insert some sample barangay officials
INSERT INTO barangay_officials (
    id, position, first_name, last_name, status, 
    term_start, term_end, created_at, updated_at
) VALUES 
('official-001', 'BARANGAY_CAPTAIN', 'Maria', 'Santos', 'ACTIVE', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-002', 'BARANGAY_SECRETARY', 'Ana', 'Rodriguez', 'ACTIVE', '2023-01-01', '2026-12-31', datetime('now'), datetime('now')),
('official-003', 'BARANGAY_TREASURER', 'Roberto', 'Mendoza', 'ACTIVE', '2023-01-01', '2026-12-31', datetime('now'), datetime('now'));

-- Insert basic settings
INSERT INTO settings (id, key, value, description, created_at, updated_at) VALUES 
('setting-001', 'barangay_name', 'Barangay Sikatuna Village', 'Official barangay name', datetime('now'), datetime('now')),
('setting-002', 'barangay_code', 'BSV-001', 'Barangay code', datetime('now'), datetime('now')),
('setting-003', 'contact_number', '+63-2-1234-5678', 'Official contact number', datetime('now'), datetime('now'));