.mode columns
.headers on
.nullvalue NULL

select Transportadora.nome, avg (salario) as mediaSalario from Transportadora, EmpregadoTransporte where Transportadora.idTransportadora = EmpregadoTransporte.idTransportadora group by Transportadora.nome order by mediaSalario;