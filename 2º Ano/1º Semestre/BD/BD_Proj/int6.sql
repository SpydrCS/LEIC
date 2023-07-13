.mode columns
.headers on
.nullvalue NULL

select Morada.cidade,Cliente.nome, 'Cliente' as Tipo from Morada, cliente where Morada.idMorada = Cliente.idMorada union select Morada.cidade, EmpregadoTransporte.nome, 'Empregado' as Tipo from Morada, EmpregadoTransporte where Morada.idMorada = EmpregadoTransporte.idMorada order by Tipo, Morada.cidade;