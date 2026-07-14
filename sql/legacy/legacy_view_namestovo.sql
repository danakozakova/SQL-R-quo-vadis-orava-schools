IF OBJECT_ID('Study_Migration_District_Namestovo', 'V') IS NOT NULL
    DROP VIEW Study_Migration_District_Namestovo;
GO

create view Study_Migration_District_Namestovo as
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
	and obec.IdObec = 35 /* 1 Dolny Kubin, 60 Tvrdosin */
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
where okres.IdObec = 35 /* 1 Dolny Kubin, 60 Tvrdosin */
	and pv.FkIdVekKat = 2 /* vekova kategoria stedoskolakov */
group by csr.SkolskyRok, okres.ObecNazov
)
select TabStudentov.SkolskyRok
	, CAST(TabStudentov.PocetStudentov - TabMladych.PocetMladych AS DECIMAL(10, 2)) / CAST(TabMladych.PocetMladych AS DECIMAL(10, 2)) 
	as UbytokPrirastokStudentov
from TabStudentov
join TabMladych on TabStudentov.SkolskyRok = TabMladych.SkolskyRok