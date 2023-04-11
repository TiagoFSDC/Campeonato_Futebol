CREATE OR ALTER PROCEDURE InsertTime @nome varchar(40),  @Apelido varchar(30)
AS 
BEGIN
    Insert INTO TIMEFut(Nome,Apelido) VALUES(
        @nome, @Apelido
    )
END;

Go
CREATE OR ALTER PROCEDURE InsertPartida @nomeV varchar(40), @nomeC varchar(40),@GolsV int, @GolsC int
AS 
BEGIN
    Insert INTO Partida(NomeVis,NomeCasa,GolsTimeVis, GolsTimeCasa) VALUES(
        @nomeV, @nomeC, @GolsV, @GolsC
    )
END;

GO
CREATE OR ALTER TRIGGER TGR_Calculo on Partida AFTER Insert
AS
BEGIN
    DECLARE @golstimevis int, @golstimecasa int, @saldo int, @nomevis varchar(40), @nomecasa varchar(40),
            @pontosVis int, @pontosCasa int

    Select  @golstimevis = GolsTimeVis,
            @golstimecasa =  GolsTimeCasa,
            @nomevis = NomeVis,
            @nomecasa = NomeCasa
            from inserted
    
    Update Classificacao set 
    SaldoGols = isnull(SaldoGols,0)  + (@golstimecasa - @golstimevis),
    GolsFeitos = isnull(GolsFeitos,0) + @golstimecasa,
    GolsSofridos = isnull(GolsSofridos,0) + @golstimevis
    where NomeTime = @nomecasa

    Update Classificacao set
    SaldoGols = isnull(SaldoGols,0) + (@golstimevis - @golstimecasa),
    GolsFeitos = isnull(GolsFeitos,0) + @golstimevis,
    GolsSofridos = isnull(GolsSofridos,0) + @golstimecasa
    where NomeTime = @nomevis

    Set @pontosCasa = Case 
        WHEN (@golstimecasa > @golstimevis) THEN 3
        WHEN (@golstimevis > @golstimecasa) THEN 0
        ELSE 1
    end

    If(@pontosCasa = 3)
        Update Classificacao Set Vitorias = isnull(Vitorias,0) + 1 where NomeTime = @nomecasa
    If(@pontosCasa = 0)
        Update Classificacao Set Derrotas = isnull(Derrotas,0) + 1 where NomeTime = @nomecasa
    If(@pontosCasa = 1)    
        BEGIN
            Update Classificacao Set Empate = isnull(Empate,0) + 1 where NomeTime = @nomecasa
            Update Classificacao Set Empate = isnull(Empate,0) + 1 where NomeTime = @nomevis
        END;
    
    Set @pontosVis = Case 
        WHEN (@golstimevis > @golstimecasa) THEN 5
        WHEN (@golstimecasa > @golstimevis) THEN 0
        ELSE 1
    END

    If(@pontosVis = 5)
        Update Classificacao Set Vitorias = isnull(Vitorias,0) + 1 where NomeTime = @nomevis
    If(@pontosVis = 0)
        Update Classificacao Set Derrotas = isnull(Derrotas,0) + 1 where NomeTime = @nomevis
    
    UPDATE Classificacao SET
    Pontos = isnull(Pontos,0) + @pontosCasa
    where NomeTime = @nomecasa

    UPDATE Classificacao SET
    Pontos = isnull(Pontos,0) + @pontosVis
    where NomeTime = @nomevis

END;

Go
Create or ALTER PROC MaisGols 
AS
BEGIN
    Select TimesFut, Max(Mais_Gols) AS MaisGols
    FROM (
        Select NomeVis as TimesFut, MAX(GolsTimeVis) AS Mais_Gols
        from Partida
        group by NomeVis 
        Union
        Select NomeCasa as TimesFut, MAX(GolsTimeCasa) AS Mais_Gols
        from Partida
        group by NomeCasa
    ) AS MaisGols
    group by TimesFut 
END;