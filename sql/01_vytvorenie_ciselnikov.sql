-- Vytvorenie tabuľky cisTypZriad
CREATE TABLE cisTypZriad (
    IdTypZriad INT PRIMARY KEY,
    TypZriadDesc VARCHAR(10));

-- Vloženie dát do tabuľky cisTypZriad
INSERT INTO cisTypZriad (IdTypZriad, TypZriadDesc)
VALUES
    (1, 'štátny'),
    (2, 'cirkevný'),
    (3, 'súkromný');

-------------------------------------------------------
-- Vytvorenie tabuľky cisTypSkoly
CREATE TABLE cisTypSkoly (
    IdTypSkoly INT PRIMARY KEY,
    TypSkolyDesc VARCHAR(255),
    TypSkolyDescLong VARCHAR(255)
);

-- Vloženie dát do tabuľky cisTypSkoly
INSERT INTO cisTypSkoly (IdTypSkoly, TypSkolyDesc, TypSkolyDescLong)
VALUES
    (1, 'ZŠ', 'základná škola'),
    (2, 'SŠ', 'stredná škola'),
    (3, 'ŠŠ', 'špeciálna / združená škola');

-------------------------------------------------------
-- Vytvorenie tabuľky cisPodtypSkoly
CREATE TABLE cisPodtypSkoly (
    IdPodtypSkoly INT PRIMARY KEY,
    TypSkolyDesc VARCHAR(255),
    TypSkolyDescLong VARCHAR(255),
    FkIdTypSkoly INT,
    FOREIGN KEY (FkIdTypSkoly) REFERENCES cisTypSkoly(IdTypSkoly)
);

-- Vloženie dát do tabuľky cisPodtypSkoly
INSERT INTO cisPodtypSkoly (IdPodtypSkoly, TypSkolyDesc, TypSkolyDescLong, FkIdTypSkoly)
VALUES
    (11, 'ZŠ 1-4', 'základná škola (1. - 5. ročník)', 1),
    (12, 'ZŠ 1-9', 'základná škola (1. - 9. ročník)', 1),
    (13, 'ZŠ s MŠ 1-4', 'základná škola s materskou školou (1. - 5. ročník)', 1),
    (14, 'ZŠ s MŠ 1-9', 'základná škola s materskou školou (1. - 9. ročník)', 1),
    (21, 'gymnázium', 'gymnázium', 2),
    (22, 'SOŠ', 'stredná odborná škola', 2),
    (23, 'SOU', 'stredné odborné učilište', 2),
    (31, 'ZŠŠ', 'špeciálna základná škola', 3),
    (32, 'ŠSOU', 'špeciálne odborné učilište', 3),
    (33, 'ŠSOŠ', 'špeciálna stredná odborná škola', 3);
-------------------------------------------------------
-- Vytvorenie tabuľky cisVekKat
CREATE TABLE cisVekKat (
    IdVekKat INT PRIMARY KEY,
    VekKatDesc VARCHAR(255),
    VekKatDescLong VARCHAR(255)
);

-- Vloženie dát do tabuľky cisVekKat
INSERT INTO cisVekKat (IdVekKat, VekKatDesc, VekKatDescLong)
VALUES
    (1, '6 - 14', 'od 6 do 14 rokov'),
    (2, '15 - 19', 'od 15 do 19 rokov');

-------------------------------------------------------
-- Vytvorenie tabuľky cisObceOkresy
CREATE TABLE cisObceOkresy (
    IdObec INT PRIMARY KEY,
    ObecNazov VARCHAR(255),
    FkIdOkres INT, -- Predpokladám, že IdOkres je INT
	FOREIGN KEY (FkIdOkres) REFERENCES cisObceOkresy(IdObec)
);

-- Vloženie dát do tabuľky cisObceOkresy
INSERT INTO cisObceOkresy (IdObec, ObecNazov, FkIdOkres)
VALUES
    (1, 'Dolný Kubín', 1),
    (2, 'Dlhá nad Oravou', 1),
    (3, 'Horná Lehota', 1),
    (4, 'Chlebnice', 1),
    (5, 'Istebné', 1),
    (6, 'Jasenová', 1),
    (7, 'Kraľovany', 1),
    (8, 'Krivá', 1),
    (9, 'Leštiny', 1),
    (10, 'Malatiná', 1),
    (11, 'Medzibrodie nad Oravou', 1),
    (12, 'Oravská Poruba', 1),
    (13, 'Oravský Podzámok', 1),
    (14, 'Osádka', 1),
    (15, 'Párnica', 1),
    (16, 'Pokryváč', 1),
    (17, 'Pribiš', 1),
    (18, 'Pucov', 1),
    (19, 'Sedliacka Dubová', 1),
    (20, 'Veličná', 1),
    (21, 'Vyšný Kubín', 1),
    (22, 'Zázrivá', 1),
    (23, 'Žaškov', 1),
    (24, 'Bziny', 1),
    (25, 'Babín', 35),
    (26, 'Beňadovo', 35),
    (27, 'Bobrov', 35),
    (28, 'Breza', 35),
    (29, 'Hruštín', 35),
    (30, 'Klin', 35),
    (31, 'Krušetnica', 35),
    (32, 'Lokca', 35),
    (33, 'Lomná', 35),
    (34, 'Mútne', 35),
    (35, 'Námestovo', 35),
    (36, 'Novoť', 35),
    (37, 'Oravská Jasenica', 35),
    (38, 'Oravská Lesná', 35),
    (39, 'Oravská Polhora', 35),
    (40, 'Oravské Veselé', 35),
    (41, 'Rabča', 35),
    (42, 'Rabčice', 35),
    (43, 'Sihelné', 35),
    (44, 'Ťapešovo', 35),
    (45, 'Vasiľov', 35),
    (46, 'Vavrečka', 35),
    (47, 'Zákamenné', 35),
    (48, 'Zubrohlava', 35),
    (49, 'Brezovica', 60),
    (50, 'Čimhová', 60),
    (51, 'Habovka', 60),
    (52, 'Hladovka', 60),
    (53, 'Liesek', 60),
    (54, 'Nižná', 60),
    (55, 'Oravský Biely Potok', 60),
    (56, 'Podbiel', 60),
    (57, 'Suchá Hora', 60),
    (58, 'Štefanov nad Oravou', 60),
    (59, 'Trstená', 60),
    (60, 'Tvrdošín', 60),
    (61, 'Vitanová', 60),
    (62, 'Zábiedovo', 60),
    (63, 'Zuberec', 60);

-------------------------------------------------------
-- Vytvorenie tabuľky cisSkRok
CREATE TABLE cisSkRok (
    IdSkRok INT PRIMARY KEY,
    SkolskyRok VARCHAR(8)
);

-- Vloženie dát do tabuľky cisSkRok
INSERT INTO cisSkRok (IdSkRok, SkolskyRok)
VALUES
    (1, '1996-97'),
    (2, '1997-98'),
    (3, '1998-99'),
    (4, '1999-00'),
    (5, '2000-01'),
    (6, '2001-02'),
    (7, '2002-03'),
    (8, '2003-04'),
    (9, '2004-05'),
    (10, '2005-06'),
    (11, '2006-07'),
    (12, '2007-08'),
    (13, '2008-09'),
    (14, '2009-10'),
    (15, '2010-11'),
    (16, '2011-12'),
    (17, '2012-13'),
    (18, '2013-14'),
    (19, '2014-15'),
    (20, '2015-16'),
    (21, '2016-17'),
    (22, '2017-18'),
    (23, '2018-19'),
    (24, '2019-20'),
    (25, '2020-21'),
    (26, '2021-22'),
    (27, '2022-23'),
    (28, '2023-24');
-------------------------------------------------------
