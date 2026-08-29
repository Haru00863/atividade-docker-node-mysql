Este repositório contém a entrega da atividade de comunicação manual entre containers. A aplicação consiste em uma API em Node.js que consulta um banco de dados MySQL, com ambos rodando em containers separados e se comunicando através de uma rede interna do Docker (resolução via DNS interno).

### Estrutura do Ambiente
- **Rede Docker:** rede-loja
- **Container MySQL:** container-mysql
- **Container Node:** container-node
- **Porta da aplicação:** 3000

*Aviso sobre limites de hardware:* O enunciado pede limite de 128m de RAM para os dois containers. No entanto, a imagem mysql:latest (MySQL 8+) sofre de falta de memória e o container desliga sozinho na inicialização com essa configuração. Para que a aplicação funcione, mantive o limite de CPU em 0.2 para ambos e a RAM do Node em 128m, mas precisei subir a RAM do MySQL para 512m nos comandos abaixo.

### Como iniciar o projeto

Para rodar a aplicação, abra o terminal na raiz do repositório e execute os comandos em sequência. Eles vão criar a rede, o volume e subir os containers:

1. Criar a rede e o volume
```bash
docker network create rede-loja
docker volume create volume-banco
```

2. Subir o banco de dados mapeando o arquivo SQL inicial
```bash
docker run -d --name container-mysql --network rede-loja --memory="512m" --cpus="0.2" -v volume-banco:/var/lib/mysql -v $(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=loja mysql:latest
```

3. Fazer o build da imagem da API
```bash
docker build -t imagem-node-api .
```

4. Subir a aplicação (Aguardar uns 15 a 20 segundos após subir o banco antes de rodar este comando, para dar tempo do MySQL inicializar)
```bash
docker run -d --name container-node --network rede-loja --memory="128m" --cpus="0.2" -p 3000:3000 imagem-node-api
```

Com os dois containers ativos, o Node usará o nome container-mysql como host para acessar o banco. Você pode testar os endpoints acessando o localhost:

- http://localhost:3000/categorias : Retorna todas as categorias cadastradas.
- http://localhost:3000/produtos : Retorna os produtos trazendo também o nome de suas respectivas categorias (utilizando um JOIN no banco de dados).

### Como recriar o banco de dados

A estrutura (tabelas e chaves estrangeiras) e os dados iniciais do banco são gerados automaticamente pelo arquivo init.sql, que está mapeado para a pasta /docker-entrypoint-initdb.d/ do container.

Se você quiser resetar o banco de dados e forçar a leitura do arquivo .sql do zero, é necessário apagar os containers e destruir o volume atual:

```bash
docker rm -f container-mysql container-node
docker volume rm volume-banco
```
