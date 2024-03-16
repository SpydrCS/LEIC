.mode columns
.headers on
.nullvalue NULL

select Transportadora.nome,(strftime("%s", DataEntrega)-strftime("%s", DataEncomenda)) / 86400  as DiasDuracao , areaEntrega from Encomenda, EmpregadoTransporte, Transportadora where EmpregadoTransporte.idTransportadora = Transportadora.idTransportadora and Encomenda.idEmpregadoTransporte = EmpregadoTransporte.idEmpregadoTransporte group by DiasDuracao order by areaEntrega;