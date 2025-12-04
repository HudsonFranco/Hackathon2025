#!/usr/bin/env bash
# Script de build para o Render

set -o errexit  # Exit on error

echo "Instalando dependências..."
pip install -r requirements.txt

echo "Coletando arquivos estáticos..."
python manage.py collectstatic --no-input

echo "Executando migrações..."
python manage.py migrate --no-input

echo "Criando/atualizando usuário admin..."
python manage.py reset_admin --username admin --password admin --email admin@example.com || echo "Usuário admin já existe ou erro ao criar"

echo "Build concluído!"

