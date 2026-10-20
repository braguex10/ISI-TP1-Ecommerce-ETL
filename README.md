# ISI 2026/27 – Trabalho Prático I: ETL em E-Commerce

**Gestão de Stocks e Vendas em E-Commerce** — o mesmo processo ETL implementado em duas plataformas: **Pentaho Data Integration** e **KNIME**.

## Enquadramento
* **Unidade Curricular:** Integração de Sistemas de Informação (ISI)
* **Curso:** Licenciatura em Engenharia de Sistemas Informáticos
* **Instituição:** IPCA – Escola Superior de Tecnologia

## Equipa
| Aluno | Número | Plataforma |
|---|---|---|
| Gonçalo Braga | 31508 | Pentaho Data Integration (Spoon) |
| Gonçalo Rodrigues | 31507 | KNIME Analytics Platform |

## Tema
Uma loja online recebe dados de vários sistemas, em formatos diferentes e com problemas de qualidade. O processo ETL integra essas fontes, limpa e valida os dados, anonimiza os dados pessoais (RGPD), calcula totais e margens, separa as vendas válidas das rejeitadas, gera alertas de stock e guarda os resultados em ficheiros e numa base de dados.

## Processo ETL

| Fase | O que faz |
|---|---|
| **E – Extração** | Vendas (JSON), produtos e stock (CSV), fornecedores (XML) e taxas de câmbio via **API REST** ([Frankfurter](https://frankfurter.dev/)) |
| **T – Transformação** | Desdobramento do JSON, validação e normalização com **Regex** (email, NIF, telefone), tratamento de nulos, correção de valores, remoção de duplicados, lookups com produtos e fornecedores, cálculo de totais/margens/conversão de moeda, filtragem de vendas válidas e rejeitadas, classificação do stock, **anonimização** e agregação por categoria |
| **L – Carregamento** | Exportação para **JSON, CSV e XML**, base de dados **SQLite**, **log de execução** e **Job** de orquestração com notificação por email (Pentaho) |

## Estrutura do repositório
```
├── data/        # Dados de entrada (partilhados pelas duas plataformas)
├── pentaho/     # 01_ler_dados.ktr (transformação) e job_etl.kjb (job)
├── knime/       # TP1_Ecommerce_ETL.knwf (workflow)
├── output/
│   ├── pentaho/ # Resultados gerados pelo Pentaho
│   └── knime/   # Resultados gerados pelo KNIME
├── sql/         # Consultas de verificação da base de dados
└── docs/        # Relatório final
```

## Como executar

**Pré-requisitos:** Pentaho Data Integration 10.x, KNIME 5.x e ligação à internet (API de câmbios).

**Pentaho**
1. Clonar o repositório: `git clone https://github.com/braguex10/ISI-TP1-Ecommerce-ETL.git`
2. No Spoon, abrir `pentaho/job_etl.kjb` e carregar em **Run**.
3. Os resultados são gravados em `output/pentaho/`.

Os caminhos são relativos, por isso não é preciso alterar nada. Para o envio de email, preencher a palavra-passe de aplicação Gmail nos passos *Email Sucesso* e *Email Erro* (as credenciais não estão incluídas no repositório por segurança).

**KNIME**
1. **File → Import KNIME Workflow** → `knime/TP1_Ecommerce_ETL.knwf`
2. Ajustar, se necessário, os caminhos das pastas `data/` e `output/knime/`.
3. **Execute All**. Os resultados são gravados em `output/knime/`.

## Resultados
As duas plataformas produzem os mesmos resultados:

| Indicador | Pentaho | KNIME |
|---|---|---|
| Vendas válidas / rejeitadas | 2 / 3 | 2 / 3 |
| Total de vendas válidas | 538,80 € | 538,80 € |
| Alertas de stock | 4 | 4 |
| Taxas de câmbio usadas | USD 1,1253 · GBP 0,84385 | USD 1,1253 · GBP 0,84385 |

**Ficheiros gerados:** `fact_vendas.json` (vendas válidas anonimizadas), `vendas_rejeitadas.csv`, `resumo_categoria.csv`, `alertas_stock.xml`, `log_execucao.csv` e a base de dados SQLite (`ecommerce_pentaho.db` / `ecommerce_knime.db`).

## Documentação e vídeo
*  **Relatório:** [`docs/`](docs)
*  **Vídeo de demonstração:** *(a adicionar)*
