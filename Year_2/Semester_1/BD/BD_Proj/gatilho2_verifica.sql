.mode columns
.header on
.nullvalue null

.print 'Começaremos por observar a totalidade da tabela encomenda:'

.print ''

select * from encomenda;

.print ''

.print 'Vamos tentar adicionar uma nova linha na tabela encomenda, de um produto em que o seu stock seja igual a 0'

.print ''

insert into encomenda values (5,1,10001,'2021-10-01 23:15:43.000','2023-12-01 23:15:43.000',201,11,30006,8453,'ponei',23,43,'em transito', 'nacional');

.print ''

.print 'Como podemos observar, não nos é permitidio realizar uma encomenda de um artigo que não existe em stock'

.print ''

.print 'Relativamente aos aritigos em que o stock é diferente de 0, ou seja, que estão disponíveis, a situação torna-se diferente'

.print ''

select * from produtos;
.print 'Vamos agora criar uma nova encomenda:'

.print ''

insert into encomenda values (11,2,10001,'2020-09-01 24:25:43.000','2020-12-01 11:15:43.000',201,11,30002,543,'Felix',54,3, 'em preparacao', 'internacional');

.print 'Tendo em conta a encomenda que criamos, vamos verificar se teve algum efeito na quantidade em stock do produto encomendado'

select * from produtos;

.print ''

.print 'Observando a tabela, é possível notar que a quantidade em stock do produto com o id 30002 diminui para 54 (55-1)'



