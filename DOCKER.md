# Guia de Uso com Docker

Este guia explica como executar o projeto usando Docker com PostgreSQL.

## Pré-requisitos

- Docker instalado ([Download Docker](https://www.docker.com/get-started))
- Docker Compose instalado (geralmente vem com Docker Desktop)

## Configuração Inicial

### 1. Criar arquivo .env

Copie o arquivo `env.example` para `.env`:

```bash
cp env.example .env
```

Edite o arquivo `.env` e configure as variáveis:

```env
SECRET_KEY=sua-chave-secreta-aqui
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
POSTGRES_DB=hakaton_db
POSTGRES_USER=hakaton_user
POSTGRES_PASSWORD=hakaton_pass
OPENAI_API_KEY=sua-chave-openai-aqui
```

**Importante**: 
- Gere uma nova SECRET_KEY para produção
- Adicione sua chave da OpenAI
- Para gerar SECRET_KEY: `python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"`

## Executando o Projeto

### 1. Construir e iniciar os containers

```bash
docker-compose up --build
```

Ou para rodar em background:

```bash
docker-compose up -d --build
```

### 2. Acessar a aplicação

Após os containers iniciarem, acesse:
- **Aplicação**: http://localhost:8000
- **Admin**: http://localhost:8000/admin

### 3. Credenciais do Admin

O usuário admin é criado automaticamente com:
- **Username**: `admin`
- **Password**: `admin`
- **Email**: `admin@example.com`

**IMPORTANTE**: Altere a senha após o primeiro login!

## Comandos Úteis

### Ver logs
```bash
docker-compose logs -f
```

### Ver logs apenas do web
```bash
docker-compose logs -f web
```

### Parar os containers
```bash
docker-compose down
```

### Parar e remover volumes (apaga o banco de dados)
```bash
docker-compose down -v
```

### Executar comandos Django
```bash
# Criar migrações
docker-compose exec web python manage.py makemigrations

# Aplicar migrações
docker-compose exec web python manage.py migrate

# Criar superusuário
docker-compose exec web python manage.py createsuperuser

# Shell do Django
docker-compose exec web python manage.py shell

# Resetar admin
docker-compose exec web python manage.py reset_admin --username admin --password nova_senha
```

### Reconstruir apenas o container web
```bash
docker-compose up -d --build web
```

### Acessar o banco de dados PostgreSQL
```bash
docker-compose exec db psql -U hakaton_user -d hakaton_db
```

## Estrutura dos Containers

- **web**: Container da aplicação Django (porta 8000)
- **db**: Container do PostgreSQL (porta 5432)

## Volumes

Os seguintes volumes são criados para persistência:
- `postgres_data`: Dados do PostgreSQL
- `static_volume`: Arquivos estáticos coletados
- `media_volume`: Arquivos de mídia (uploads)

## Troubleshooting

### Erro: "Port already in use"
Se a porta 8000 ou 5432 já estiver em uso, altere no `docker-compose.yml`:

```yaml
ports:
  - "8001:8000"  # Mude 8001 para outra porta disponível
```

### Erro: "Permission denied" no docker-entrypoint.sh
Certifique-se de que o arquivo tem permissão de execução:
```bash
chmod +x docker-entrypoint.sh
```

### Erro de conexão com banco de dados
Verifique se o container `db` está rodando:
```bash
docker-compose ps
```

### Limpar tudo e começar do zero
```bash
docker-compose down -v
docker-compose up --build
```

### Ver logs de erro
```bash
docker-compose logs web
docker-compose logs db
```

## Desenvolvimento

Para desenvolvimento, você pode montar o código como volume (já configurado no docker-compose.yml). Isso permite que mudanças no código sejam refletidas sem reconstruir a imagem.

Para aplicar mudanças:
1. Faça as alterações no código
2. Se necessário, execute migrações: `docker-compose exec web python manage.py migrate`
3. Recarregue a página no navegador

## Produção

Para produção, considere:
1. Definir `DEBUG=False` no `.env`
2. Usar uma SECRET_KEY forte
3. Configurar `ALLOWED_HOSTS` com o domínio correto
4. Usar um servidor web reverso (nginx) na frente do Gunicorn
5. Configurar SSL/HTTPS
6. Fazer backup regular do volume `postgres_data`

