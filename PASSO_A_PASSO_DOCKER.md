# 🐳 Passo a Passo para Rodar o Projeto com Docker

## ✅ Pré-requisitos Verificados

- ✅ Docker instalado (versão 29.0.1)
- ✅ Docker Compose instalado (versão 2.40.3)
- ✅ Arquivo `.env` configurado com variáveis necessárias

## 📋 Passo a Passo Completo

### **Passo 1: Verificar Arquivos Necessários**

Certifique-se de que os seguintes arquivos existem na raiz do projeto:
- ✅ `Dockerfile`
- ✅ `docker-compose.yml`
- ✅ `docker-entrypoint.sh`
- ✅ `.env` (já configurado)

### **Passo 2: Verificar Conteúdo do .env**

Seu arquivo `.env` deve conter:
```env
OPENAI_API_KEY=sua-chave-aqui
SECRET_KEY=django-insecure-change-this-in-production
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
POSTGRES_DB=hakaton_db
POSTGRES_USER=hakaton_user
POSTGRES_PASSWORD=hakaton_pass
```

### **Passo 3: Parar Serviços que Podem Conflitar**

Se você estiver rodando o servidor Django localmente, pare-o:
```powershell
# Pressione Ctrl+C no terminal onde o servidor está rodando
```

Se a porta 8000 ou 5432 estiverem em uso, você precisará parar esses serviços primeiro.

### **Passo 4: Construir e Iniciar os Containers**

Execute o comando para construir as imagens e iniciar os containers:

```powershell
docker-compose up --build
```

**O que acontece:**
1. Docker baixa a imagem do PostgreSQL
2. Docker constrói a imagem da aplicação Django
3. PostgreSQL inicia e fica pronto
4. Django executa migrações automaticamente
5. Usuário admin é criado automaticamente
6. Servidor Gunicorn inicia na porta 8000

**Primeira execução pode levar alguns minutos** para baixar imagens e instalar dependências.

### **Passo 5: Aguardar Inicialização Completa**

Você verá mensagens como:
```
hakaton_db  | database system is ready to accept connections
hakaton_web | PostgreSQL está pronto!
hakaton_web | Executando migrações...
hakaton_web | Criando/atualizando usuário admin...
hakaton_web | Iniciando servidor...
hakaton_web | [INFO] Starting gunicorn...
```

Quando ver `Booting worker`, significa que está pronto!

### **Passo 6: Acessar a Aplicação**

Abra seu navegador e acesse:

- **Aplicação**: http://localhost:8000
- **Admin**: http://localhost:8000/admin

**Credenciais do Admin:**
- Username: `admin`
- Password: `admin`
- ⚠️ **IMPORTANTE**: Altere a senha após o primeiro login!

### **Passo 7: Rodar em Background (Opcional)**

Para rodar os containers em segundo plano:

```powershell
docker-compose up -d
```

Para ver os logs:
```powershell
docker-compose logs -f
```

## 🔧 Comandos Úteis

### Ver Status dos Containers
```powershell
docker-compose ps
```

### Ver Logs
```powershell
# Todos os serviços
docker-compose logs -f

# Apenas o serviço web
docker-compose logs -f web

# Apenas o banco de dados
docker-compose logs -f db
```

### Parar os Containers
```powershell
docker-compose down
```

### Parar e Remover Volumes (apaga banco de dados)
```powershell
docker-compose down -v
```

### Executar Comandos Django
```powershell
# Criar migrações
docker-compose exec web python manage.py makemigrations

# Aplicar migrações
docker-compose exec web python manage.py migrate

# Criar superusuário
docker-compose exec web python manage.py createsuperuser

# Shell do Django
docker-compose exec web python manage.py shell

# Resetar senha do admin
docker-compose exec web python manage.py reset_admin --username admin --password nova_senha
```

### Reconstruir Apenas o Container Web
```powershell
docker-compose up -d --build web
```

### Acessar o Banco de Dados PostgreSQL
```powershell
docker-compose exec db psql -U hakaton_user -d hakaton_db
```

## 🐛 Troubleshooting

### Erro: "Port already in use"

Se a porta 8000 ou 5432 já estiverem em uso:

1. **Opção 1**: Pare o serviço que está usando a porta
2. **Opção 2**: Altere as portas no `docker-compose.yml`:
   ```yaml
   ports:
     - "8001:8000"  # Mude para outra porta
   ```

### Erro: "Cannot connect to Docker daemon"

Certifique-se de que o Docker Desktop está rodando no Windows.

### Erro: "Permission denied" no docker-entrypoint.sh

O arquivo já tem permissão de execução, mas se necessário:
```powershell
# No Linux/Mac seria: chmod +x docker-entrypoint.sh
# No Windows, o Docker cuida disso automaticamente
```

### Erro de Conexão com Banco de Dados

1. Verifique se o container `db` está rodando:
   ```powershell
   docker-compose ps
   ```

2. Verifique os logs do banco:
   ```powershell
   docker-compose logs db
   ```

### Limpar Tudo e Começar do Zero

```powershell
# Para e remove containers e volumes
docker-compose down -v

# Remove imagens antigas (opcional)
docker system prune -a

# Reconstrói tudo
docker-compose up --build
```

### Verificar se o .env está sendo lido

```powershell
docker-compose exec web env | grep -E "SECRET_KEY|DEBUG|POSTGRES"
```

## 📝 Notas Importantes

1. **Dados Persistem**: Os dados do PostgreSQL são salvos no volume `postgres_data`, então mesmo parando os containers, seus dados não são perdidos.

2. **Desenvolvimento**: O código está montado como volume, então mudanças no código são refletidas automaticamente (exceto mudanças em dependências, que requerem rebuild).

3. **Produção**: Para produção, altere no `.env`:
   - `DEBUG=False`
   - Use uma `SECRET_KEY` forte
   - Configure `ALLOWED_HOSTS` com seu domínio

4. **Backup**: Para fazer backup do banco:
   ```powershell
   docker-compose exec db pg_dump -U hakaton_user hakaton_db > backup.sql
   ```

## ✅ Checklist Final

- [ ] Docker e Docker Compose instalados
- [ ] Arquivo `.env` configurado
- [ ] Containers construídos e rodando
- [ ] Aplicação acessível em http://localhost:8000
- [ ] Admin acessível em http://localhost:8000/admin
- [ ] Login no admin funcionando
- [ ] Senha do admin alterada

---

**Pronto!** Seu projeto está rodando com Docker e PostgreSQL! 🎉

