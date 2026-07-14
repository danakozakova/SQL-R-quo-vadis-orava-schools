-- =============================================================
-- Quo vadis, školstvo na Orave?
-- 06 — Funkcie
-- Autorka: Dana Kozáková
-- =============================================================

-- -------------------------------------------------------------
-- Skóre a rozpočet škôl daného podtypu v danom školskom roku
-- Príklad volania: SELECT * FROM dbo.ScoreBudgetForYearType(12, 28)
--   (12 = ZŠ 1-9, 28 = školský rok 2023-24)
-- -------------------------------------------------------------
DROP FUNCTION IF EXISTS dbo.ScoreBudgetForYearType;
GO

CREATE FUNCTION dbo.ScoreBudgetForYearType
    (@podtyp_skoly INT, @idRok INT)
RETURNS TABLE AS
RETURN
(
    SELECT cps.TypSkolyDesc
         , csr.SkolskyRok
         , s.Nazov_short
         , h.Skore
         , h.Rozpocet
    FROM cisPodtypSkoly cps
    JOIN skoly s        ON s.FkIdPodtypSkoly = cps.IdPodtypSkoly
    JOIN hodnotenie h   ON h.FkIdSkola = s.IdSkola
    JOIN cisSkRok csr   ON csr.IdSkRok = h.FkIdSkRok
    WHERE cps.IdPodtypSkoly = @podtyp_skoly
      AND csr.IdSkRok = @idRok
      AND h.Skore    IS NOT NULL
      AND h.Rozpocet IS NOT NULL
);
GO

-- -------------------------------------------------------------
-- Školská migrácia pre okres — parametrizovaná náhrada
-- pôvodných views per okres (Dolný Kubín, Námestovo, Tvrdošín).
--
-- Porovnáva počet študentov stredných škôl v okresnom meste
-- s počtom mladých (15–19) v celom okrese. Kladná hodnota
-- znamená, že školy okresného mesta "priťahujú" viac študentov,
-- než je mladých v okrese (prílev), záporná odlev.
--
-- Identifikátor okresu = identifikátor okresného mesta:
--   1 = Dolný Kubín, 35 = Námestovo, 60 = Tvrdošín
-- Príklad volania: SELECT * FROM dbo.StudyMigrationForDistrict(35)
-- -------------------------------------------------------------
DROP FUNCTION IF EXISTS dbo.StudyMigrationForDistrict;
GO

CREATE FUNCTION dbo.StudyMigrationForDistrict
    (@idOkres INT)
RETURNS TABLE AS
RETURN
(
    WITH TabStudentov AS (
        SELECT csr.SkolskyRok
             , SUM(pvs.PocetZiakov) AS PocetStudentov
        FROM cisTypSkoly cts
        JOIN cisPodtypSkoly cps   ON cts.IdTypSkoly = cps.FkIdTypSkoly
        LEFT JOIN poctyVSkolach pvs ON cps.IdPodtypSkoly = pvs.FkIdPodtypSkoly
        LEFT JOIN cisObceOkresy obec  ON pvs.FkIdObec = obec.IdObec
        LEFT JOIN cisSkRok csr    ON pvs.FkIdSkRok = csr.IdSkRok
        WHERE cts.IdTypSkoly = 2          -- stredné školy
          AND obec.IdObec = @idOkres      -- školy v okresnom meste
        GROUP BY csr.SkolskyRok
    ),
    TabMladych AS (
        SELECT csr.SkolskyRok
             , SUM(pv.PocetOsob) AS PocetMladych
        FROM poctyVek pv
        LEFT JOIN cisObceOkresy obec  ON pv.FkIdObec = obec.IdObec
        LEFT JOIN cisObceOkresy okres ON obec.FkIdOkres = okres.IdObec
        LEFT JOIN cisSkRok csr    ON pv.FkIdSkRok = csr.IdSkRok
        WHERE okres.IdObec = @idOkres     -- mladí v celom okrese
          AND pv.FkIdVekKat = 2           -- veková kategória 15–19
        GROUP BY csr.SkolskyRok
    )
    SELECT s.SkolskyRok
         , CAST(s.PocetStudentov - m.PocetMladych AS DECIMAL(10, 2))
           / CAST(m.PocetMladych AS DECIMAL(10, 2)) AS UbytokPrirastokStudentov
    FROM TabStudentov s
    JOIN TabMladych m ON s.SkolskyRok = m.SkolskyRok
);
GO
