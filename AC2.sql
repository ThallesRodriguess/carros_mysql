drop database if exists trabalhinho_AC2_logistica;
create database trabalhinho_AC2_logistica;
use trabalhinho_AC2_logistica;


create table condutor (
	id					int				primary key		auto_increment,
	nome				varchar(60)		not null,
    veiculo				varchar(60),
    cnh					varchar(60)
);

create table veiculo (
	id					int				primary key		auto_increment,
	modelo				varchar(60),
    cor					varchar(60),
    placa				varchar(60)
);

create table viagem (
 	id					int				primary key		auto_increment,
	cidade_origem		varchar(60)		not null,
    cidade_destino		varchar(60)		not null,
    data_saida			timestamp,
    distancia			int				check (distancia>0)
);

create table condutor_viagem_veiculo (
	condutor_id			int 			references condutor(id),
    veiculo_id			int 			references veiculo(id),
    viagem_id			int 			references viagem(id)
);

create table delecoes (
	id					int				primary key		auto_increment,
    cidade_origem		varchar(60)		not null,
    cidade_destino		varchar(60)		not null,
    distancia			int,
	data_delecao		timestamp,
    usuario				varchar(60)
);

insert into condutor_viagem_veiculo (condutor_id, veiculo_id, viagem_id) values
	(1, 1, 1),
    (2, 2, 2),
	(3, 3, 3),
    (4, 4, 4),
    (5, 5, 5),
    (1, 1, 6),
    (1, 1, 7),
    (2, 2, 8),
    (3, 3, 9),
    (5, 5, 10);

 -- questão 6 =-=-=-=-=-=-=-=-=-=-=-=-=-:   
delimiter $
-- ----------------------------------------------------------------
create trigger verificar_destino before insert on viagem
for EACH row
begin
	if new.cidade_origem = new.cidade_destino then

		signal SQLSTATE '45000'
		set MESSAGE_TEXT = 'A origem da cidade de saída deve ser diferente da cidade de chegada.',
		MYSQL_ERRNO = 001;
        
end IF;
end$

delimiter ;
-- ------------------------------------------------------------------
delimiter $
create trigger verificar_distancia before insert on viagem
for EACH row
begin
	if new.distancia <= 0 then

		signal SQLSTATE '45000'
		set MESSAGE_TEXT = 'A distância deve ser maior que zero.',
		MYSQL_ERRNO = 002;
        
end IF;
end$
-- --------------------------------------------------------------------
create trigger verificar_destino_update before update on viagem
for EACH row
begin
	if new.cidade_origem = new.cidade_destino then

		signal SQLSTATE '45000'
		set MESSAGE_TEXT = 'A origem da cidade de saída deve ser diferente da cidade de chegada.',
		MYSQL_ERRNO = 001;
        
end IF;
end$

delimiter ;
-- ---------------------------------------------------------------------
delimiter $
create trigger verificar_distancia_update before update on viagem
for EACH row
begin
	if new.distancia <= 0 then

		signal SQLSTATE '45000'
		set MESSAGE_TEXT = 'A distância deve ser maior que zero.',
		MYSQL_ERRNO = 002;
        
end IF;
end$

insert into condutor (nome, veiculo, cnh) values
	("Thalles"	, "Corsa"	, "Sim"),
	("João"		, "Uno"		, "Não"),
	("Pedro"	, "Fusca"	, "Sim"),
	("Miguel"	, "Gol"		, "Não"),
	("Fernando"	, "Palio"	, "Sim");
    
insert into veiculo (modelo, cor, placa) values
	("Corsa", "preto"	, "ABC-123"),
	("Uno"	, "branco"	, "CBA-321"),
	("Fusca", "azul"	, "DEF-135"),
	("Gol"	, "vermelho", "QWE-637"),
	("Palio", "prata"	, "MPG-908");
    
insert into viagem (cidade_origem, cidade_destino, data_saida, distancia) values
	("Resende"		, "Aparecida"	,"2022-01-03 00:00:00", 100	),
    ("Aparecida"	, "Sorocaba"	,"2022-02-04 00:00:00", 260	),
    ("Sorocaba"		, "Salvador"	,"2022-03-06 00:00:00", 500	),
    ("Petrópolis"	, "Resende"		,"2022-04-08 00:00:00", 300	),
    ("Salvador"		, "Petrópolis"	,"2022-05-10 00:00:00", 800	),
    ("Resende"		, "Sorocaba"	,"2022-06-12 00:00:00", 600	),
    ("Aparecida"	, "Salvador"	,"2022-07-14 00:00:00", 750	),
    ("Sorocaba"		, "Petrópolis"	,"2022-08-18 00:00:00", 500	),
    ("Petrópolis"	, "Aparecida"	,"2022-09-20 00:00:00", 450	),
    ("Salvador"		, "Resende"		,"2022-10-26 00:00:00", 1000);
    
    
    -- select * from viagem
    
-- 1 - (1 ponto) - Crie o digrama lógico do banco de dados
-- "Diagrama"

-- 2 - (1 ponto) - Crie o script que cria as tabelas, seus relacionamentos e restrições
-- "create table ..."

-- 3 - (1 ponto) - Crie uma function que, dado a placa do veículo, retorna quantas viagens já fez.      
/*
delimiter $
create function quant_viagem (placa varchar(60))
    returns int deterministic
    begin
	return (select count(placa) from exibir_detalhes where exibir_detalhes.placa = placa);
	end$
        
delimiter ;*/

-- 4 - (1 ponto) - Crie uma PROCEDURE que, recebe apenas 4 parâmetros: cidade de orgiem, destino, condutor e veículo 
-- e registra uma viagem com data(amanhã) de saída no dia seguinte.

-- slide de FUNCTION link função "date_add()"
/*
drop procedure if exists saida_Dia_Seguinte;

delimiter $

create procedure saida_Dia_Seguinte(

  cidade_origem 	varchar(30),
  cidade_destino 	varchar(30),
  data_saida 		timestamp,
  nome 				varchar(30),
  modelo 			varchar(60)
)
begin
set @data_saida = (select DATE_ADD(sysdate(), INTERVAL 1 DAY));

insert into condutor (nome) value (nome);
insert into veiculo (modelo) value (modelo);
insert into viagem (cidade_origem, cidade_destino, data_saida) values (cidade_origem, cidade_destino, @data_saida);
end$

delimiter ;

call saida_Dia_Seguinte("Ratanaba", "Smallville","2022-01-03 00:00:00", "Patriota do caminhão", "Match 5");
select * from viagem
*/

-- 5 - (1 ponto) - Sempre que uma viagem for alterada, (TRIGGER)registre essa ocorrência em uma tabela apropriada.
/*
delimiter $
create trigger deletion after update on viagem
for each row
begin
	insert into delecoes values (
    null, new.cidade_origem, new.cidade_destino, new.distancia, sysdate(), user());
end$

delimiter ;

update viagem set cidade_origem = "Madagascar" where id = 10;
select * from viagem;
select * from delecoes;
*/


-- 6 - (1 ponto) - A origem deve ser sempre DIFERENTE do destino e a distância sempre MAIOR que zero, seja a viagem registrada por procedures 
-- ou pelos comandos insert e update.
-- (TRIGGER)

-- drop TRIGGER if exists verificar;


-- 7 - (1 ponto) - Crie uma VIEW que exibe os detalhes de todas as viagens, como nome das cidades, nome do condutor, placa e nome do veículo, data e etc.
/*create view exibir_detalhes as
	select  viagem.id				"Viagem", 
			viagem.distancia		"Distância",
			viagem.cidade_origem	"Cidade", 
            condutor.nome			"Condutor",
            veiculo.placa			"Placa",
            veiculo.modelo			"Veículo",
            viagem.data_saida		"Data"
            
            from condutor join condutor_viagem_veiculo
            on condutor.id = condutor_viagem_veiculo.condutor_id
            join veiculo 
            on veiculo.id = condutor_viagem_veiculo.veiculo_id
            join viagem 
            on viagem.id = condutor_viagem_veiculo.viagem_id;
*/
-- select * from exibir_detalhes;	   		 --- >>> SELECT DA Questão 7 <<< ---

-- select quant_viagem ('CBA-321'); --		 --- >>> SELECT DA Questão 3 <<< ---

-- 8 - (1 ponto) - Selecione as distâncias entre todos os pares de cidades.
-- select cidade_origem, cidade_destino, distancia from viagem order by cidade_origem;

-- 9 - (1 ponto) - Crie uma FUNÇÃO que dado duas cidades, retorna a distância entre elas, 
-- OU lance um erro caso a distância ou as cidades não estiverem previamente definidas.
-- COMEÇAR POR AQUI
/*drop function if exists verificar_dist;
delimiter $

create function verificar_dist (cidade_origem varchar(60), cidade_destino varchar(60))
returns int deterministic
begin
	set @distancia = (select distancia from viagem where cidade_origem = viagem.cidade_origem and cidade_destino = viagem.cidade_destino);
	if @distancia is null then

		signal SQLSTATE '45000'
		set MESSAGE_TEXT = 'Distância não sinalizada ou origem ou destino não definidos',
		MYSQL_ERRNO = 003;

end IF;
return (select distancia from viagem where cidade_origem = viagem.cidade_origem and cidade_destino= viagem.cidade_destino limit 1);
end$

delimiter ;

select verificar_dist("Resende","Aparecida") as "distancia em km entre as cidades";*/

-- 10 - (1 ponto) - Selecione todos os condutores sem CNH informada.
-- select nome, cnh from condutor where cnh = "Não"

