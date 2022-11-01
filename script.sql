use hcode;
drop table tb_funcionarios;
drop table tb_pessoas;
create table tb_funcionarios(

	id int not null primary key auto_increment,
    nome varchar(50) not null,
    salario decimal(10,2),
    sexo enum("M","F"),
    admissao date default CURRENT_DATE(),
    cadastro datetime default current_timestamp
);
insert into tb_funcionarios (nome,salario,sexo) values("Pedro Henrique",   4999.99,"M");
insert into tb_pessoas(nome, sexo) values
("Divanei", "M"),
("Luís", "M"),
("Djalma", "M"),
("Natali", "F"),
("Tatiane", "F"),
("Cristiane", "F"),
("Jaqueline", "F");

select * from tb_funcionarios;
select * from tb_pessoas;
delete from tb_funcionarios;

insert into tb_funcionarios -- INSERT COM BASE NA CONSULTA REALIZADA EM OUTRA TABELA
select id, nome, 950.00, sexo, current_date(),current_timestamp() from tb_pessoas;

select nome, salario as atual, CONVERT(salario * 1.1, DECIMAL(10,2)) as "aumento 10%"
from tb_funcionarios; -- SIMULAÇÃO DE AUMENTO DE 10% DE SALÁRIO

/*USO DA CLÁUSULA LIKE*/
select * from tb_funcionarios where nome LIKE "__V%"; -- underline é usado com a cláusula LIKE quando eu quero que a busca seja a partir de uma posição específica da string procurada
select * from tb_funcionarios where nome LIKE "j%"; -- inicia com j independente do que vier depois
select * from tb_funcionarios where nome LIKE "%ari%"; -- dentro do nome tem que ter 'ari'
select * from tb_funcionarios where nome NOT LIKE "%ari%"; -- dentro do nome NÃO PODE TER 'ari'

/*CLÁUSULA BETWEEN*/
 select * from tb_funcionarios WHERE salario BETWEEN 1500 AND 3000; -- UTILIZAMOS A CLÁSULA BETWEEN PARA COMPARAR UM INTERVALO DE VALORES
 select * from tb_funcionarios WHERE salario NOT BETWEEN 1500 AND 3000; -- UTILIZAMOS A CLÁSULA BETWEEN PARA COMPARAR UM INTERVALO DE VALORES
 
 /*trabalhando com datas*/
 select * from tb_funcionarios where cadastro > "2022-01-01";
 select * from tb_funcionarios where cadastro > "2022/01/01";
 select * from tb_funcionarios where cadastro > "2022.01.01";
 select * from tb_funcionarios where cadastro > "20220101";
 
 update tb_funcionarios set admissao = date_add(current_date(), interval 60 day) where id = 5; -- adicionando intervalo de 60 dias na data de admissao
 
 select datediff(admissao, current_date()) as "intervalo" from tb_funcionarios where id = 5;
 select * from tb_funcionarios where month(admissao) = 9; -- procurando funcionario contratado em um mes especifico
 select * from tb_funcionarios where year(admissao) = 2002; -- procurando funcionario contratado em um ano especifico
 
 /*trabalhando com order by e limit*/
 -- OBS: Por padrão a ordenação no MYSQL é sempre ASCEDENTE, LOGO SE NÃO QUISER NÃO PRECISA ESPEFICAR ORDENAÇÃO ASCENDENTE
 -- order by e limit são sempre o útimo comando da instrução select
 select * from tb_funcionarios order by nome; -- ordenando pela coluna nome
 select * from tb_funcionarios order by 5; -- ordenando pela posição de coluna na tabela(neste caso pela admimissao)
select * from tb_funcionarios order by salario DESC; -- ordenando pela coluna salario de forma descendente
select * from tb_funcionarios order by salario DESC, nome ASC; -- ordenando pela coluna salario de forma descendente E pela coluna nome de forma ascendente
select * from tb_funcionarios order by salario DESC LIMIT 5; -- ordenando pela coluna salario E LIMITANDO o número de registros trazidos
select * from tb_funcionarios LIMIT 2, 5; -- LIMITANDO o número de registros trazidos e especificando por qual registro a busca vai começar