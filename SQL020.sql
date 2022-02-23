/*
	PLT39 - Script para relatório
	Create By Bitts 
	(20/10/2016)
	
	Melhoramento do mapa de notas apresentação de todos os trimestres
	Exibição por disciplina e turma
*/

DECLARE @CODTURMA1_S VARCHAR(10) = 'EM201';-- :CODTURMA;

DECLARE @CODSTATUS_M INT = 50;
DECLARE @STATUS_M VARCHAR(20) = 'Matriculado';
DECLARE @SPERLETIVO_M VARCHAR(10) = '2016'; -- :PLETIVO;
DECLARE @CODCOLIGADA_N INT = 3;
DECLARE @CODFILIAL_N INT = 6;
DECLARE @DISCIPLINA VARCHAR(10) = 'Matematica';

WITH MAPA_FALTAS AS (
	SELECT 
		SMATRICPL.NUMALUNO, 
		SALUNO.RA,
		PPESSOA.NOME,
		SMATRICPL.CODSTATUS,
		SSTATUS.DESCRICAO,
		ETAPA.CODCOLIGADA,
		ETAPA.CODFILIAL,
		ETAPA.IDPERLET,
		ETAPA.SPERLETIVO,
		ETAPA.CODTURMA,
		ETAPA.CODDISC,
		ETAPA.NOMEDISCIPLINA,
		ETAPA.CODETAPA,
		ETAPA.DESCRICAO AS DESCRICAOETAPA,
		ETAPA.TIPOETAPA,
		ETAPA.NOTAFALTA,
		SHABILITACAO.NOME AS NOME_SERIE
	FROM
		PPESSOA (NOLOCK)
			LEFT JOIN SALUNO (NOLOCK) ON 
				SALUNO.CODPESSOA = PPESSOA.CODIGO
			LEFT JOIN SMATRICPL (NOLOCK) ON
				SMATRICPL.CODCOLIGADA = SALUNO.CODCOLIGADA 
				AND SMATRICPL.RA = SALUNO.RA
			LEFT JOIN SSTATUS (NOLOCK) ON 
				SMATRICPL.CODCOLIGADA = SSTATUS.CODCOLIGADA 
				AND SMATRICPL.CODSTATUS = SSTATUS.CODSTATUS 
			INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
				SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
			INNER JOIN SHABILITACAO (NOLOCK) ON
				SHABILITACAOFILIAL.CODCURSO = SHABILITACAO.CODCURSO
				AND SHABILITACAOFILIAL.CODHABILITACAO = SHABILITACAO.CODHABILITACAO
			LEFT JOIN (
				SELECT 
					STURMADISC.CODCOLIGADA, 
					STURMADISC.IDTURMADISC,
					STURMADISC.CODFILIAL,
					STURMADISC.CODTURMA,
					STURMADISC.IDPERLET,
					SPLETIVO.DESCRICAO AS SPERLETIVO,
					STURMADISC.IDHABILITACAOFILIAL,
					SDISCIPLINA.CODDISC,
					SDISCIPLINA.NOME AS NOMEDISCIPLINA,
					SETAPAS.CODETAPA,
					SETAPAS.DESCRICAO,
					SNOTAETAPA.TIPOETAPA,
					SNOTAETAPA.NOTAFALTA,
					SNOTAETAPA.AULASDADAS,
					SNOTAETAPA.RA
				FROM 
					STURMADISC (NOLOCK)
						LEFT JOIN SDISCIPLINA (NOLOCK) ON 
							SDISCIPLINA.CODDISC = STURMADISC.CODDISC AND
							SDISCIPLINA.CODCOLIGADA = STURMADISC.CODCOLIGADA AND 
							SDISCIPLINA.CODTIPOCURSO = STURMADISC.CODTIPOCURSO
						LEFT JOIN SETAPAS (NOLOCK) ON 
							SETAPAS.IDTURMADISC = STURMADISC.IDTURMADISC AND
							SETAPAS.CODCOLIGADA = STURMADISC.CODCOLIGADA
						LEFT JOIN SNOTAETAPA (NOLOCK) ON 
							SNOTAETAPA.IDTURMADISC = SETAPAS.IDTURMADISC AND 
							SNOTAETAPA.CODETAPA = SETAPAS.CODETAPA AND 
							SNOTAETAPA.TIPOETAPA = SETAPAS.TIPOETAPA 
						LEFT JOIN SPLETIVO (NOLOCK) ON
							SPLETIVO.CODCOLIGADA = STURMADISC.CODCOLIGADA AND
							SPLETIVO.IDPERLET = STURMADISC.IDPERLET
			)
			ETAPA (
				CODCOLIGADA, 
				IDTURMADISC,
				CODFILIAL,
				CODTURMA,
				IDPERLET,
				SPERLETIVO,
				IDHABILITACAOFILIAL,
				CODDISC,
				NOMEDISCIPLINA,
				CODETAPA,
				DESCRICAO,
				TIPOETAPA,
				NOTAFALTA,
				AULASDADAS,
				RA
			) ON 
		ETAPA.CODTURMA = SMATRICPL.CODTURMA
		AND ETAPA.RA = SMATRICPL.RA
		AND ETAPA.IDPERLET = SMATRICPL.IDPERLET 
		AND ETAPA.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND ETAPA.CODFILIAL = SMATRICPL.CODFILIAL
		AND ETAPA.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
)


SELECT DISTINCT
	NUMALUNO,
	RA, 
	NOME, 
	CODSTATUS, 
	DESCRICAO, 
	CODFILIAL, 
	CODCOLIGADA, 
	IDPERLET, 
	SPERLETIVO,
	NOME_SERIE, 
	CODTURMA , 
	
	[1TRI].NOTA1 AS [1º TRI NOTA],
	[1TRIF].FALTAS1 AS [1º TRI FALTA],
	[2TRI].NOTA2 AS [2º TRI NOTA],
	[2TRIF].FALTAS2 AS [2º TRI FALTA],
	[3TRI].NOTA3 AS [3º TRI NOTA],
	[3TRIF].FALTAS3 AS [3º TRI FALTA]
FROM  
	MAPA_FALTAS
	LEFT JOIN (
		SELECT NOTAFALTA AS NOTA1, CODETAPA AS CE1, NUMALUNO AS NA1, CODSTATUS AS CS1, CODFILIAL AS CF1, CODCOLIGADA AS CC1, IDPERLET AS IP1, SPERLETIVO AS SP1, CODTURMA AS CT1, CODDISC AS CD1
		FROM MAPA_FALTAS	
	) [1TRI] (NOTA1, CE1, NA1, CS1, CF1, CC1, IP1, SP1, CT1, CD1) ON
		[1TRI].CE1 = '1' AND 
		[1TRI].NA1 = NUMALUNO AND
		[1TRI].CS1 = CODSTATUS AND
		[1TRI].CF1 = CODFILIAL AND
		[1TRI].CC1 = CODCOLIGADA AND
		[1TRI].IP1 = IDPERLET AND
		[1TRI].SP1 = SPERLETIVO AND
		[1TRI].CT1 = CODTURMA AND
		[1TRI].CD1 = CODDISC
	LEFT JOIN (
		SELECT NOTAFALTA AS FALTAS1, CODETAPA AS CE1F, NUMALUNO AS NA1F, CODSTATUS AS CS1F, CODFILIAL AS CF1F, CODCOLIGADA AS CC1F, IDPERLET AS IP1F, SPERLETIVO AS SP1F, CODTURMA AS CT1F, CODDISC AS CD1F
		FROM MAPA_FALTAS	
	) [1TRIF] (FALTAS1, CE1F, NA1F, CS1F, CF1F, CC1F, IP1F, SP1F, CT1F, CD1F) ON
		[1TRIF].CE1F = '2' AND 
		[1TRIF].NA1F = NUMALUNO AND
		[1TRIF].CS1F = CODSTATUS AND
		[1TRIF].CF1F = CODFILIAL AND
		[1TRIF].CC1F = CODCOLIGADA AND
		[1TRIF].IP1F = IDPERLET AND
		[1TRIF].SP1F = SPERLETIVO AND
		[1TRIF].CT1F = CODTURMA AND
		[1TRIF].CD1F = CODDISC
	LEFT JOIN (
		SELECT NOTAFALTA AS NOTA2, CODETAPA AS CE2, NUMALUNO AS NA2, CODSTATUS AS CS2, CODFILIAL AS CF2, CODCOLIGADA AS CC2, IDPERLET AS IP2, SPERLETIVO AS SP2, CODTURMA AS CT2, CODDISC AS CD2
		FROM MAPA_FALTAS	
	) [2TRI] (NOTA2, CE2, NA2, CS2, CF2, CC2, IP2, SP2, CT2, CD2) ON
		[2TRI].CE2 = '3' AND 
		[2TRI].NA2 = NUMALUNO AND
		[2TRI].CS2 = CODSTATUS AND
		[2TRI].CF2 = CODFILIAL AND
		[2TRI].CC2 = CODCOLIGADA AND
		[2TRI].IP2 = IDPERLET AND
		[2TRI].SP2 = SPERLETIVO AND
		[2TRI].CT2 = CODTURMA AND
		[2TRI].CD2 = CODDISC
	LEFT JOIN (
		SELECT NOTAFALTA AS FALTAS2, CODETAPA AS CE2F, NUMALUNO AS NA2F, CODSTATUS AS CS2F, CODFILIAL AS CF2F, CODCOLIGADA AS CC2F, IDPERLET AS IP2F, SPERLETIVO AS SP2F, CODTURMA AS CT2F, CODDISC AS CD2F
		FROM MAPA_FALTAS	
	) [2TRIF] (FALTAS2, CE2F, NA2F, CS2F, CF2F, CC2F, IP2F, SP2F, CT2F, CD2F) ON
		[2TRIF].CE2F = '4' AND 
		[2TRIF].NA2F = NUMALUNO AND
		[2TRIF].CS2F = CODSTATUS AND
		[2TRIF].CF2F = CODFILIAL AND
		[2TRIF].CC2F = CODCOLIGADA AND
		[2TRIF].IP2F = IDPERLET AND
		[2TRIF].SP2F = SPERLETIVO AND
		[2TRIF].CT2F = CODTURMA AND
		[2TRIF].CD2F = CODDISC
	LEFT JOIN (
		SELECT NOTAFALTA AS NOTA3, CODETAPA AS CE3, NUMALUNO AS NA3, CODSTATUS AS CS3, CODFILIAL AS CF3, CODCOLIGADA AS CC3, IDPERLET AS IP3, SPERLETIVO AS SP3, CODTURMA AS CT3, CODDISC AS CD3
		FROM MAPA_FALTAS	
	) [3TRI] (NOTA3, CE3, NA3, CS3, CF3, CC3, IP3, SP3, CT3, CD3) ON
		[3TRI].CE3 = '5' AND 
		[3TRI].NA3 = NUMALUNO AND
		[3TRI].CS3 = CODSTATUS AND
		[3TRI].CF3 = CODFILIAL AND
		[3TRI].CC3 = CODCOLIGADA AND
		[3TRI].IP3 = IDPERLET AND
		[3TRI].SP3 = SPERLETIVO AND
		[3TRI].CT3 = CODTURMA AND
		[3TRI].CD3 = CODDISC
	LEFT JOIN (
		SELECT NOTAFALTA AS FALTAS3, CODETAPA AS CE3F, NUMALUNO AS NA3F, CODSTATUS AS CS3F, CODFILIAL AS CF3F, CODCOLIGADA AS CC3F, IDPERLET AS IP3F, SPERLETIVO AS SP3F, CODTURMA AS CT3F, CODDISC AS CD3F
		FROM MAPA_FALTAS	
	) [3TRIF] (FALTAS3, CE3F, NA3F, CS3F, CF3F, CC3F, IP3F, SP3F, CT3F, CD3F) ON
		[3TRIF].CE3F = '6' AND 
		[3TRIF].NA3F = NUMALUNO AND
		[3TRIF].CS3F = CODSTATUS AND
		[3TRIF].CF3F = CODFILIAL AND
		[3TRIF].CC3F = CODCOLIGADA AND
		[3TRIF].IP3F = IDPERLET AND
		[3TRIF].SP3F = SPERLETIVO AND
		[3TRIF].CT3F = CODTURMA AND
		[3TRIF].CD3F = CODDISC
WHERE 
	CODSTATUS = @CODSTATUS_M AND
	DESCRICAO = @STATUS_M AND
	CODTURMA = @CODTURMA1_S AND
	SPERLETIVO = @SPERLETIVO_M AND 
	CODCOLIGADA = @CODCOLIGADA_N AND
	CODFILIAL = @CODFILIAL_N AND
	NOMEDISCIPLINA = @DISCIPLINA AND
	CODETAPA IN (1,3,5)
GROUP BY
	NUMALUNO,
	RA, 
	NOME, 
	CODSTATUS, 
	DESCRICAO, 
	CODFILIAL, 
	CODCOLIGADA, 
	IDPERLET, 
	SPERLETIVO,
	NOME_SERIE, 
	CODTURMA, 
	CODETAPA, 
	[1TRI].NOTA1, 
	[1TRIF].FALTAS1, 
	[2TRI].NOTA2, 
	[2TRIF].FALTAS2, 
	[3TRI].NOTA3,
	[3TRIF].FALTAS3

ORDER BY
	NUMALUNO;
