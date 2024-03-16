.mode columns
.headers on
.nullvalue NULL

create view if not exists AntigoEmp as select nome, nif, dataEntrega from Encomenda, EmpregadoTransporte where Encomenda.idEmpregadoTransporte = EmpregadoTransporte.idEmpregadoTransporte order by dataEntrega DESC limit 1;
create view if not exists NumEncomendasEmp as select count(idEncomenda) as numeroEncomendasEmp, nif from Encomenda, EmpregadoTransporte where Encomenda.idEmpregadoTransporte = EmpregadoTransporte.idEmpregadoTransporte group by nif;
select nome, a.nif, numeroEncomendasEmp from AntigoEmp as a, NumEncomendasEmp as b where a.nif = b.nif;
