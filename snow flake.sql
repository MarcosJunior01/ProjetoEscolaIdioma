CREATE TABLE `dim_tempo` (
  `sk_tempo` int PRIMARY KEY,
  `data` date,
  `dia` int,
  `mes` int,
  `nome_mes` varchar(20),
  `trimestre` int,
  `semestre` int,
  `ano` int
);

CREATE TABLE `dim_endereco` (
  `sk_endereco` int PRIMARY KEY,
  `cep` varchar(8),
  `logradouro` varchar(150),
  `numero` varchar(20),
  `complemento` varchar(50),
  `bairro` varchar(100),
  `cidade` varchar(100),
  `estado` varchar(2)
);

CREATE TABLE `dim_pessoa` (
  `sk_pessoa` int PRIMARY KEY,
  `cpf` varchar(11) UNIQUE,
  `nome` varchar(150),
  `data_nascimento` date,
  `sk_endereco` int
);

CREATE TABLE `dim_idioma` (
  `sk_idioma` int PRIMARY KEY,
  `codigo_idioma` varchar(3) UNIQUE,
  `nome_idioma` varchar(100)
);

CREATE TABLE `dim_nivel` (
  `sk_nivel` int PRIMARY KEY,
  `codigo_nivel` varchar(10) UNIQUE,
  `nome_nivel` varchar(100)
);

CREATE TABLE `dim_sala` (
  `sk_sala` int PRIMARY KEY,
  `numero_sala` varchar(50) UNIQUE,
  `capacidade` int
);

CREATE TABLE `dim_curso` (
  `sk_curso` int PRIMARY KEY,
  `nome_curso` varchar(150),
  `carga_horaria` int,
  `sk_idioma` int,
  `sk_nivel` int
);

CREATE TABLE `dim_turma` (
  `sk_turma` int PRIMARY KEY,
  `codigo_turma` varchar(20) UNIQUE,
  `horario` varchar(50),
  `data_inicio` date,
  `data_fim` date,
  `status` varchar(50),
  `sk_curso` int,
  `sk_sala` int
);

CREATE TABLE `dim_aluno` (
  `sk_aluno` int PRIMARY KEY,
  `cpf_aluno` varchar(11) UNIQUE,
  `matricula` varchar(20),
  `status` varchar(50),
  `sk_pessoa` int
);

CREATE TABLE `dim_professor` (
  `sk_professor` int PRIMARY KEY,
  `cpf_professor` varchar(11) UNIQUE,
  `status` varchar(50),
  `sk_pessoa` int
);

CREATE TABLE `dim_funcionario` (
  `sk_funcionario` int PRIMARY KEY,
  `cpf_funcionario` varchar(11) UNIQUE,
  `data_contratacao` date,
  `status` varchar(50),
  `sk_pessoa` int
);

CREATE TABLE `dim_cargo` (
  `sk_cargo` int PRIMARY KEY,
  `cod_cargo` int UNIQUE,
  `nome_cargo` varchar(150)
);

CREATE TABLE `dim_fornecedor` (
  `sk_fornecedor` int PRIMARY KEY,
  `cnpj_fornecedor` varchar(14) UNIQUE,
  `nome_fantasia` varchar(150),
  `sk_pessoa` int
);

CREATE TABLE `dim_categoria_despesa` (
  `sk_categoria_despesa` int PRIMARY KEY,
  `codigo_categoria` varchar(20) UNIQUE,
  `nome_categoria` varchar(100),
  `tipo` varchar(50)
);

CREATE TABLE `dim_tipo_avaliacao` (
  `sk_tipo_avaliacao` int PRIMARY KEY,
  `nome_avaliacao` varchar(100) UNIQUE,
  `tipo` varchar(50)
);

CREATE TABLE `dim_beneficio` (
  `sk_beneficio` int PRIMARY KEY,
  `tipo` varchar(50) UNIQUE,
  `valor_inicial` decimal(10,2),
  `valor_final` decimal(10,2)
);

CREATE TABLE `dim_status` (
  `sk_status` int PRIMARY KEY,
  `descricao` varchar(50) UNIQUE
);

CREATE TABLE `fato_mensalidade` (
  `sk_mensalidade` int PRIMARY KEY,
  `sk_aluno` int,
  `sk_turma` int,
  `sk_tempo_vencimento` int,
  `sk_tempo_pagamento` int,
  `valor` decimal(10,2),
  `status` varchar(50),
  `desconto` decimal(10,2)
);

CREATE TABLE `fato_faturamento` (
  `sk_faturamento` int PRIMARY KEY,
  `sk_aluno` int,
  `sk_turma` int,
  `sk_tempo_vencimento` int,
  `sk_tempo_emissao` int,
  `valor` decimal(10,2),
  `tipo_documento` varchar(100),
  `status` varchar(50)
);

CREATE TABLE `fato_nota` (
  `sk_nota` int PRIMARY KEY,
  `sk_aluno` int,
  `sk_turma` int,
  `sk_professor` int,
  `sk_tipo_avaliacao` int,
  `sk_tempo` int,
  `nota` decimal(4,2)
);

CREATE TABLE `fato_frequencia` (
  `sk_frequencia` int PRIMARY KEY,
  `sk_aluno` int,
  `sk_turma` int,
  `sk_professor` int,
  `sk_tempo` int,
  `presente` tinyint,
  `observacao` varchar(255)
);

CREATE TABLE `fato_pedido_compra` (
  `sk_pedido_compra` int PRIMARY KEY,
  `sk_fornecedor` int,
  `sk_status` int,
  `sk_tempo_pedido` int
);

CREATE TABLE `fato_item_pedido` (
  `sk_item_pedido` int PRIMARY KEY,
  `sk_pedido_compra` int,
  `quantidade` int,
  `valor_unitario` decimal(10,2),
  `descricao` varchar(255)
);

CREATE TABLE `fato_fatura` (
  `sk_fatura` int PRIMARY KEY,
  `sk_fornecedor` int,
  `sk_categoria_despesa` int,
  `sk_tempo_emissao` int,
  `sk_tempo_vencimento` int,
  `valor` decimal(10,2),
  `juros` decimal(10,2),
  `multa` decimal(10,2),
  `status` varchar(50)
);

CREATE TABLE `fato_pagamento_fatura` (
  `sk_pagamento_fatura` int PRIMARY KEY,
  `sk_fatura` int,
  `sk_tempo_pagamento` int,
  `valor_pago` decimal(10,2),
  `metodo_pagamento` varchar(50)
);

CREATE TABLE `fato_folha_pagamento` (
  `sk_folha` int PRIMARY KEY,
  `sk_funcionario` int,
  `sk_cargo` int,
  `sk_tempo` int,
  `valor_base` decimal(10,2),
  `bonus` decimal(10,2),
  `descontos` decimal(10,2),
  `valor_final` decimal(10,2)
);

CREATE TABLE `fato_pagamento_funcionario` (
  `sk_pagamento_funcionario` int PRIMARY KEY,
  `sk_funcionario` int,
  `sk_tempo` int,
  `valor_pago` decimal(10,2),
  `metodo_pagamento` varchar(50)
);

CREATE TABLE `fato_registro_ponto` (
  `sk_registro_ponto` int PRIMARY KEY,
  `sk_funcionario` int,
  `sk_tempo` int,
  `hora_entrada` time,
  `hora_saida` time
);

CREATE TABLE `fato_beneficio_pagamento` (
  `sk_beneficio_pagamento` int PRIMARY KEY,
  `sk_funcionario` int,
  `sk_beneficio` int,
  `sk_tempo` int,
  `valor` decimal(10,2)
);

ALTER TABLE `dim_pessoa` ADD FOREIGN KEY (`sk_endereco`) REFERENCES `dim_endereco` (`sk_endereco`);

ALTER TABLE `dim_curso` ADD FOREIGN KEY (`sk_idioma`) REFERENCES `dim_idioma` (`sk_idioma`);

ALTER TABLE `dim_curso` ADD FOREIGN KEY (`sk_nivel`) REFERENCES `dim_nivel` (`sk_nivel`);

ALTER TABLE `dim_turma` ADD FOREIGN KEY (`sk_curso`) REFERENCES `dim_curso` (`sk_curso`);

ALTER TABLE `dim_turma` ADD FOREIGN KEY (`sk_sala`) REFERENCES `dim_sala` (`sk_sala`);

ALTER TABLE `dim_aluno` ADD FOREIGN KEY (`sk_pessoa`) REFERENCES `dim_pessoa` (`sk_pessoa`);

ALTER TABLE `dim_professor` ADD FOREIGN KEY (`sk_pessoa`) REFERENCES `dim_pessoa` (`sk_pessoa`);

ALTER TABLE `dim_funcionario` ADD FOREIGN KEY (`sk_pessoa`) REFERENCES `dim_pessoa` (`sk_pessoa`);

ALTER TABLE `dim_fornecedor` ADD FOREIGN KEY (`sk_pessoa`) REFERENCES `dim_pessoa` (`sk_pessoa`);

ALTER TABLE `fato_mensalidade` ADD FOREIGN KEY (`sk_aluno`) REFERENCES `dim_aluno` (`sk_aluno`);

ALTER TABLE `fato_mensalidade` ADD FOREIGN KEY (`sk_turma`) REFERENCES `dim_turma` (`sk_turma`);

ALTER TABLE `fato_mensalidade` ADD FOREIGN KEY (`sk_tempo_vencimento`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_mensalidade` ADD FOREIGN KEY (`sk_tempo_pagamento`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_faturamento` ADD FOREIGN KEY (`sk_aluno`) REFERENCES `dim_aluno` (`sk_aluno`);

ALTER TABLE `fato_faturamento` ADD FOREIGN KEY (`sk_turma`) REFERENCES `dim_turma` (`sk_turma`);

ALTER TABLE `fato_faturamento` ADD FOREIGN KEY (`sk_tempo_vencimento`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_faturamento` ADD FOREIGN KEY (`sk_tempo_emissao`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_nota` ADD FOREIGN KEY (`sk_aluno`) REFERENCES `dim_aluno` (`sk_aluno`);

ALTER TABLE `fato_nota` ADD FOREIGN KEY (`sk_turma`) REFERENCES `dim_turma` (`sk_turma`);

ALTER TABLE `fato_nota` ADD FOREIGN KEY (`sk_professor`) REFERENCES `dim_professor` (`sk_professor`);

ALTER TABLE `fato_nota` ADD FOREIGN KEY (`sk_tipo_avaliacao`) REFERENCES `dim_tipo_avaliacao` (`sk_tipo_avaliacao`);

ALTER TABLE `fato_nota` ADD FOREIGN KEY (`sk_tempo`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_frequencia` ADD FOREIGN KEY (`sk_aluno`) REFERENCES `dim_aluno` (`sk_aluno`);

ALTER TABLE `fato_frequencia` ADD FOREIGN KEY (`sk_turma`) REFERENCES `dim_turma` (`sk_turma`);

ALTER TABLE `fato_frequencia` ADD FOREIGN KEY (`sk_professor`) REFERENCES `dim_professor` (`sk_professor`);

ALTER TABLE `fato_frequencia` ADD FOREIGN KEY (`sk_tempo`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_pedido_compra` ADD FOREIGN KEY (`sk_fornecedor`) REFERENCES `dim_fornecedor` (`sk_fornecedor`);

ALTER TABLE `fato_pedido_compra` ADD FOREIGN KEY (`sk_status`) REFERENCES `dim_status` (`sk_status`);

ALTER TABLE `fato_pedido_compra` ADD FOREIGN KEY (`sk_tempo_pedido`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_item_pedido` ADD FOREIGN KEY (`sk_pedido_compra`) REFERENCES `fato_pedido_compra` (`sk_pedido_compra`);

ALTER TABLE `fato_fatura` ADD FOREIGN KEY (`sk_fornecedor`) REFERENCES `dim_fornecedor` (`sk_fornecedor`);

ALTER TABLE `fato_fatura` ADD FOREIGN KEY (`sk_categoria_despesa`) REFERENCES `dim_categoria_despesa` (`sk_categoria_despesa`);

ALTER TABLE `fato_fatura` ADD FOREIGN KEY (`sk_tempo_emissao`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_fatura` ADD FOREIGN KEY (`sk_tempo_vencimento`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_pagamento_fatura` ADD FOREIGN KEY (`sk_fatura`) REFERENCES `fato_fatura` (`sk_fatura`);

ALTER TABLE `fato_pagamento_fatura` ADD FOREIGN KEY (`sk_tempo_pagamento`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_folha_pagamento` ADD FOREIGN KEY (`sk_funcionario`) REFERENCES `dim_funcionario` (`sk_funcionario`);

ALTER TABLE `fato_folha_pagamento` ADD FOREIGN KEY (`sk_cargo`) REFERENCES `dim_cargo` (`sk_cargo`);

ALTER TABLE `fato_folha_pagamento` ADD FOREIGN KEY (`sk_tempo`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_pagamento_funcionario` ADD FOREIGN KEY (`sk_funcionario`) REFERENCES `dim_funcionario` (`sk_funcionario`);

ALTER TABLE `fato_pagamento_funcionario` ADD FOREIGN KEY (`sk_tempo`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_registro_ponto` ADD FOREIGN KEY (`sk_funcionario`) REFERENCES `dim_funcionario` (`sk_funcionario`);

ALTER TABLE `fato_registro_ponto` ADD FOREIGN KEY (`sk_tempo`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `fato_beneficio_pagamento` ADD FOREIGN KEY (`sk_funcionario`) REFERENCES `dim_funcionario` (`sk_funcionario`);

ALTER TABLE `fato_beneficio_pagamento` ADD FOREIGN KEY (`sk_beneficio`) REFERENCES `dim_beneficio` (`sk_beneficio`);

ALTER TABLE `fato_beneficio_pagamento` ADD FOREIGN KEY (`sk_tempo`) REFERENCES `dim_tempo` (`sk_tempo`);

ALTER TABLE `dim_beneficio` ADD FOREIGN KEY (`valor_final`) REFERENCES `dim_beneficio` (`sk_beneficio`);

ALTER TABLE `dim_beneficio` ADD FOREIGN KEY (`tipo`) REFERENCES `dim_beneficio` (`sk_beneficio`);

ALTER TABLE `dim_cargo` ADD FOREIGN KEY (`nome_cargo`) REFERENCES `dim_cargo` (`sk_cargo`);

ALTER TABLE `dim_curso` ADD FOREIGN KEY (`sk_curso`) REFERENCES `dim_curso` (`nome_curso`);

ALTER TABLE `dim_aluno` ADD FOREIGN KEY (`status`) REFERENCES `dim_aluno` (`matricula`);

ALTER TABLE `dim_fornecedor` ADD FOREIGN KEY (`sk_pessoa`) REFERENCES `dim_fornecedor` (`sk_fornecedor`);

ALTER TABLE `dim_aluno` ADD FOREIGN KEY (`sk_aluno`) REFERENCES `dim_aluno` (`cpf_aluno`);

ALTER TABLE `dim_nivel` ADD FOREIGN KEY (`nome_nivel`) REFERENCES `dim_nivel` (`sk_nivel`);
