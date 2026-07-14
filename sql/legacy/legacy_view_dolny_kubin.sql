use DAKO_ORAVA
IF OBJECT_ID('dako_Study_Migration_District_DolnyKubin', 'V') IS NOT NULL
    DROP VIEW dako_Study_Migration_District_DolnyKubin;
GO

create view dako_Study_Migration_District_DolnyKubin as
with TabStudentov as (
select cts.TypSkolyDesc
	, okres.ObecNazov as Okres
	, csr.SkolskyRok
	, sum(pvs.PocetSkol) as PocetSkol
	, sum(pvs.PocetZiakov) as PocetStudentov
from cisTypSkoly cts
join cisPodtypSkoly cps on cts.IdTypSkoly = cps.FkIdTypSkoly
left join poctyVSkolach pvs on cps.IdPodtypSkoly = pvs.FkIdPodtypSkoly
left join cisObceOkresy obec on pvs.FkIdObec = obec.IdObec
left join cisObceOkresy okres on obec.FkIdOkres = okres.IdObec
left join cisSkRok csr on pvs.FkIdSkRok = csr.IdSkRok
where cts.IdTypSkoly = 2 /*2 su stredne skoly */
	and obec.IdObec = 1 /* 35 Namestovo, 60 Tvrdosin */
group by csr.SkolskyRok, cts.TypSkolyDesc, okres.ObecNazov
),
TabMladych as (
select okres.ObecNazov as Okres
	, csr.SkolskyRok
	, sum(pv.PocetOsob) as PocetMladych
from poctyVek pv
left join cisObceOkresy obec on pv.FkIdObec = obec.IdObec
left join cisObceOkresy okres on obec.FkIdOkres = okres.IdObec
left join cisSkRok csr on pv.FkIdSkRok = csr.IdSkRok
where okres.IdObec = 1 /* 35 Namestovo, 60 Tvrdosin */
	and pv.FkIdVekKat = 2 /* vekova kategoria stedoskolakov */
group by csr.SkolskyRok, okres.ObecNazov
)
select TabStudentov.SkolskyRok
	, CAST(TabStudentov.PocetStudentov - TabMladych.PocetMladych AS DECIMAL(10, 2)) / CAST(TabMladych.PocetMladych AS DECIMAL(10, 2)) 
	as UbytokPrirastokStudentov
from TabStudentov
join TabMladych on TabStudentov.SkolskyRok = TabMladych.SkolskyRok

GO
