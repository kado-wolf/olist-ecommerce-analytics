"""Carrega os CSVs brutos da Olist no schema raw do Postgres."""
import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

# Lê o arquivo .env e coloca usuário, senha, banco e porta nas variáveis de ambiente
load_dotenv()

# Caminho da pasta data: sobe de src/ para a raiz do projeto e entra em data/
PASTA_DADOS = Path(__file__).resolve().parent.parent / "data"


def criar_conexao():
    """Monta a conexão com o Postgres usando os dados do .env."""
    url = URL.create(
        drivername="postgresql+psycopg2",  # tipo de banco + driver Python
        username=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host="localhost",  # o container expõe o banco na própria máquina
        port=int(os.getenv("POSTGRES_PORT")),  # 5434, a porta do olist-postgres
        database=os.getenv("POSTGRES_DB"),
    )
    return create_engine(url)


def nome_da_tabela(caminho_csv):
    """Gera o nome da tabela a partir do arquivo.
    Ex.: olist_orders_dataset.csv -> orders
    """
    return caminho_csv.stem.replace("olist_", "").replace("_dataset", "")


def carregar_dados():
    """Lê cada CSV da pasta data e grava como tabela no schema raw."""
    conexao = criar_conexao()

    # Cria o schema raw (a "pasta" das tabelas brutas) se ainda não existir
    with conexao.begin() as transacao:
        transacao.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))

    # Lista todos os CSVs da pasta, em ordem alfabética
    arquivos_csv = sorted(PASTA_DADOS.glob("*.csv"))
    if not arquivos_csv:
        raise SystemExit(f"Nenhum CSV encontrado em {PASTA_DADOS}")

    for arquivo in arquivos_csv:
        tabela = nome_da_tabela(arquivo)

        # dtype=str: na camada raw tudo entra como texto, igual ao arquivo original
        df = pd.read_csv(arquivo, dtype=str)

        # if_exists="replace": recria a tabela a cada execução, sem duplicar dados
        # chunksize: envia 10 mil linhas por vez para não sobrecarregar a memória
        df.to_sql(tabela, conexao, schema="raw", if_exists="replace",
                  index=False, chunksize=10_000, method="multi")

        print(f"raw.{tabela}: {len(df):,} linhas")


# Só executa a carga quando o arquivo é rodado direto (python src/load_raw.py)
if __name__ == "__main__":
    carregar_dados()