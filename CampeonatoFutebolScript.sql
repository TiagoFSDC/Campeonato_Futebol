create database CampeonatoFutebol
Go

use CampeonatoFutebol
GO

create table Campeonato(
    ID int not null,
    Nome varchar(30) not null,
    Ano INT

    CONSTRAINT PK_Campeonato PRIMARY KEY (ID)
)

Go
CREATE TABLE TIMEFut(
    Nome varchar(40) not null,
    Apelido varchar(30),
    DataCriacao DATE,

    CONSTRAINT PK_Time PRIMARY KEY (Nome),
)

GO
CREATE TABLE Classificacao(
    ID int identity(1,1) not null,
    NomeTime varchar(40) not null,
    IDCampeonato int not null,
    GolsFeitos int null,
    GolsSofridos int null, 
    SaldoGols int null,
    Pontos int null,
    Vitorias int,
    Derrotas int,
    Empate int,

    CONSTRAINT PK_Classificacao PRIMARY KEY(ID),
    CONSTRAINT FK_Classificacao_Campeonato FOREIGN KEY (IDCampeonato) REFERENCES Campeonato(ID),
    CONSTRAINT FK_Classificacao_Time FOREIGN KEY (NomeTime) REFERENCES TIMEFut (Nome)
)

GO

CREATE TABLE Partida(
    ID int identity(1,1) not null,
    NomeVis varchar(40) not null,
    NomeCasa varchar(40) not null,
    GolsTimeVis int not null,
    GolsTimeCasa int not null,


    CONSTRAINT PK_Partida PRIMARY KEY (ID),
    CONSTRAINT UNIQUE_PARTIDA UNIQUE (NomeVis,NomeCasa),
    CONSTRAINT FK_Partida_TimeV FOREIGN KEY (NomeVis) REFERENCES TIMEFut,
    CONSTRAINT FK_Partida_TimeC FOREIGN KEY (NomeCasa) REFERENCES TIMEFut
)

INSERT INTO Campeonato(ID, Nome, Ano) VALUES(
    1,
    'amador', 
    2023
)


EXEC.InsertTime 'Corinthians', 'Cor'
EXEC.InsertTime 'Flamengo', 'Fla'
EXEC.InsertTime 'Palmeiras', 'Pal'
EXEC.InsertTime 'Fluminense', 'Flu'
EXEC.InsertTime 'Sao Paulo', 'Sao'

Go
INSERT INTO Classificacao(NomeTime, IDCampeonato) VALUES(
    'Corinthians', 1), ('Flamengo', 1), ('Fluminense', 1), ('Palmeiras', 1), ('Sao Paulo', 1)

Go


Update  Classificacao Set GolsFeitos = 0,GolsSofridos = 0,SaldoGols = 0,
        Pontos = 0, Vitorias = 0, Derrotas = 0, Empate = 0

EXEC.InsertPartida 'Fluminense', 'Corinthians', 2,2
EXEC.InsertPartida 'Fluminense', 'Flamengo', 4,0
EXEC.InsertPartida 'Fluminense', 'Palmeiras', 2,3
EXEC.InsertPartida 'Fluminense', 'Sao Paulo', 2,0
EXEC.InsertPartida 'Corinthians', 'Palmeiras', 4,4
EXEC.InsertPartida 'Corinthians', 'Flamengo', 1,1
EXEC.InsertPartida 'Corinthians', 'Fluminense', 1,2
EXEC.InsertPartida 'Corinthians', 'Sao Paulo', 2,1
EXEC.InsertPartida 'Flamengo', 'Corinthians', 3, 4
EXEC.InsertPartida 'Flamengo', 'Fluminense', 1,0
EXEC.InsertPartida 'Flamengo', 'Palmeiras', 3,3
EXEC.InsertPartida 'Flamengo', 'Sao Paulo', 2,4
EXEC.InsertPartida 'Sao Paulo', 'Corinthians', 1,3
EXEC.InsertPartida 'Sao Paulo', 'Flamengo', 0,0
EXEC.InsertPartida 'Sao Paulo', 'Palmeiras', 0,0
EXEC.InsertPartida 'Sao Paulo', 'Fluminense', 1,0
EXEC.InsertPartida 'Palmeiras', 'Corinthians', 1,2
EXEC.InsertPartida 'Palmeiras', 'Flamengo', 3,0
EXEC.InsertPartida 'Palmeiras', 'Palmeiras', 2,0
EXEC.InsertPartida 'Palmeiras', 'Sao Paulo', 1,1

select * from Classificacao
select * from TIMEFut
select * from Campeonato
select * from Partida


-- Time que foi campeão:
Select NomeTime, Pontos, Vitorias, SaldoGols, GolsFeitos, GolsSofridos
from Classificacao 
where Pontos = (Select Max(Pontos) from Classificacao) 
AND Vitorias = (Select Max(Vitorias) from Classificacao)
order by Pontos desc 

-- Classificação dos 5 times por ordem de pontos
Select NomeTime, Pontos, Vitorias, Empate, Derrotas, SaldoGols, GolsFeitos, GolsSofridos
from Classificacao 
order by Pontos desc, SaldoGols desc

-- Time com mais gols feitos no campeonato
Select NomeTime, Pontos, GolsFeitos 
from Classificacao 
where GolsFeitos = (Select Max(GolsFeitos) from Classificacao)

-- Time que tomou mais gols no campeonato
Select NomeTime, Pontos, GolsSofridos
from Classificacao 
where GolsSofridos = (Select Max(GolsSofridos) from Classificacao)

-- Jogo que teve mais gols
SELECT NomeVis, NomeCasa, GolsTimeVis, GolsTimeCasa, (GolsTimeVis + GolsTimeCasa) AS Gols_Totais
FROM Partida
where (GolsTimeVis + GolsTimeCasa) = (Select MAX(GolsTimeVis + GolsTimeCasa) from Partida)

Go
-- Maior numero de gols que cada time fez em um único jogo
EXEC.MaisGols
