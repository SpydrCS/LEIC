.mode columns
.headers on
.nullvalue NULL

select Transportadora.nome, count(idEncomenda) as numEncomendas, strftime('%m',DataEntrega) as mesEntrega from Transportadora, Encomenda, EmpregadoTransporte where Encomenda.idEmpregadoTransporte = EmpregadoTransporte.idEmpregadoTransporte and Transportadora.idTransportadora = EmpregadoTransporte.idTransportadora group by Transportadora.nome, mesEntrega;