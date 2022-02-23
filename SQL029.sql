/*
 * PLT035 - Consulta para geração Relatório de Lançamento de Notas em Provas
 * Script para relatório de Provas do Colégio
 *
 * @author  Marcelo Valvassori Bittencourt
 * @mail	webmaster@pallottism.com.br
 * @version 1.0 bitts 10/05/2017
 * 
*/

SELECT 
	A.IDTURMADISC, A.IDPERLET, A.NUMDIARIO, A.RA, 
	B.CODFILIAL, B.CODTURMA, 
	C.IDTURMADISC, C.CODDISC, 
	F.NOME, 
	N.[PROVA 1], N.[PROVA 2], N.[PROVA 3], N.[PROVA 4], N.[PROVA 5]
FROM 
	SMATRICULA AS A (NOLOCK)
	INNER JOIN STURMA AS B (NOLOCK) ON
		B.CODCOLIGADA = A.CODCOLIGADA
		AND B.IDPERLET = A.IDPERLET
		AND B.IDHABILITACAOFILIAL = A.IDHABILITACAOFILIAL
	INNER JOIN STURMADISC AS C (NOLOCK) ON
		C.CODCOLIGADA = A.CODCOLIGADA
		AND C.CODFILIAL = B.CODFILIAL
		AND C.IDHABILITACAOFILIAL = A.IDHABILITACAOFILIAL
		AND C.IDPERLET = A.IDPERLET		
		AND C.CODTURMA = B.CODTURMA  
		AND A.IDTURMADISC = C.IDTURMADISC
	INNER JOIN SMATRICPL AS D (NOLOCK) ON
		D.CODCOLIGADA = A.CODCOLIGADA
		AND D.CODFILIAL = B.CODFILIAL
		AND D.CODTURMA = B.CODTURMA
		AND D.IDHABILITACAOFILIAL = A.IDHABILITACAOFILIAL
		AND D.IDPERLET = A.IDPERLET 
		AND D.RA = A.RA 
		AND D.IDPERLET = A.IDPERLET
	INNER JOIN SALUNO AS E (NOLOCK) ON
		E.CODCOLIGADA = A.CODCOLIGADA
		AND E.RA = A.RA
	INNER JOIN PPESSOA AS F (NOLOCK) ON
		F.CODIGO = E.CODPESSOA
	
	LEFT JOIN (
		SELECT 
			A.CODCOLIGADA, A.IDTURMADISC, A.CODETAPA, A.TIPOETAPA, B.RA
			, [PROVA 1] = MAX(CASE WHEN A.CODPROVA = 1 THEN B.NOTA END)
			, [PROVA 2] = MAX(CASE WHEN A.CODPROVA = 2 THEN B.NOTA END)
			, [PROVA 3] = MAX(CASE WHEN A.CODPROVA = 3 THEN B.NOTA END)
			, [PROVA 4] = MAX(CASE WHEN A.CODPROVA = 4 THEN B.NOTA END)
			, [PROVA 5] = MAX(CASE WHEN A.CODPROVA = 5 THEN B.NOTA END)
		FROM 
			SPROVAS AS A (NOLOCK)
				LEFT JOIN SNOTAS AS B (NOLOCK) ON
					A.CODCOLIGADA = B.CODCOLIGADA
					AND A.CODETAPA = B.CODETAPA
					AND A.CODPROVA = B.CODPROVA
					AND A.IDTURMADISC = B.IDTURMADISC
		GROUP BY 
			A.CODCOLIGADA, A.IDTURMADISC, A.CODETAPA, A.TIPOETAPA, B.RA
	) N (CODCOLIGADA, IDTURMADISC, CODETAPA, TIPOETAPA, RA, [PROVA 1], [PROVA 2], [PROVA 3], [PROVA 4], [PROVA 5]) ON
		N.CODCOLIGADA = A.CODCOLIGADA
		AND N.IDTURMADISC = A.IDTURMADISC
		AND N.RA = A.RA
	
WHERE 
	B.CODFILIAL = 3
	AND A.IDPERLET = 57
	AND B.CODTURMA = 'EF82'
	AND C.CODDISC = '3MAT001'
	AND N.CODETAPA = 1

ORDER BY  
	A.NUMDIARIO