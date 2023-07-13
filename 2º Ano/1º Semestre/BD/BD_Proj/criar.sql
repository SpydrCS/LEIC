PRAGMA foreign_keys = ON;

drop table if exists Morada;

CREATE TABLE Morada (
idMorada INT NOT NULL UNIQUE,
pais	CHAR(100)	NOT NULL,
cidade	CHAR(100)	NOT NULL,
rua	CHAR(100)	NOT NULL,
numero	INT	NOT NULL,
andar	INT	NOT NULL,
CONSTRAINT numeroValido CHECK (numero>=1),
CONSTRAINT andarValido CHECK (andar>=0),
PRIMARY KEY(idMorada)
);

drop table if exists Cliente;

CREATE TABLE Cliente (
idCliente INT NOT NULL UNIQUE,
idMorada INT NOT NULL,
nome	CHAR(100)	NOT NULL,
numeroCC	INT	NOT NULL UNIQUE,
telefone	INT	NOT NULL UNIQUE,
email	CHAR(100)	NOT NULL UNIQUE,
nif	INT	NOT NULL UNIQUE,
pais	CHAR(100)	NOT NULL,
cidade	CHAR(100)	NOT NULL,
rua	CHAR(100)	NOT NULL,
numero	INT	NOT NULL,
andar	INT	NOT NULL,
CONSTRAINT numeroValido CHECK (numero>=1),
CONSTRAINT andarValido CHECK (andar>=0),
CONSTRAINT nifValidoMinimo CHECK (nif>100000000),
CONSTRAINT nifValidoMaximo CHECK (nif<999999999),
CONSTRAINT ccMinimo CHECK (numeroCC>10000000),
CONSTRAINT ccMaximo CHECK (numeroCC<99999999),
CONSTRAINT telefoneMinimo CHECK (telefone>900000000),
CONSTRAINT telefoneMaximo CHECK (telefone<999999999),
CONSTRAINT existeMorada FOREIGN KEY (idMorada) REFERENCES Morada(idMorada) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idCliente)
);

drop table if exists Empresa;

CREATE TABLE Empresa (
idEmpresa INT NOT NULL UNIQUE,
idMorada INT NOT NULL,
nome	CHAR(100) NOT NULL,
telefone	INT	NOT NULL UNIQUE,
email	CHAR(100)	NOT NULL UNIQUE,
pais	CHAR(100)	NOT NULL,
cidade	CHAR(100)	NOT NULL,
rua	CHAR(100)	NOT NULL,
numero	INT	NOT NULL,
andar	INT	NOT NULL,
CONSTRAINT numeroValido CHECK (numero>=1),
CONSTRAINT andarValido CHECK (andar>=0),
CONSTRAINT telefoneValidoMin CHECK (telefone>900000000),
CONSTRAINT telefoneValidoMax CHECK (telefone<999999999),
CONSTRAINT moradaValida FOREIGN KEY (idMorada) REFERENCES Morada(idMorada) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idEmpresa)
);

drop table if exists Fornecedora;

CREATE TABLE Fornecedora (
idEmpresa INT NOT NULL,
idFornecedora INT NOT NULL UNIQUE,
idMorada INT NOT NULL,
nome	CHAR(100)	NOT NULL UNIQUE, -- 2 fornecedoras nao podem ter o mesmo nome
telefone	INT	NOT NULL UNIQUE,
email	CHAR(100)	NOT NULL UNIQUE,
website	CHAR(100)	NOT NULL UNIQUE,
CONSTRAINT telefoneValidoMin CHECK (telefone>900000000),
CONSTRAINT telefoneValidoMax CHECK (telefone<999999999),
CONSTRAINT empresa1Valida FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idFornecedora)
);

drop table if exists TipoServico;

CREATE TABLE TipoServico (
idTipoServico INT NOT NULL UNIQUE,
duracaoMaxima	INT	NOT NULL,
tipoServico	CHAR(100)	NOT NULL,
CONSTRAINT tipoServicoValido CHECK (tipoServico = 'normal' or tipoServico = 'urgente'),
CONSTRAINT duracaoValida CHECK (duracaoMaxima>0),
PRIMARY KEY (idTipoServico)
);

drop table if exists Servico;

CREATE TABLE Servico (
idServico INT NOT NULL UNIQUE,
idTipoServico INT NOT NULL,
duracaoMaxima	INT	NOT NULL,
CONSTRAINT idTipoServicoValido FOREIGN KEY (idTipoServico) REFERENCES TipoServico(idTipoServico) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT duracaoValida CHECK (duracaoMaxima>0),
PRIMARY KEY (idServico)
);

drop table if exists Transportadora;

CREATE TABLE Transportadora (
idEmpresa INT NOT NULL,
idTransportadora INT NOT NULL UNIQUE,
idMorada INT NOT NULL,
nome	CHAR(100) NOT NULL UNIQUE, -- 2 transportadoras nao podem ter o mesmo nome
telefone	INT	NOT NULL UNIQUE,
email	CHAR(100)	NOT NULL UNIQUE,
areaEntrega	CHAR(100)	NOT NULL,
CONSTRAINT telefoneValidoMin CHECK (telefone>900000000),
CONSTRAINT telefoneValidoMax CHECK (telefone<999999999),
CONSTRAINT informacoesValidas FOREIGN KEY (idMorada) REFERENCES Morada(idMorada) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT empresa2Valida FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idTransportadora)
);

drop table if exists EmpregadoTransporte;

CREATE TABLE EmpregadoTransporte (
idMorada INT NOT NULL,
idEmpregadoTransporte INT NOT NULL UNIQUE,
idTransportadora INT NOT NULL,
numeroCC	INT	NOT NULL UNIQUE,
nome	CHAR(100)	NOT NULL,
telefone	INT	NOT NULL UNIQUE,
nif	INT	NOT NULL UNIQUE,
salario FLOAT NOT NULL,
pais	CHAR(100)	NOT NULL,
cidade	CHAR(100)	NOT NULL,
rua	CHAR(100)	NOT NULL,
numero	INT	NOT NULL,
andar	INT	NOT NULL,
CONSTRAINT ccValidoMinimo CHECK (numeroCC>10000000),
CONSTRAINT ccValidoMaximo CHECK (numeroCC<99999999),
CONSTRAINT nifValidoMinimo CHECK (nif>100000000),
CONSTRAINT nifValidoMaximo CHECK (nif<999999999),
CONSTRAINT telefoneValidoMinimo CHECK (telefone>900000000),
CONSTRAINT telefoneValidoMaximo CHECK (telefone<999999999),
CONSTRAINT salarioValido CHECK (salario>=0),
CONSTRAINT numeroValido CHECK (numero>=1),
CONSTRAINT andarValido CHECK (andar>=0),
CONSTRAINT moradaValida FOREIGN KEY (idMorada) REFERENCES Morada(idMorada) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT transportadoraValida FOREIGN KEY (idTransportadora) REFERENCES Transportadora(idTransportadora) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idEmpregadoTransporte)
);

drop table if exists FornecedoraCliente;

Create Table FornecedoraCliente (
idFornecedoraCliente INT NOT NULL UNIQUE,
idFornecedora INT NOT NULL,
idCliente INT NOT NULL,
CONSTRAINT fornecedoraValida FOREIGN KEY (idFornecedora) REFERENCES Fornecedora(idFornecedora) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT existeCliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idFornecedoraCliente)
);

drop table if exists FornecedoraTransportadora;

CREATE TABLE FornecedoraTransportadora (
idFornecedoraTransportadora INT NOT NULL UNIQUE,
idTransportadora INT NOT NULL,
idFornecedora INT NOT NULL,
CONSTRAINT fornecedoraValida FOREIGN KEY (idTransportadora) REFERENCES Transportadora(idTransportadora) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT transportadoraValida FOREIGN KEY (idFornecedora) REFERENCES Fornecedora(idFornecedora) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idFornecedoraTransportadora)
);

drop table if exists Modelos;

CREATE TABLE Modelos (
idModelos INT NOT NULL UNIQUE,
marca	CHAR(100)	NOT NULL,
modelo	CHAR(100)	NOT NULL,
PRIMARY KEY (idModelos)
);

drop table if exists VeiculoTransporte;

CREATE TABLE VeiculoTransporte (
idVeiculoTransporte INT NOT NULL UNIQUE,
idTransportadora INT NOT NULL,
idModelos INT NOT NULL,
matricula	CHAR(8) NOT NULL UNIQUE,
marca	CHAR(100)	NOT NULL,
modelo	CHAR(100)	NOT NULL,
CONSTRAINT transportadoraValida FOREIGN KEY (idTransportadora) REFERENCES Transportadora(idTransportadora) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT veiculoValido FOREIGN KEY (idModelos) REFERENCES Modelos(idModelos) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idVeiculoTransporte)
);

drop table if exists Produtos;

CREATE TABLE Produtos (
idProdutos INT NOT NULL UNIQUE,
idEncomenda INT NOT NULL,
numeroProduto INT NOT NULL UNIQUE,
quantidadeEmStock INT NOT NULL,
peso	INT	NOT NULL,
volume	INT	NOT NULL,
CONSTRAINT numeroProdutoValido CHECK (numeroProduto>0),
CONSTRAINT pesoValido CHECK (peso>0),
CONSTRAINT volumeValido CHECK (volume>0),
CONSTRAINT stockValido CHECK (quantidadeEmStock >= 0),
PRIMARY KEY (idProdutos)
);

drop table if exists Encomenda;

CREATE TABLE Encomenda (
idEncomenda INT NOT NULL UNIQUE,
idCliente INT NOT NULL,
idServico INT NOT NULL,
DataEncomenda DATETIME NOT NULL,
DataEntrega DATETIME NOT NULL,
idFornecedora INT NOT NULL,
idEmpregadoTransporte INT NOT NULL,
idProdutos INT NOT NULL,
numero INT NOT NULL,
nomeProduto	CHAR(100) NOT NULL,
peso	INT	NOT NULL,
volume	INT	NOT NULL,
estadoEnvio	CHAR(100)	NOT NULL,
tipoEntrega	CHAR(100)	NOT NULL,
CONSTRAINT datasValidas CHECK (DataEncomenda<=DataEntrega),
CONSTRAINT numeroValido CHECK (numero>0),
CONSTRAINT pesoValido CHECK (peso>0),
CONSTRAINT volumeValido CHECK (volume>0),
CONSTRAINT estadoValido CHECK (estadoEnvio = 'em transito' or estadoEnvio = 'em preparacao' or estadoEnvio = 'entregue'),
CONSTRAINT tipoValido CHECK (tipoEntrega = 'nacional' or tipoEntrega = 'internacional' or tipoEntrega = 'complementar'),
CONSTRAINT existeCliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT existeServico FOREIGN KEY (idServico) REFERENCES Servico(idServico) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT existeFornecedora FOREIGN KEY (idFornecedora) REFERENCES Fornecedora(idFornecedora) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT existeEmpregadoTransporte FOREIGN KEY (idEmpregadoTransporte) REFERENCES EmpregadoTransporte(idEmpregadoTransporte) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT produtoValido FOREIGN KEY (idProdutos) REFERENCES Produtos(idProdutos) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idEncomenda)
);

drop table if exists OrcamentoTransporte;

CREATE TABLE OrcamentoTransporte (
idOrcamentoTransporte INT NOT NULL UNIQUE,
idEncomenda INT NOT NULL,
idServico INT NOT NULL,
preco	FLOAT NOT NULL,
custosAdicionais FLOAT NOT NULL,
numeroEncomenda	INT	NOT NULL UNIQUE,
tipoServico	CHAR(100) NOT NULL,
CONSTRAINT tipoServicoValido CHECK (tipoServico = 'normal' or tipoServico = 'urgente'),
CONSTRAINT precoValido CHECK (preco>=0),
CONSTRAINT custosAdicionaisValidos CHECK (custosAdicionais>=0),
CONSTRAINT numeroEncomendaValido CHECK (numeroEncomenda>0),
CONSTRAINT encomendaValida FOREIGN KEY (idEncomenda) REFERENCES Encomenda(idEncomenda) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT servicoValido FOREIGN KEY (idServico) REFERENCES Servico(idServico) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (idOrcamentoTransporte)
);