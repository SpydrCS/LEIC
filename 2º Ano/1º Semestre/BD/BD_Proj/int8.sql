.mode columns
.headers on
.nullvalue NULL

select nome, website from Fornecedora where idFornecedora not in (select idFornecedora from Encomenda where Encomenda.nomeProduto = 'Atrelado');