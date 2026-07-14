# Quo vadis, školstvo na Orave? 🏫

> 🇬🇧 *A self-initiated, end-to-end database project: I designed and built a SQL Server database of schools in the Orava region (Slovakia) — schema design with lookup tables and a self-referencing municipality→district hierarchy, ETL from public statistical sources, a SQL layer (views, table-valued functions), and an R analysis connected via ODBC. Topics include "study migration" (do district-town secondary schools absorb the district's youth?), class-size dynamics, and the budget-vs-rating relationship. Write-up in Slovak.*

Vlastný projekt od nuly: návrh a naplnenie databázy o školách na Orave, SQL vrstva a analýza v R. Tému som si zvolila sama — ako učiteľka a rodáčka z regiónu ma zaujímalo, čo sa dá z verejných dát vyčítať o vývoji oravského školstva: demografia, veľkosti tried, "školská migrácia" a vzťah rozpočtu a kvality škôl.

Vzniklo v predmete Databázové systémy a R v datovej vede (Masarykova univerzita); zadanie bolo voľné — voľba témy, nájdenie a prepojenie dát, návrh schémy aj analýzy sú moja samostatná práca.

## Architektúra

**Databáza (SQL Server):** 10 tabuliek v dvoch vrstvách — číselníky (typy a podtypy škôl, zriaďovatelia, vekové kategórie, obce/okresy, školské roky) a dátové tabuľky (register škôl so súradnicami, počty žiakov/tried/učiteľov, demografia obcí, hodnotenia INEKO). Obce a okresy rieši jedna tabuľka so **samoreferenčnou väzbou** (obec → okres). Kompletný dátový slovník s ER diagramom je v [dokumentácii](docs/database_documentation.pdf).

**SQL vrstva:** table-valued funkcie pre opakované analytické otázky — `ScoreBudgetForYearType` (skóre a rozpočet škôl daného typu a roka) a `StudyMigrationForDistrict` (školská migrácia pre okres).

**Analýza (R):** RMarkdown pripojený cez ODBC priamo na databázu — migrácia stredoškolákov po okresoch, vývoj počtu detí a škôl, variabilita veľkosti tried, porovnanie demografie okresov a vzťah rozpočtu a hodnotenia škôl.

## Školská migrácia — logika ukazovateľa

Základné školy majú spádovosť na úrovni obce, stredné školy na úrovni okresu — stredoškolákov nemá zmysel riešiť v každej obci. Ukazovateľ preto porovnáva **počet študentov stredných škôl v okresnom meste** s **počtom mladých (15–19) v celom okrese**: kladná hodnota znamená, že školy okresného mesta priťahujú aj študentov spoza okresu, záporná odlev študentov inam.

## Poznámka k refaktoringu

Pôvodné odovzdanie malo pre migráciu samostatný view per okres (copy-paste s jedným zmeneným ID — na refaktoring pred termínom nezostal čas). Publikovaná verzia ho nahrádza jednou parametrizovanou funkciou `StudyMigrationForDistrict(@idOkres)`; identifikátor okresu sa zhoduje s identifikátorom okresného mesta (1 = Dolný Kubín, 35 = Námestovo, 60 = Tvrdošín). Pôvodné views sú pre porovnanie zachované v `sql/legacy/`.

Projekt bol pôvodne vyvíjaný na zdieľanom školskom SQL serveri s povinným študentským prefixom objektov (`dako_`); publikovaná verzia je bez prefixu, pre samostatnú databázu.

## Štruktúra repozitára

```
sql/          01–05 schéma + dáta (CREATE TABLE + INSERT), 06 funkcie
sql/legacy/   pôvodné views per okres (pred refaktoringom na funkciu)
analysis/     RMarkdown analýza + vygenerované HTML
docs/         dokumentácia databázy (PDF), prezentácia (PPTX)
```

## Postavenie databázy a spustenie

1. Vytvorte prázdnu databázu na SQL Serveri (napr. `ORAVA_SKOLSTVO`)
2. Spustite skripty `sql/01` až `sql/05` v poradí (schéma aj dáta v jednom)
3. Spustite `sql/06_create_functions.sql`
4. V `analysis/orava_analysis.Rmd` upravte connection string na váš server a Knit

```r
install.packages(c("odbc", "DBI", "tidyverse", "kableExtra"))
```

## Zdroje dát

- **Štatistický úrad SR** — DataCube: vekové skupiny obcí [om7006rr]; štatistika školstva — základné školy [sv5002rr], gymnáziá [sv5003rr], SOŠ/SOU/ZSŠ [sv5004rr]
- **INEKO** — rebríčky hodnotenia škôl: https://skoly.ineko.sk/rebricky/
- Webové stránky škôl (súradnice, kontakty)

## Návrh a prezentácia

- [návrh databázy](docs/database_documentation.pdf)

- [prezentácia výsledkov](docs/presentation.pdf)
