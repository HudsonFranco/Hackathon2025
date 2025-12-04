#!/bin/bash
set -e

# Se DATABASE_URL estiver definida (Render), não precisa aguardar db separado
if [ -n "$DATABASE_URL" ]; then
  echo "Usando DATABASE_URL configurada (Render/Produção) - pulando verificação de PostgreSQL"
  # No Render, o banco já está pronto, não precisa aguardar
else
  echo "Aguardando PostgreSQL estar pronto (docker-compose)..."
  # Aguarda até 60 segundos (30 tentativas x 2 segundos)
  max_attempts=30
  attempt=0
  while [ $attempt -lt $max_attempts ]; do
    if pg_isready -h db -U ${POSTGRES_USER:-hakaton_user} -d ${POSTGRES_DB:-hakaton_db} 2>/dev/null; then
      echo "PostgreSQL está pronto!"
      break
    fi
    attempt=$((attempt + 1))
    if [ $((attempt % 5)) -eq 0 ]; then
      echo "PostgreSQL não está pronto ainda. Aguardando... ($attempt/$max_attempts)"
    fi
    sleep 2
  done
  
  if [ $attempt -eq $max_attempts ]; then
    echo "AVISO: PostgreSQL não respondeu após 60 segundos. Continuando mesmo assim..."
  fi
fi

echo "Executando migrações..."
python manage.py migrate --no-input

echo "Criando/atualizando usuário admin..."
python manage.py reset_admin --username admin --password admin --email admin@example.com || echo "Usuário admin já existe ou erro ao criar"

echo "Coletando arquivos estáticos..."
python manage.py collectstatic --no-input || true

echo "Iniciando servidor..."
exec "$@"

