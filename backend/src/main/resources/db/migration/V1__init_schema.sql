CREATE TABLE users (
    id UUID PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL ,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE assets (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    serial_number VARCHAR(100) NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL,
    category_id UUID NOT NULL REFERENCES categories(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE asset_assignments (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id),
    asset_id UUID NOT NULL REFERENCES assets(id),
    assigned_date TIMESTAMPTZ NOT NULL,
    return_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Strukturierte Audit-Spalten statt Freitext-Sätzen
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY,
    entity_id UUID NOT NULL, -- z.B. id von einer Tabelle (assets / users / categories)
    entity_type VARCHAR(50) NOT NULL, -- z.B. 'ASSET', 'USER'
    action VARCHAR(50) NOT NULL, -- z.B. 'CREATED', 'ASSIGNED'
    performed_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Erstellt einen B-Tree-Index auf dem Fremdschlüssel für schnelle JOIN-Abfragen (O(log n)) statt (O(n))
CREATE INDEX idx_assets_category_id ON assets(category_id);
CREATE INDEX idx_audit_logs_performed_by ON audit_logs(performed_by);
CREATE INDEX idx_asset_assignments_user_id ON asset_assignments(user_id);
CREATE INDEX idx_asset_assignments_asset_id ON asset_assignments(asset_id);