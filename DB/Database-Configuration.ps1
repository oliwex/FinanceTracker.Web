#REGION CONFIGURATION
Import-Module PSSQLite

$dbPath = "E:\GIT\FinanceTracker.Web\DB\fortune.db"
#ENDREGION CONFIGURATION

#REGION TABLES
$query = @"
CREATE TABLE IF NOT EXISTS GOLD (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    METAL VARCHAR(6) NOT NULL,
    BUYER VARCHAR(5) NOT NULL CHECK (BUYER IN ('Ja','MAMA')),
    DATE  DATE NOT NULL,
    VOLUME INTEGER NOT NULL,
    PRICE DECIMAL(10, 2) NOT NULL CHECK (PRICE >= 0)
);
"@

Invoke-SqliteQuery -DataSource $dbPath -Query $query
#ENDREGION TABLES

#REGION RECORDS
$query = @"
INSERT INTO GOLD
(METAL, BUYER, DATE, VOLUME, PRICE)
VALUES
('Gold', 'Ja', '2024-11-23', 3, 12420.00),
('Gold', 'MAMA', '2025-02-13', 3, 11980.00),
('Gold', 'Ja', '2025-04-25', 1, 12768.00),
('Gold', 'Ja', '2025-05-05', 1, 12912.00),
('Gold', 'MAMA', '2025-05-30', 1, 12638.00),
('Gold', 'Ja', '2025-07-30', 1, 12623.00),
('Gold', 'MAMA', '2025-08-12', 2, 12533.00),
('Gold', 'Ja', '2025-10-17', 1, 16224.00),
('Gold', 'Ja', '2025-12-29', 1, 16115.00),
('Gold', 'Ja', '2026-03-07', 1, 19631.00),
('Gold', 'MAMA', '2026-03-13', 1, 19390.00),
('Gold', 'Ja', '2026-06-03', 1, 16649.00),
('Gold', 'Ja', '2026-08-29', 1, 16962.00),
('Gold', 'Ja', '2026-11-05', 1, 16593.00);
"@

Invoke-SqliteQuery -DataSource $dbPath -Query $query

#ENDREGION RECORDS

Invoke-SqliteQuery -DataSource $dbPath -Query "SELECT * FROM GOLD"

Invoke-SqliteQuery -DataSource $dbPath -Query "DELETE FROM GOLD WHERE ID = 16"