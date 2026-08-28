const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
const port = 3000;

const dbConfig = {
    host: 'container-mysql', 
    user: 'root',
    password: 'rootpassword',
    database: 'loja'
};

app.get('/categorias', async (req, res) => {
    try {
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute('SELECT * FROM categorias');
        await connection.end();
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar categorias', detalhes: error.message });
    }
});

app.get('/produtos', async (req, res) => {
    try {
        const connection = await mysql.createConnection(dbConfig);
        const query = `
            SELECT p.id, p.nome, p.preco, p.quantidade_estoque, c.nome AS nome_categoria 
            FROM produtos p 
            JOIN categorias c ON p.categoria_id = c.id
        `;
        const [rows] = await connection.execute(query);
        await connection.end();
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar produtos', detalhes: error.message });
    }
});

app.listen(port, () => {
    console.log(`App rodando na porta ${port}`);
});
