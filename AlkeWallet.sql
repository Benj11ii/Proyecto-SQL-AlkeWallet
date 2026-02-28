-- CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE AlkeWallet;
USE AlkeWallet;

-- CREACIÓN DE TABLAS (DDL)
CREATE TABLE moneda (
    currency_id INT PRIMARY KEY AUTO_INCREMENT,
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL
);

CREATE TABLE usuario (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    saldo DECIMAL(15, 2) DEFAULT 0.00
);

CREATE TABLE transaccion (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_user_id INT NOT NULL,
    receiver_user_id INT NOT NULL,
    currency_id INT NOT NULL,
    importe DECIMAL(15, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_user_id) REFERENCES usuario(user_id),
    FOREIGN KEY (receiver_user_id) REFERENCES usuario(user_id),
    FOREIGN KEY (currency_id) REFERENCES moneda(currency_id)
);

-- Modificar la tabla usuario para añadir la fecha de creación
ALTER TABLE usuario ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- INSERCIÓN DE DATOS (DML)
INSERT INTO moneda (currency_name, currency_symbol) VALUES 
('Peso Chileno', '$'), 
('Dólar Estadounidense', 'USD');

INSERT INTO usuario (nombre, correo_electronico, contrasena, saldo) VALUES
('Juan Pérez', 'juan@mail.com', 'pass123', 500000.00),
('María Soto', 'maria@mail.com', 'segura456', 150.50),
('Pedro Jara', 'pedro@mail.com', 'pedro789', 0.00);

INSERT INTO transaccion (sender_user_id, receiver_user_id, currency_id, importe) VALUES 
(1, 3, 1, 10000.00);

-- MODIFICACIÓN DE DATOS (UPDATE)
UPDATE usuario SET correo_electronico = 'juan.nuevo@gmail.com' WHERE user_id = 1;

-- CONSULTAS REQUERIDAS (DQL)
-- 1. Nombre de moneda de un usuario
SELECT u.nombre, m.currency_name FROM usuario u 
JOIN transaccion t ON u.user_id = t.sender_user_id 
JOIN moneda m ON t.currency_id = m.currency_id WHERE u.user_id = 1;

-- 2. Historial de todas las transacciones
SELECT t.transaction_id, u_envia.nombre AS Emisor, u_recibe.nombre AS Receptor, t.importe 
FROM transaccion t 
JOIN usuario u_envia ON t.sender_user_id = u_envia.user_id 
JOIN usuario u_recibe ON t.receiver_user_id = u_recibe.user_id;

-- 3. Transacciones de un usuario específico
SELECT * FROM transaccion WHERE sender_user_id = 1 OR receiver_user_id = 1;

-- ELIMINACIÓN DE DATOS (DELETE)
DELETE FROM transaccion WHERE transaction_id = 1;

-- PROPIEDADES ACID Y TRANSACCIONALIDAD (TCL)
-- Escenario 1: Rollback
START TRANSACTION;
INSERT INTO moneda (currency_name, currency_symbol) VALUES ('Euro', '€');
ROLLBACK; 

-- Escenario 2: Commit
START TRANSACTION;
UPDATE usuario SET saldo = saldo - 10000 WHERE user_id = 1;
UPDATE usuario SET saldo = saldo + 10000 WHERE user_id = 3;
COMMIT;
