.mode columns
.header on
.nullvalue null

PRAGMA foreign_keys = ON;

.print 'Primeiramente vamos olhar para a tabela cliente'

.print ''

select * from cliente;

.print ''

.print 'Vamos tentar inserir um cliente em que o seu email nao corresponda aos requisitos'

insert into cliente values (20, 20, 'Vitor', 34345, 913545343, 'sfjfs@gmail', 478321, 'Portugal', 'Porto', 'rua das floristas', 23, 2);

.print ''

.print 'Como podemos ver, o gatilho foi acionado'

.print ''

.print 'Tentando agora atualizar o email deste cliente,  vamos obter:'

.print ''

update cliente set email = 'sfjfsgmail.com' where idCliente = 1;

.print ''

.print 'Concluindo, os gatilhos foram ambos acionados corretamente'