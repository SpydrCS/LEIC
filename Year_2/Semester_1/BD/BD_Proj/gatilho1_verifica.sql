.mode columns
.header on
.nullvalue null

.print 'Começando pela tabela orcamentotransporte:'

.print ''

select * from orcamentotransporte;

.print ''

.print 'Tentando agora inserir uma nova linha na tabela orcamentotransporte em que os custos adicionais são superiores a 20 obtemos:'

.print ''

insert into orcamentotransporte values (20001, 1, 10001, 60, 21, 43895, 'normal');

.print ''

.print 'Como esperado, o gatilho foi acionado'