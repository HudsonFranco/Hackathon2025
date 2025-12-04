# 🚀 Guia Completo: Deploy no Render com Docker + GitHub

Este guia mostra como fazer o deploy do projeto no Render usando Docker e conectando com o GitHub.

## 📋 Índice

1. [Preparar o Projeto para GitHub](#1-preparar-o-projeto-para-github)
2. [Fazer Push para o GitHub](#2-fazer-push-para-o-github)
3. [Configurar Render](#3-configurar-render)
4. [Configurar Variáveis de Ambiente](#4-configurar-variáveis-de-ambiente)
5. [Verificar Deploy](#5-verificar-deploy)

---

## 1. Preparar o Projeto para GitHub

### 1.1 Verificar Arquivos Importantes

Certifique-se de que estes arquivos existem:
- ✅ `Dockerfile`
- ✅ `docker-entrypoint.sh`
- ✅ `render.yaml`
- ✅ `.gitignore` (já existe e ignora `.env`)

### 1.2 Verificar que .env NÃO será commitado

O arquivo `.env` está no `.gitignore`, então **NÃO será enviado para o GitHub** (isso é correto por segurança).

### 1.3 Preparar Arquivos para Commit

Execute os seguintes comandos para adicionar os arquivos necessários:

```powershell
# Adicionar arquivos Docker
git add Dockerfile
git add docker-entrypoint.sh
git add docker-compose.yml
git add .dockerignore

# Adicionar arquivos de configuração
git add render.yaml
git add env.example

# Adicionar documentação
git add DOCKER.md
git add PASSO_A_PASSO_DOCKER.md
git add GUIA_DEPLOY_RENDER.md

# Adicionar arquivos modificados
git add app/settings.py
git add build.sh

# Verificar o que será commitado
git status
```

---

## 2. Fazer Push para o GitHub

### 2.1 Fazer Commit

```powershell
git commit -m "Adiciona configuração Docker e deploy no Render"
```

### 2.2 Fazer Push

```powershell
# Se estiver na branch main
git push origin main

# Ou se estiver em outra branch
git push origin sua-branch
```

### 2.3 Verificar no GitHub

Acesse seu repositório no GitHub e verifique se todos os arquivos foram enviados:
- https://github.com/HudsonFranco/Hackathon2025

**Importante**: Certifique-se de que o arquivo `.env` **NÃO** aparece no GitHub (por segurança).

---

## 3. Configurar Render

### 3.1 Criar Conta no Render

1. Acesse: https://render.com
2. Faça login com sua conta GitHub
3. Autorize o Render a acessar seus repositórios

### 3.2 Criar Novo Web Service

1. No dashboard do Render, clique em **"New +"**
2. Selecione **"Web Service"**
3. Conecte seu repositório GitHub:
   - Selecione o repositório: `HudsonFranco/Hackathon2025`
   - Escolha a branch: `main` (ou sua branch)

### 3.3 Configurar o Serviço

O Render detectará automaticamente o `render.yaml`, mas você pode configurar manualmente:

**Configurações Básicas:**
- **Name**: `hakaton-web` (ou o nome que preferir)
- **Environment**: `Docker`
- **Region**: Escolha a região mais próxima (ex: `Oregon (US West)`)
- **Branch**: `main`
- **Root Directory**: Deixe em branco (raiz do projeto)

**Build & Deploy:**
- **Build Command**: Deixe em branco (Dockerfile cuida disso)
- **Start Command**: Deixe em branco (Dockerfile cuida disso)

**Advanced:**
- **Dockerfile Path**: `Dockerfile` (ou deixe em branco se estiver na raiz)
- **Docker Context**: `.` (raiz do projeto)

### 3.4 Criar Banco de Dados PostgreSQL

1. No dashboard do Render, clique em **"New +"**
2. Selecione **"PostgreSQL"**
3. Configure:
   - **Name**: `hakaton-db`
   - **Database**: `hakaton_db`
   - **User**: `hakaton_user`
   - **Region**: Mesma região do web service
   - **Plan**: `Free` (ou escolha um plano pago)
4. Clique em **"Create Database"**

### 3.5 Conectar Banco ao Web Service

1. Vá para o web service criado
2. Na seção **"Environment"**, clique em **"Link Resource"**
3. Selecione o banco `hakaton-db`
4. O Render configurará automaticamente a variável `DATABASE_URL`

---

## 4. Configurar Variáveis de Ambiente

No Render, vá para seu web service e configure as variáveis de ambiente:

### 4.1 Variáveis Obrigatórias

1. **SECRET_KEY**
   - Clique em **"Add Environment Variable"**
   - Key: `SECRET_KEY`
   - Value: Gere uma chave secreta:
     ```powershell
     python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
     ```
   - Ou use: `django-insecure-change-this-in-production` (apenas para testes)

2. **DEBUG**
   - Key: `DEBUG`
   - Value: `False` (para produção)

3. **ALLOWED_HOSTS**
   - Key: `ALLOWED_HOSTS`
   - Value: `seu-app.onrender.com` (substitua pelo domínio do Render)
   - Ou deixe o Render gerar automaticamente (se configurado no render.yaml)

4. **OPENAI_API_KEY**
   - Key: `OPENAI_API_KEY`
   - Value: Sua chave da OpenAI (a mesma do seu `.env` local)

### 4.2 Variáveis Automáticas

Estas são configuradas automaticamente pelo Render:
- `DATABASE_URL` - Configurada ao conectar o banco de dados

### 4.3 Verificar Variáveis

Certifique-se de que todas as variáveis estão configuradas:
- ✅ `SECRET_KEY`
- ✅ `DEBUG`
- ✅ `ALLOWED_HOSTS`
- ✅ `DATABASE_URL` (automático)
- ✅ `OPENAI_API_KEY`

---

## 5. Verificar Deploy

### 5.1 Iniciar Deploy

1. Após configurar tudo, o Render iniciará automaticamente o deploy
2. Você pode acompanhar os logs em tempo real no dashboard
3. O primeiro deploy pode levar 5-10 minutos

### 5.2 Verificar Logs

Durante o deploy, verifique os logs para garantir que:
- ✅ Docker está construindo a imagem corretamente
- ✅ Dependências estão sendo instaladas
- ✅ Migrações estão sendo executadas
- ✅ Usuário admin está sendo criado
- ✅ Servidor está iniciando

### 5.3 Acessar Aplicação

Após o deploy concluir:
1. Você receberá uma URL como: `https://hakaton-web.onrender.com`
2. Acesse: `https://seu-app.onrender.com/admin`
3. Faça login com:
   - Username: `admin`
   - Password: `admin`
4. **IMPORTANTE**: Altere a senha imediatamente!

### 5.4 Verificar Funcionalidades

Teste se tudo está funcionando:
- ✅ Admin acessível
- ✅ Login funcionando
- ✅ Banco de dados conectado
- ✅ Upload de arquivos funcionando
- ✅ API da OpenAI funcionando

---

## 🔧 Troubleshooting

### Erro: "Build failed"

**Possíveis causas:**
1. Dockerfile com erro
2. Dependências não encontradas
3. Erro de sintaxe no código

**Solução:**
- Verifique os logs de build no Render
- Teste localmente: `docker build -t test .`
- Corrija os erros e faça novo push

### Erro: "Cannot connect to database"

**Possíveis causas:**
1. Banco não está conectado ao web service
2. `DATABASE_URL` não está configurada

**Solução:**
- Verifique se o banco está linkado ao web service
- Verifique se `DATABASE_URL` está nas variáveis de ambiente

### Erro: "DisallowedHost"

**Causa:** `ALLOWED_HOSTS` não inclui o domínio do Render

**Solução:**
- Adicione o domínio do Render em `ALLOWED_HOSTS`
- Ou configure para gerar automaticamente no `render.yaml`

### Erro: "Static files not found"

**Causa:** Arquivos estáticos não foram coletados

**Solução:**
- O `docker-entrypoint.sh` já coleta automaticamente
- Verifique os logs para confirmar

### Deploy muito lento

**Causa:** Build do Docker está demorando

**Solução:**
- Otimize o Dockerfile (use cache de layers)
- Considere usar um plano pago (builds mais rápidos)

---

## 📝 Checklist Final

Antes de fazer deploy, verifique:

- [ ] Todos os arquivos Docker estão no GitHub
- [ ] `.env` NÃO está no GitHub (verificado no .gitignore)
- [ ] `render.yaml` está configurado corretamente
- [ ] Banco de dados PostgreSQL criado no Render
- [ ] Banco conectado ao web service
- [ ] Todas as variáveis de ambiente configuradas
- [ ] `SECRET_KEY` é uma chave forte (não a padrão)
- [ ] `DEBUG=False` para produção
- [ ] `ALLOWED_HOSTS` inclui o domínio do Render
- [ ] `OPENAI_API_KEY` está configurada

---

## 🎯 Comandos Rápidos

### Fazer Push para GitHub
```powershell
git add .
git commit -m "Prepara deploy no Render"
git push origin main
```

### Ver Logs no Render
- Acesse o dashboard do Render
- Clique no seu web service
- Vá em "Logs"

### Reiniciar Serviço
- No dashboard do Render, clique em "Manual Deploy" → "Deploy latest commit"

### Verificar Variáveis de Ambiente
- No dashboard do Render, vá em "Environment" do seu web service

---

## 🔐 Segurança

**IMPORTANTE:**
- ✅ Nunca commite o arquivo `.env` no GitHub
- ✅ Use `SECRET_KEY` forte em produção
- ✅ Mantenha `DEBUG=False` em produção
- ✅ Não compartilhe suas chaves de API
- ✅ Altere a senha do admin após o primeiro login

---

## 📚 Recursos Adicionais

- [Documentação Render](https://render.com/docs)
- [Docker no Render](https://render.com/docs/docker)
- [PostgreSQL no Render](https://render.com/docs/databases)

---

**Pronto!** Seu projeto está no GitHub e configurado para deploy no Render! 🎉

Se tiver dúvidas ou problemas, consulte os logs no Render ou verifique a documentação.

