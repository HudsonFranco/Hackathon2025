# Guia de Configuração no Render

## Problema: Admin não funciona no Render

O problema ocorre porque:
1. O banco de dados no Render é diferente do local (PostgreSQL vs SQLite)
2. O usuário admin precisa ser criado no banco de dados do Render
3. Configurações de segurança precisam ser ajustadas

## Soluções Implementadas

### 1. Configuração de Banco de Dados
O `settings.py` agora detecta automaticamente se está rodando no Render e usa PostgreSQL quando `DATABASE_URL` estiver disponível.

### 2. Script de Build Automático
O arquivo `build.sh` foi criado para:
- Instalar dependências
- Coletar arquivos estáticos
- Executar migrações
- Criar o usuário admin automaticamente

## Configuração no Render

### Passo 1: Variáveis de Ambiente
No painel do Render, configure as seguintes variáveis de ambiente:

```
SECRET_KEY=sua-chave-secreta-aqui
DEBUG=False
ALLOWED_HOSTS=seu-app.onrender.com
DATABASE_URL=(configurado automaticamente se você adicionar um banco PostgreSQL)
OPENAI_API_KEY=sua-chave-openai
```

**Importante**: 
- Gere uma nova SECRET_KEY para produção (não use a mesma do desenvolvimento)
- Para gerar uma SECRET_KEY: `python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"`

### Passo 2: Configurar Build Command
No Render, configure o Build Command como:
```bash
chmod +x build.sh && ./build.sh
```

Ou se preferir comandos separados:
```bash
pip install -r requirements.txt && python manage.py collectstatic --no-input && python manage.py migrate --no-input && python manage.py reset_admin --username admin --password admin --email admin@example.com
```

### Passo 3: Configurar Start Command
Configure o Start Command como:
```bash
gunicorn app.wsgi:application
```

### Passo 4: Adicionar Banco de Dados PostgreSQL
1. No painel do Render, vá em "New +" → "PostgreSQL"
2. Crie um novo banco de dados
3. Conecte o banco ao seu serviço web
4. O Render configurará automaticamente a variável `DATABASE_URL`

## Credenciais do Admin

Após o deploy, o usuário admin será criado automaticamente com:
- **Username**: `admin`
- **Password**: `admin`
- **Email**: `admin@example.com`

**IMPORTANTE**: Altere a senha após o primeiro login!

Para alterar a senha manualmente, você pode:
1. Usar o comando Django shell no Render
2. Ou executar: `python manage.py reset_admin --username admin --password sua-nova-senha`

## Troubleshooting

### Erro: "Invalid username/password"
- Verifique se as migrações foram executadas (`python manage.py migrate`)
- Verifique se o usuário admin foi criado (`python manage.py reset_admin --username admin --password admin`)

### Erro: "DisallowedHost"
- Verifique se `ALLOWED_HOSTS` está configurado corretamente com o domínio do Render

### Erro de conexão com banco de dados
- Verifique se o PostgreSQL está conectado ao serviço web
- Verifique se `DATABASE_URL` está configurada

