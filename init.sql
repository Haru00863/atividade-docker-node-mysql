CREATE DATABASE IF NOT EXISTS loja;
USE loja;

CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL,
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

INSERT INTO categorias (nome, descricao) VALUES 
('Eletrônicos', 'Dispositivos eletrônicos e gadgets'),
('Móveis', 'Móveis para casa e escritório'),
('Roupas', 'Vestuário masculino e feminino');

INSERT INTO produtos (nome, preco, quantidade_estoque, categoria_id) VALUES 
('Smartphone', 1500.00, 50, 1),
('Notebook', 3500.00, 30, 1),
('Mesa de Escritório', 450.00, 15, 2),
('Cadeira Gamer', 800.00, 10, 2),
('Camiseta de Algodão', 50.00, 100, 3);
