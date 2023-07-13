.mode columns
.headers on
.nullvalue NULL

select OrcamentoTransporte.tipoServico as tipo, avg(preco) as mediaPreco, avg(duracaoMaxima) as mediaDuracaoMaxima from OrcamentoTransporte, Servico where OrcamentoTransporte.idServico = Servico.idServico group by tipo;