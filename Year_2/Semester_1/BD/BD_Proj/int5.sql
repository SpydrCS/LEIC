.mode columns
.headers on
.nullvalue NULL

select avg(custosAdicionais) as mediaCustosAdicionais, tipoEntrega from OrcamentoTransporte, Encomenda where OrcamentoTransporte.idEncomenda = Encomenda.idEncomenda group by tipoEntrega;