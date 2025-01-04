CREATE TABLE IF NOT EXISTS `asfallen_kda` (
    `steamid` VARCHAR(50) PRIMARY KEY,
    `kills` INT DEFAULT 0,
    `deaths` INT DEFAULT 0,
    `kda` FLOAT DEFAULT 0.0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 