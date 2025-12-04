#!/bin/bash
set -e

# Se DATABASE_URL estiver definida (Render), não precisa aguardar db separado
if [ -z "$DATABASE_URL" ]; then
  echo "Aguardando PostgreSQL estar pronto..."
  while ! pg_isready -h db -U ${POSTGRES_USER:-hakaton_user} -d ${POSTGRES_DB:-hakaton_db}; do
    echo "PostgreSQL não está pronto ainda. Aguardando..."
    sleep 2
  done
  echo "PostgreSQL está pronto!"
else
  echo "Usando DATABASE_URL configurada (Render)"
fi

echo "Executando migrações..."
python manage.py migrate --no-input

echo "Criando/atualizando usuário admin..."
python manage.py reset_admin --username admin --password admin --email admin@example.com || echo "Usuário admin já existe ou erro ao criar"

echo "Coletando arquivos estáticos..."
python manage.py collectstatic --no-input || true

echo "Iniciando servidor..."
exec "$@"

