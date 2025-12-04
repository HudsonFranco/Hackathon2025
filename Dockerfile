# Use uma imagem Python oficial como base
FROM python:3.11-slim

# Define o diretório de trabalho
WORKDIR /app

# Define variáveis de ambiente
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instala dependências do sistema necessárias para PostgreSQL e outras bibliotecas
RUN apt-get update && apt-get install -y \
    postgresql-client \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copia e instala dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o projeto
COPY . .

# Cria diretórios para staticfiles e media
RUN mkdir -p /app/staticfiles /app/media

# Coleta arquivos estáticos
RUN python manage.py collectstatic --no-input || true

# Expõe a porta 8000
EXPOSE 8000

# Script de inicialização
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["gunicorn", "app.wsgi:application", "--bind", "0.0.0.0:8000"]

