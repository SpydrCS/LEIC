.mode columns
.headers on
.nullvalue NULL

select nome, telefone, email from Cliente where exists (select * from Encomenda where Cliente.idCliente=Encomenda.idCliente and estadoEnvio ='em transito');