.mode columns
.headers on
.nullvalue NULL

select nome, nomeProduto, count(nomeProduto) as numeroEncomendas from Encomenda inner join Fornecedora on Encomenda.idFornecedora = Fornecedora.idFornecedora group by nome,nomeProduto order by numeroEncomendas DESC limit 3;