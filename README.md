# 📚 SISGESC — Sistema de Gestão de Escola de Idiomas

Banco de dados relacional desenvolvido em **MySQL** para gerenciar todos os processos de uma escola de idiomas: matrículas, financeiro de alunos, RH, despesas, compras e controle acadêmico.

---

## 🗂️ Estrutura de Arquivos

```
├── projetoSisgesc_final.sql        # Criação do banco e todas as tabelas
├── projetoSisgesc_seed_final.sql   # População inicial com dados de exemplo
├── projetoSisgesc_selects.sql      # Consultas otimizadas + índices
└── README.md                       # Este arquivo
```

---

## ⚙️ Pré-requisitos

- MySQL 8.0 ou superior
- Cliente MySQL (MySQL Workbench, DBeaver, TablePlus ou CLI)

---

## 🚀 Como rodar o banco

Execute os scripts **nesta ordem**:

### 1. Criar o banco e as tabelas

```sql
SOURCE projetoSisgesc_final.sql;
```

Ou pelo terminal:

```bash
mysql -u root -p < projetoSisgesc_final.sql
```

### 2. Popular com dados de exemplo

```sql
SOURCE projetoSisgesc_seed_final.sql;
```

Ou pelo terminal:

```bash
mysql -u root -p projetoSisgesc < projetoSisgesc_seed_final.sql
```

### 3. Criar índices e rodar as consultas

```sql
SOURCE projetoSisgesc_selects.sql;
```

> ⚠️ **Atenção:** nunca rode o seed antes das tabelas. As foreign keys serão violadas e a inserção falhará.

---

## 🗃️ Visão Geral das Tabelas

| Tabela | Descrição |
|---|---|
| `tb_pessoas` | Cadastro central de todas as pessoas do sistema |
| `tb_telefones` | Telefones vinculados a pessoas |
| `tb_emails` | Emails vinculados a pessoas |
| `tb_enderecos` | Endereços vinculados a pessoas |
| `tb_alunos` | Alunos cadastrados (herda de `tb_pessoas`) |
| `tb_funcionarios` | Funcionários cadastrados (herda de `tb_pessoas`) |
| `tb_cargos` | Cargos disponíveis na escola |
| `tb_cargos_funcionario` | Histórico de cargos por funcionário |
| `tb_beneficios` | Benefícios oferecidos aos funcionários |
| `tb_pagamentos_beneficios` | Registros de pagamento de benefícios |
| `tb_idiomas` | Idiomas ofertados pela escola |
| `tb_niveis` | Níveis de proficiência dos cursos |
| `tb_cursos` | Cursos (combinação de idioma + nível) |
| `tb_salas` | Salas físicas da escola e sua capacidade |
| `tb_turmas` | Turmas ativas com professor, sala e horário |
| `tb_professores_turmas` | Histórico de professores por turma |
| `tb_aulas` | Registro individual de cada aula realizada |
| `tb_matriculas` | Matrículas de alunos em turmas |
| `tb_frequencias` | Presença dos alunos por aula |
| `tb_avaliacoes` | Avaliações definidas por turma |
| `tb_notas` | Notas dos alunos por avaliação |
| `tb_mensalidades` | Cobranças mensais por matrícula |
| `tb_faturamentos` | Documentos fiscais emitidos (recibos, boletos) |
| `tb_fornecedores` | Fornecedores da escola |
| `tb_categorias_despesas` | Categorias de despesas operacionais |
| `tb_faturas` | Faturas de fornecedores a pagar |
| `tb_pagamentos_faturas` | Registros de pagamento de faturas |
| `tb_folha_pagamento` | Folha mensal de pagamento dos funcionários |
| `tb_pagamentos_funcionarios` | Comprovantes de pagamento da folha |
| `tb_pedidos_compra` | Pedidos de compra feitos por funcionários |
| `tb_itens_pedido` | Itens de cada pedido de compra |
| `tb_registros_ponto` | Registro de ponto diário dos funcionários |
| `tb_expulsos` | Histórico de alunos expulsos |

---

## 📐 Regras de Negócio

### Pessoas e Cadastro

- Toda entidade do sistema (aluno, funcionário ou fornecedor) é antes cadastrada em `tb_pessoas`, evitando duplicidade de dados como nome, CPF e contato.
- Uma pessoa pode ter múltiplos telefones, emails e endereços simultaneamente.
- Fornecedores são vinculados a uma pessoa física via CPF — o modelo pressupõe que o representante do fornecedor é cadastrado como pessoa.

---

### Alunos

- Um aluno pode ter status `ativo` ou `trancado`. Alunos trancados mantêm o histórico mas não participam ativamente das turmas.
- Um aluno pode estar matriculado em mais de uma turma ao mesmo tempo (ex: Inglês Básico e Espanhol Básico).
- A matrícula pode ter **desconto** e **bolsa** aplicados de forma independente. O desconto é um valor fixo e a bolsa é um auxílio financeiro — ambos coexistem na mesma matrícula.
- Alunos expulsos são registrados em `tb_expulsos` com data e CPF, mantendo o vínculo com `tb_alunos` para fins de histórico.

---

### Cursos e Turmas

- Um **curso** é definido pela combinação única de idioma + nível (ex: Inglês Básico, Francês Intermediário). Não existe curso sem as duas informações.
- Uma **turma** é uma instância de um curso em uma sala e horário específicos, com capacidade limitada pelo tamanho da sala (`tb_salas.capacidade`).
- Cada turma tem um **professor titular** registrado diretamente em `tb_turmas`. O histórico de todos os professores que já lecionaram na turma fica em `tb_professores_turmas`.
- As **aulas** são registros individuais de cada encontro, com hora de início, intervalo e fim — permitindo apurar a carga horária real executada.

---

### Avaliações e Notas

- Avaliações são definidas por turma (não por curso genérico), o que permite que cada turma tenha seu próprio cronograma de provas e trabalhos.
- Cada avaliação possui um **peso**, e a média final do aluno é calculada de forma **ponderada**.
- A frequência é registrada por aluno em cada aula individual. O percentual mínimo esperado é de **75% de presença** para aprovação.

---

### Financeiro — Alunos

- Para cada matrícula ativa, o sistema gera **mensalidades** mensais com data de vencimento, valor e status (`pago` / `pendente`).
- Quando uma mensalidade é quitada, um **faturamento** (recibo ou boleto) é emitido e registrado em `tb_faturamentos`, separando a cobrança do documento fiscal.
- Mensalidades vencidas e não pagas configuram inadimplência e devem ser monitoradas com o cálculo de dias em atraso.

---

### Financeiro — Despesas

- Faturas de fornecedores são categorizadas (material, tecnologia, limpeza, etc.) e registradas com valor original, juros e multa — permitindo controle de inadimplência também no lado das despesas.
- Uma fatura pode ter múltiplos pagamentos em datas diferentes (`tb_pagamentos_faturas`), suportando pagamentos parciais.

---

### Recursos Humanos

- Funcionários possuem histórico de cargos em `tb_cargos_funcionario`. O campo `ativo` indica o cargo vigente.
- A **folha de pagamento** é gerada mensalmente com valor base, bônus e descontos calculados separadamente.
- O **registro de ponto** é diário e serve como base para apurar horas trabalhadas, horas extras e possíveis descontos na folha.
- Benefícios são pagos separadamente da folha, com comprovante e método de pagamento próprios.

---

### Compras

- Apenas **funcionários** podem abrir pedidos de compra — pessoas externas não têm acesso a esse módulo.
- Um pedido pode conter múltiplos itens com quantidade e valor unitário.
- O fluxo de aprovação é controlado pelo campo `status` do pedido (`pendente` / `aprovado`).

---

## 📊 Consultas Disponíveis

O arquivo `projetoSisgesc_selects.sql` contém 16 consultas prontas divididas em 5 blocos:

**Bloco 1 — Acadêmico**
- Alunos com frequência abaixo de 75%
- Média ponderada por aluno por turma
- Ranking de alunos por nota dentro da turma
- Turmas com vagas disponíveis
- Alunos em múltiplas turmas
- Histórico completo de um aluno

**Bloco 2 — Financeiro: Alunos**
- Mensalidades em aberto com dias de atraso
- Inadimplência geral
- Receita realizada vs esperada por turma
- Impacto de bolsas e descontos na receita

**Bloco 3 — Financeiro: Despesas**
- Faturas vencidas por fornecedor
- Despesas por categoria no mês
- DRE simplificado (receitas vs despesas)
- Fornecedores por volume de faturas

**Bloco 4 — RH**
- Horas trabalhadas por funcionário no mês
- Folha consolidada por mês
- Funcionários por cargo ativo
- Carga de turmas por professor

**Bloco 5 — Operacional**
- Ocupação das salas
- Turmas sem professor titular
- Pedidos pendentes com valor estimado
- Aulas realizadas vs planejadas por turma

---

## 🔍 Performance

Todos os índices necessários para as consultas acima já estão declarados no início do arquivo `projetoSisgesc_selects.sql`. Use `EXPLAIN` para verificar se o MySQL está utilizando os índices corretamente:

```sql
EXPLAIN SELECT * FROM tb_mensalidades
WHERE status = 'pendente'
  AND data_vencimento < CURDATE();
```


