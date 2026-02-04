SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS leave_logs;
DROP TABLE IF EXISTS leave_applications;
DROP TABLE IF EXISTS mc_records;
DROP TABLE IF EXISTS leaves;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS holidays;
DROP TABLE IF EXISTS settings;

CREATE TABLE departments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE holidays (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  date DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  full_name VARCHAR(255) NOT NULL,
  password_hash TEXT NOT NULL,
  role ENUM('admin','user') NOT NULL,
  created_at DATETIME NOT NULL,
  entitlement INT DEFAULT 0,
  department_id INT,
  position VARCHAR(100),
  approver_role VARCHAR(100),
  ic_number VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(50),
  address TEXT,
  enrollment_date DATE,
  availability VARCHAR(50) DEFAULT 'Available',
  profile_photo VARCHAR(255),
  last_login DATETIME,
  reset_token VARCHAR(255),
  reset_token_expiry DATETIME,
  profile_photos VARCHAR(255),
  FOREIGN KEY (department_id) REFERENCES departments(id)
) ENGINE=InnoDB;

CREATE TABLE leave_applications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  full_name VARCHAR(255),
  position VARCHAR(100),
  leave_type VARCHAR(100) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_days INT,
  reason TEXT,
  status VARCHAR(50) NOT NULL DEFAULT 'Pending Check',
  checker_name VARCHAR(100),
  approver_name VARCHAR(100),
  support_doc VARCHAR(255),
  contact_address TEXT,
  contact_phone VARCHAR(50),
  created_at DATETIME NOT NULL,
  checked_at DATETIME,
  approved_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE leaves (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  leave_type VARCHAR(100) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  reason TEXT,
  status VARCHAR(50) NOT NULL DEFAULT 'Pending',
  created_at DATETIME NOT NULL,
  next_approver VARCHAR(100),
  contact_address TEXT,
  contact_phone VARCHAR(50),
  notes TEXT,
  checked_by_position VARCHAR(100),
  checked_status VARCHAR(50) DEFAULT 'Pending',
  next_approver_position VARCHAR(100),
  next_approver_department VARCHAR(100),
  checked_by_user_id INT,
  approved_by_user_id INT,
  FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE leave_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  leave_id INT NOT NULL,
  action VARCHAR(100) NOT NULL,
  performed_by INT NOT NULL,
  timestamp DATETIME NOT NULL,
  description TEXT,
  FOREIGN KEY (leave_id) REFERENCES leaves(id),
  FOREIGN KEY (performed_by) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE mc_records (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  mc_number VARCHAR(100),
  start_date DATE,
  end_date DATE,
  pdf_path VARCHAR(255),
  uploaded_by INT,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (uploaded_by) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE settings (
  `key` VARCHAR(100) PRIMARY KEY,
  value VARCHAR(255)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS=1;
