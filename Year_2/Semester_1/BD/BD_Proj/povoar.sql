PRAGMA foreign_keys = ON;

.mode columns
.headers on

INSERT INTO Morada VALUES(1, 'Portugal', 'Porto', 'rua das flores', 23, 2);
INSERT INTO Morada VALUES(2, 'Portugal', 'Gaia', 'rua gil eanes', 546, 1);
INSERT INTO Morada VALUES(3, 'Portugal', 'Vila do Conde', 'rua da cerca', 945, 0);
INSERT INTO Morada VALUES(4, 'Portugal', 'Tras dos Montes', 'rua de tras dos montes', 234, 5);
INSERT INTO Morada VALUES(5, 'Portugal', 'La no fundo', 'aquela rua la no fundo', 894, 7);
INSERT INTO Morada VALUES(6, 'Portugal','Porto','Rua da cana',43,2);
INSERT INTO Morada VALUES(7, 'Portugal','Porto','Rua da xana',231,0);
INSERT INTO Morada VALUES(8, 'Portugal','Porto','Rua da banana',542,1);
INSERT INTO Morada VALUES(9, 'Portugal','Porto','Rua da ana',42,14);
INSERT INTO Morada VALUES(10, 'Portugal','Porto','Rua da joana',53,12);
INSERT INTO Morada VALUES(11, 'Portugal','Porto','Rua da cana',42,2);
INSERT INTO Morada VALUES(12, 'Portugal','Porto','Rua da xana',235,0);
INSERT INTO Morada VALUES(13, 'Portugal','Porto','Rua da banana',544,1);
INSERT INTO Morada VALUES(14, 'Portugal','Porto','Rua da ana',41,14);
INSERT INTO Morada VALUES(15, 'Portugal','Porto','Rua da joana',55,12);
INSERT INTO Morada VALUES(16, 'Portugal', 'Porto', 'rua santa catarina', 23, 2);
INSERT INTO Morada VALUES(17, 'Portugal', 'Funchal', 'rua santa maria', 546, 1);
INSERT INTO Morada VALUES(18, 'Portugal', 'Guarda', 'rua do comercio', 945, 0);
INSERT INTO Morada VALUES(19, 'Portugal', 'Vila Nova de Cerveira', 'rua dos pescadores', 894, 7);
INSERT INTO Morada VALUES(20, 'Portugal','Porto','Rua direita',43,2);
INSERT INTO Morada VALUES(21, 'Portugal','Porto','Rua dos capelistas',231,0);
INSERT INTO Morada VALUES(22, 'Portugal','Porto','Rua da liberdade',542,1);
INSERT INTO Morada VALUES(23, 'Portugal','Porto','Rua da flores',42,14);
INSERT INTO Morada VALUES(24, 'Portugal','Porto','Rua do quebra costas',53,12);
INSERT INTO Morada VALUES(25, 'Portugal','Porto','Rua do barredo',42,2);
INSERT INTO Morada VALUES(26, 'Portugal','Porto','Rua dos caldeireiros',235,0);
INSERT INTO Morada VALUES(27, 'Portugal','Porto','Rua formosa',544,1);
INSERT INTO Morada VALUES(28, 'Portugal','Porto','Rua dos fanqueiros',41,14);
INSERT INTO Morada VALUES(29, 'Portugal','Porto','Rua serpa pinto',55,12);
INSERT INTO Morada VALUES(30, 'Portugal', 'Tras dos Montes', 'rua dos mercadores', 234, 5);

INSERT INTO Cliente VALUES(1, 1, 'Vitor', 14307832, 912545343, 'sfjfs@gmail.com', 389102456, 'Portugal', 'Porto', 'rua das flores', 23, 2);
INSERT INTO Cliente VALUES(2, 2, 'Gi Tobias', 17493843, 912545542, 'dsfnks@gmail.com', 252013205, 'Portugal', 'Gaia', 'rua gil eanes', 546, 1);
INSERT INTO Cliente VALUES(3, 3, 'Lazarina', 19357421, 912544534, 'mkosdf@gmail.com', 139234567, 'Portugal', 'Vila do Conde', 'rua da cerca', 945, 0);
INSERT INTO Cliente VALUES(4, 4, 'Lazaro', 10398744, 993847563, 'lazaro@gmail.com', 789234876, 'Portugal', 'Tras dos Montes', 'rua de tras dos montes', 234, 5);
INSERT INTO Cliente VALUES(5, 5, 'Gerson', 15398713, 904924380, 'gerson@gmail.com', 576978445, 'Portugal', 'La no fundo', 'aquela rua la no fundo', 894, 7);
INSERT INTO Cliente VALUES(6, 16, 'Santiago', 10987456, 912545340, 'santiago@gmail.com', 389102455, 'Portugal', 'Porto', 'rua santa catarina', 23, 2);
INSERT INTO Cliente VALUES(7, 17, 'Francisco', 19485765, 912545541, 'francisco@gmail.com', 252013203, 'Portugal', 'Funchal', 'rua santa maria', 546, 1);
INSERT INTO Cliente VALUES(8, 18, 'Afonso', 10945687, 912544537, 'afonso@gmail.com', 139234560, 'Portugal', 'Guarda', 'rua do comercio', 945, 0);
INSERT INTO Cliente VALUES(9, 19, 'Duarte', 11837465, 993847561, 'duarte@gmail.com', 789234872, 'Portugal', 'Vila Nova de Cerveira', 'rua dos pescadores', 894, 7);
INSERT INTO Cliente VALUES(10, 20, 'Rodrigo', 15398715, 904924386, 'rodrigo@gmail.com', 576978446, 'Portugal','Porto','Rua direita',43,2);

INSERT INTO Empresa VALUES(1,1,'GPA Productions',972947364,'sdfkns@gmail.com','Portugal','Porto', 'sei la das quantas', 23, 2);
INSERT INTO Empresa VALUES(2,2,'Mekie LDA.',994328374,'njsdfsd@gmail.com','Portugal','Gaia', 'rua gil eanes', 546, 1);
INSERT INTO Empresa VALUES(3,3,'Gi Tobias FTW',917739743,'nmaoins@gmail.com','Portugal','Vila do Conde', 'rua da cerca', 945, 0);
INSERT INTO Empresa VALUES(4,4,'CTP LDA.',938475832,'ctp@gmail.com','Portugal','Lisboa', 'rua do canto', 9545, 1);
INSERT INTO Empresa VALUES(5,5,'Top Express ALE.',913267312,'topexpress@gmail.com','Portugal','Braga', 'rua da esquina', 1238, 3);
INSERT INTO Empresa VALUES(6,21,'Petrogal',972957364,'petrogal@gmail.com','Portugal','Porto','Rua dos capelistas',231,0);
INSERT INTO Empresa VALUES(7,22,'Continente',993328374,'continente@gmail.com','Portugal','Porto','Rua da liberdade',542,1);
INSERT INTO Empresa VALUES(8,23,'Pingo Doce',916739743,'pingodoce@gmail.com','Portugal','Porto','Rua da flores',42,14);
INSERT INTO Empresa VALUES(9,24,'EDP',938475632,'edp@gmail.com','Portugal','Porto','Rua do quebra costas',53,12);
INSERT INTO Empresa VALUES(10,25,'Monserrate',923267312,'monserrate@gmail.com','Portugal','Porto','Rua do barredo',42,2);

INSERT INTO Fornecedora VALUES(1,201,1,'GPA Productions',972947364,'sdfkns@gmail.com','gpa.com');
INSERT INTO Fornecedora VALUES(2,202,2,'Mekie LDA.',994328374,'njsdfsd@gmail.com','mekie.com');
INSERT INTO Fornecedora VALUES(3,203,3,'Gi Tobias FTW',917739743,'nmaoins@gmail.com','gitobias.com');
INSERT INTO Fornecedora VALUES(4,204,4,'Almeida LDA.',911938754,'almeida@gmail.com','almeida.com');
INSERT INTO Fornecedora VALUES(5,205,5,'Guedes Productions',912430423,'guedes@gmail.com','guedes.com');
INSERT INTO Fornecedora VALUES(6,206,26,'Petrogal',972957364,'petrogal@gmail.com','petrogal.com');
INSERT INTO Fornecedora VALUES(7,207,27,'Continente',993328374,'continente@gmail.com','continente.com');
INSERT INTO Fornecedora VALUES(8,208,28,'Pingo Doce',916739743,'pingodoce@gmail.com','pingodoce.com');
INSERT INTO Fornecedora VALUES(9,209,29,'EDP',938475632,'edp@gmail.com','edp.com');
INSERT INTO Fornecedora VALUES(10,210,30, 'Monserrate', 923267312, 'monserrate@gmail.com', 'monserrate.com');

INSERT INTO TipoServico VALUES(50001,20,'normal');
INSERT INTO TipoServico VALUES(50002,55,'urgente');
INSERT INTO TipoServico VALUES(50003,25,'normal');
INSERT INTO TipoServico VALUES(50004,45,'urgente');
INSERT INTO TipoServico VALUES(50005,24,'normal');
INSERT INTO TipoServico VALUES(50006,21,'normal');
INSERT INTO TipoServico VALUES(50007,56,'urgente');
INSERT INTO TipoServico VALUES(50008,26,'normal');
INSERT INTO TipoServico VALUES(50009,46,'urgente');
INSERT INTO TipoServico VALUES(50010,29,'normal');

INSERT INTO Servico VALUES(10001,50001,20);
INSERT INTO Servico VALUES(10002,50002,55);
INSERT INTO Servico VALUES(10003,50003,25);
INSERT INTO Servico VALUES(10004,50004,45);
INSERT INTO Servico VALUES(10005,50005,24);
INSERT INTO Servico VALUES(10006,50006,21);
INSERT INTO Servico VALUES(10007,50007,56);
INSERT INTO Servico VALUES(10008,50008,26);
INSERT INTO Servico VALUES(10009,50009,46);
INSERT INTO Servico VALUES(10010,50010,29);

INSERT INTO Transportadora VALUES(1,301,11,'O Felix FTW', 947384754, 'felix@gmail.com', 'Porto');
INSERT INTO Transportadora VALUES(2,302,12,'Jota da bota', 983954867, 'jotadabota@gmail.com', 'Lisboa');
INSERT INTO Transportadora VALUES(3,303,13,'Expresso Da Vila', 938495867, 'expresso@gmail.com', 'Tras dos Montes');
INSERT INTO Transportadora VALUES(4,304,14,'Ching Chong Productions', 943857482, 'chingchong@gmail.com', 'Lisboa');
INSERT INTO Transportadora VALUES(5,305,15,'UUPSY', 932467234, 'uupsy@gmail.com', 'Portugal');
INSERT INTO Transportadora VALUES(6,306,26,'Inersel', 947384734, 'inersel@gmail.com', 'Porto');
INSERT INTO Transportadora VALUES(7,307,27,'Dragus INT', 983954878, 'dragusint@gmail.com', 'Lisboa');
INSERT INTO Transportadora VALUES(8,308,28,'Hydro Stone', 938495856, 'hydrostone@gmail.com', 'Tras dos Montes');
INSERT INTO Transportadora VALUES(9,309,29,'Factor Ambiente', 943857489, 'factorambiente@gmail.com', 'Lisboa');
INSERT INTO Transportadora VALUES(10,310,30,'Dravo', 932467245, 'dravo@gmail.com', 'Portugal');

INSERT INTO EmpregadoTransporte VALUES(6,11,301,10449812,'Joca',938476564,439898434,735.00,'Portugal','Porto','Rua da cana',43,2);
INSERT INTO EmpregadoTransporte VALUES(7,12,302,13957498,'Jonathan',910001923,434309089,740.00,'Portugal','Porto','Rua da xana',231,0);
INSERT INTO EmpregadoTransporte VALUES(8,13,303,19487645,'Lazaro',932945856,321433987,750.00,'Portugal','Porto','Rua da banana',542,1);
INSERT INTO EmpregadoTransporte VALUES(9,14,304,18744567,'Franchesca',912437324,439843781,745.00,'Portugal','Porto','Rua da ana',42,14);
INSERT INTO EmpregadoTransporte VALUES(10,15,305,19384509,'Retorta',945387436,437890341,650.00,'Portugal','Porto','Rua da joana',52,12);
INSERT INTO EmpregadoTransporte VALUES(16,16,306,10449867,'Fernando',938676564,439778434,737.00,'Portugal', 'Porto', 'rua santa catarina', 23, 2);
INSERT INTO EmpregadoTransporte VALUES(17,17,307,13957423,'Raul',910001943,434309056,748.00,'Portugal', 'Funchal', 'rua santa maria', 546, 1);
INSERT INTO EmpregadoTransporte VALUES(18,18,308,19487687,'Frederico',932945834,321783987,755.00,'Portugal', 'Guarda', 'rua do comercio', 945, 0);
INSERT INTO EmpregadoTransporte VALUES(19,19,309,19485748,'Guilherme',912437788,193845643,742.50,'Portugal', 'Vila Nova de Cerveira', 'rua dos pescadores', 894, 7);
INSERT INTO EmpregadoTransporte VALUES(20,20,310,19384545,'Pedro',945387456,437890378,680.00,'Portugal','Porto','Rua direita',43,2);

INSERT INTO FornecedoraCliente VALUES(901,201,1);
INSERT INTO FornecedoraCliente VALUES(902,202,2);
INSERT INTO FornecedoraCliente VALUES(903,203,3);
INSERT INTO FornecedoraCliente VALUES(904,204,4);
INSERT INTO FornecedoraCliente VALUES(905,205,5);
INSERT INTO FornecedoraCliente VALUES(906,206,6);
INSERT INTO FornecedoraCliente VALUES(907,207,7);
INSERT INTO FornecedoraCliente VALUES(908,208,8);
INSERT INTO FornecedoraCliente VALUES(909,209,9);
INSERT INTO FornecedoraCliente VALUES(910,210,10);

INSERT INTO FornecedoraTransportadora VALUES(801,301,201);
INSERT INTO FornecedoraTransportadora VALUES(802,302,202);
INSERT INTO FornecedoraTransportadora VALUES(803,303,203);
INSERT INTO FornecedoraTransportadora VALUES(804,304,204);
INSERT INTO FornecedoraTransportadora VALUES(805,305,205);
INSERT INTO FornecedoraTransportadora VALUES(806,306,206);
INSERT INTO FornecedoraTransportadora VALUES(807,307,207);
INSERT INTO FornecedoraTransportadora VALUES(808,308,208);
INSERT INTO FornecedoraTransportadora VALUES(809,309,209);
INSERT INTO FornecedoraTransportadora VALUES(810,310,210);

INSERT INTO Modelos VALUES(40001,'Renault','Citroen');
INSERT INTO Modelos VALUES(40002,'Mercedes','Classe A');
INSERT INTO Modelos VALUES(40003,'Citroen','C4');
INSERT INTO Modelos VALUES(40004,'BMW','Classe B');
INSERT INTO Modelos VALUES(40005,'Nissan','Casquai');
INSERT INTO Modelos VALUES(40006,'Renault','C7');
INSERT INTO Modelos VALUES(40007,'Mercedes','Classe C');
INSERT INTO Modelos VALUES(40008,'Ferrari','Turismo');
INSERT INTO Modelos VALUES(40009,'McLaren','P1');
INSERT INTO Modelos VALUES(40010,'Nissan','Reboque');

INSERT INTO VeiculoTransporte VALUES(2001,301,40001,'ABDHS','Renault','Citroen');
INSERT INTO VeiculoTransporte VALUES(2002,302,40002,'DFGDG','Mercedes','Classe A');
INSERT INTO VeiculoTransporte VALUES(2003,303,40003,'NSFFS','Citroen','C4');
INSERT INTO VeiculoTransporte VALUES(2004,304,40004,'FJGDSD','BMW','Classe B');
INSERT INTO VeiculoTransporte VALUES(2005,305,40005,'DSFNJ','Nissan','Casquai');
INSERT INTO VeiculoTransporte VALUES(2006,306,40006,'SDFSD','Renault','C7');
INSERT INTO VeiculoTransporte VALUES(2007,307,40007,'FDSNI','Mercedes','Classe C');
INSERT INTO VeiculoTransporte VALUES(2008,308,40008,'DSFJKNS','Ferrari','Turismo');
INSERT INTO VeiculoTransporte VALUES(2009,309,40009,'GMFKDF','McLaren','P1');
INSERT INTO VeiculoTransporte VALUES(2010,310,40010,'FSDMKO','Nissan','Reboque');

INSERT INTO Produtos VALUES(30001,1,83543,100,23,43);
INSERT INTO Produtos VALUES(30002,2,54634,55,54,3);
INSERT INTO Produtos VALUES(30003,3,13298,20,45,65);
INSERT INTO Produtos VALUES(30004,4,48792,0,23,12);
INSERT INTO Produtos VALUES(30005,5,653432,25,54,89);
INSERT INTO Produtos VALUES(30006,5,653433,0,54,89);
INSERT INTO Produtos VALUES(30007,7,5456,150,54,3);
INSERT INTO Produtos VALUES(30008,8,13768,43,45,65);
INSERT INTO Produtos VALUES(30009,9,48462,54,23,12);
INSERT INTO Produtos VALUES(30010,10,687432,90,54,89);

INSERT INTO Encomenda VALUES(1,1,10001,'2020-10-01 23:15:43.000','2020-10-05 23:15:43.000',201,11,30001,8453,'Ponei',23,43,'em transito','nacional');
INSERT INTO Encomenda VALUES(2,2,10002,'2021-01-13 05:54:12.000','2021-02-13 05:54:12.000',202,12,30002,543,'Felix',54,3,'em preparacao','internacional');
INSERT INTO Encomenda VALUES(3,3,10003,'2022-08-20 12:23:54.000','2022-08-27 12:23:54.000',203,13,30003,6543,'Escada',45,65,'entregue','complementar');
INSERT INTO Encomenda VALUES(4,4,10004,'2024-03-01 01:22:45.000','2024-03-15 01:22:45.000',204,14,30004,6542,'Atrelado',1239,1032,'em transito','nacional');
INSERT INTO Encomenda VALUES(5,5,10005,'2021-09-13 06:10:12.000','2021-09-14 06:10:12.000',205,15,30005,6541,'Cadeira',123,31,'em preparacao','internacional');
INSERT INTO Encomenda VALUES(6,6,10006,'2020-10-05 23:15:43.000','2020-10-15 23:15:43.000',206,16,30006,765,'Ponei',23,43,'em transito','nacional');
INSERT INTO Encomenda VALUES(7,7,10007,'2021-01-15 05:54:12.000','2021-02-19 05:54:12.000',207,17,30007,875,'Felix',54,3,'em preparacao','internacional');
INSERT INTO Encomenda VALUES(8,8,10008,'2022-08-25 12:23:54.000','2022-08-27 12:23:54.000',208,18,30008,3457,'Escada',45,65,'entregue','complementar');
INSERT INTO Encomenda VALUES(9,9,10009,'2024-03-08 01:22:45.000','2024-03-17 01:22:45.000',209,19,30009,4567,'Atrelado',1239,1032,'em transito','nacional');
INSERT INTO Encomenda VALUES(10,10,10010,'2021-09-17 06:10:12.000','2021-09-20 06:10:12.000',210,20,30010,9786,'Cadeira',123,31,'em preparacao','internacional');

INSERT INTO OrcamentoTransporte VALUES(20001,1,10001,49.50,0.00,8453,'normal');
INSERT INTO OrcamentoTransporte VALUES(20002,2,10002,43.10,10.00,543,'urgente');
INSERT INTO OrcamentoTransporte VALUES(20003,3,10003,54.35,5.00,6543,'normal');
INSERT INTO OrcamentoTransporte VALUES(20004,4,10004,60.90,3.00,6542,'urgente');
INSERT INTO OrcamentoTransporte VALUES(20005,5,10005,35.99,14.00,6541,'normal');
INSERT INTO OrcamentoTransporte VALUES(20006,6,10006,49.50,0.00,765,'normal');
INSERT INTO OrcamentoTransporte VALUES(20007,7,10007,43.10,10.00,875,'urgente');
INSERT INTO OrcamentoTransporte VALUES(20008,8,10008,54.35,5.00,3457,'normal');
INSERT INTO OrcamentoTransporte VALUES(20009,9,10009,60.90,3.00,4567,'urgente');
INSERT INTO OrcamentoTransporte VALUES(20010,10,10010,35.99,14.00,9786,'normal');