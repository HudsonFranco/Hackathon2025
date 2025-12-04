# ⚡ Resumo Rápido: Deploy no Render

## 🚀 Passos Rápidos

### 1. Adicionar arquivos ao Git
```powershell
git add Dockerfile docker-entrypoint.sh docker-compose.yml .dockerignore
git add render.yaml env.example
git add app/settings.py build.sh
git add *.md
```

### 2. Fazer Commit
```powershell
git commit -m "Adiciona configuração Docker e deploy no Render"
```

### 3. Fazer Push para GitHub
```powershell
git push origin main
```

### 4. No Render
1. Acesse: https://render.com
2. Conecte seu repositório GitHub
3. Crie um **Web Service** (Docker)
4. Crie um **PostgreSQL Database**
5. Configure variáveis de ambiente:
   - `SECRET_KEY` (gere uma nova)
   - `DEBUG=False`
   - `ALLOWED_HOSTS=seu-app.onrender.com`
   - `OPENAI_API_KEY` (sua chave)
   - `DATABASE_URL` (automático ao conectar o banco)

### 5. Acessar
- URL: `https://seu-app.onrender.com/admin`
- Login: `admin` / `admin`

---

📖 **Guia completo**: Veja `GUIA_DEPLOY_RENDER.md` para instruções detalhadas.

