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

/* constraints */
drop table tb_funcionarios;
drop table tb_pessoas;
show tables;

create table tb_pessoas(

	idpessoa int not null auto_increment,
    desnome varchar(256) not null,
    dtcadastro timestamp not null default current_timestamp(),
    CONSTRAINT PK_pessoas PRIMARY KEY (idpessoa)
) ENGINE = InnoDB;

create table tb_funcionarios(

	idfuncionario int not null auto_increment,
	idpessoa int not null,
	vlsalario decimal(10,2) not null default 1000.00,
	dtadmissao date not null,
    constraint PK_funcionarios primary key (idfuncionario),
    constraint FK_funcionario_pessoas foreign key(idpessoa)
		references tb_pessoas (idpessoa)
) ENGINE = InnoDB;

desc tb_funcionarios;

INSERT INTO tb_pessoas values(null, "João", null);
select * from tb_pessoas;

INSERT INTO tb_funcionarios values(null, 2,0, current_date());
select * from tb_funcionarios;

/* joins */
desc tb_funcionarios;
desc tb_pessoas;

select * from tb_funcionarios funcionarios
inner join tb_pessoas pessoas on funcionarios.idpessoa = pessoas.idpessoa; -- trazendo todas as colunas de ambas as tabelas

select desnome, vlsalario from tb_funcionarios
inner join tb_pessoas USING(idpessoa); -- utilizamos a cláusula USING quando o campo que unirá as duas tableas terá o mesmo nome, assim escrevemos menos
-- OBS: Diferente de quando usamos o ON, o USING não irá trazer o campo que une as tabelas duas vezes, é um detalhe que não afeta a consulta mas que deve ser lembrado 


/*EXEMPLOS DE SUBQUERYS*/

/*
podemos usar o subquery para usar o resultado de uma consulta como view(tabela) para uma segunda consulta
detalhe que o campo que faz join não pode ser duplicado ou gerará erro, por isso eu trouxe apena um campo de codigo na subquerye
neste exemplo eu utilizei uma consulta com base numa subconsulta
*/
select * from (
select a.idpessoa as codigo, vlsalario as salario,desnome as nome from tb_funcionarios a
inner join tb_pessoas b on a.idpessoa = b.idpessoa) as tb1
where tb1.salario > 2000;

select * from tb_pessoas a
where not exists(select 1 from tb_funcionarios b where b.idpessoa = a.idpessoa);

/*
subquery que traz registros de pessoas que estão apenas na tbpessoas e não são funcionarios
*/
select * from tb_pessoas a
left join tb_funcionarios b on a.idpessoa = b.idpessoa 
where not exists(select idpessoa from tb_pessoas where b.idpessoa = a.idpessoa);

select b.idpessoa as codigo from tb_pessoas a
inner join tb_funcionarios b on a.idpessoa = b.idpessoa;

select idpessoa from tb_pessoas where desnome like "m%";

/*
deletando registros de acordo com resultado da subquery onde o campo where
é preenchido pelo select
*/
delete from tb_pessoas where idpessoa in(
select idpessoa from tb_pessoas where desnome like "m%"
);
