USE sports_db;

CREATE TABLE competition (
                             id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- INT UNSIGNED - ainult positiivsed täisarvud, AUTO_INCREMENT - automaatne väärtuse suurendamine iga uue rea lisamisel
                             name VARCHAR(255) NOT NULL UNIQUE, -- VARCHAR(255) - kuni 255 märki, NOT NULL - ei saa olla tühi, UNIQUE - unikaalne nimi
                             event_date DATE NOT NULL, -- DATE - ainult kuupäev, NOT NULL - peab olema määratud
                             location VARCHAR(200) NOT NULL, -- VARCHAR(200) - kuni 200 märki, asukoha jaoks piisav ja säästab mälu võrreldes TEXTiga
                             description TEXT, -- TEXT - suurem tekst kui VARCHAR, kuid võtab rohkem mälu
                             registration_deadline DATETIME, -- DATETIME - kuupäev ja kellaaeg, täpne registreerimise lõpp
                             max_participants INT, -- INT - täisarv, piisavalt suur, et mahutada kõik soovijad
                             status ENUM('upcoming', 'active', 'completed', 'cancelled') DEFAULT 'upcoming' -- ENUM - piiratud valikuga väärtused, DEFAULT - vaikimisi väärtus
);

CREATE TABLE category (
                          id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- INT UNSIGNED - positiivsed täisarvud, AUTO_INCREMENT - järjestikune genereerimine
                          competition_id INT UNSIGNED NOT NULL, -- INT UNSIGNED - sama tüüp mis viidatavas competition.id väljas
                          name VARCHAR(50) NOT NULL, -- VARCHAR(50) - kategooria nimeks piisav pikkus
                          min_age TINYINT, -- TINYINT - vahemik 0-255, piisav vanuse jaoks, säästab mälu
                          max_age TINYINT, -- TINYINT - sama mis min_age
                          gender ENUM('M', 'F'), -- ENUM - ainult 2 võimalikku väärtust, efektiivne mälu kasutus
                          description VARCHAR(255), -- VARCHAR(255) - piisav kategooria lisainfo jaoks
                          FOREIGN KEY (competition_id) REFERENCES competition(id) ON DELETE CASCADE -- Võistluse kustutamisel kustutatakse ka seotud kategooriad
);

CREATE TABLE participant (
                             id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- INT UNSIGNED - positiivsed täisarvud, AUTO_INCREMENT - järjestikune ID
                             first_name VARCHAR(50) NOT NULL, -- VARCHAR(50) - eesnimeks piisav pikkus
                             last_name VARCHAR(50) NOT NULL, -- VARCHAR(50) - perekonnanimeks piisav pikkus
                             birth_date DATE NOT NULL, -- DATE - sünnikuupäev ilma kellaajata
                             gender ENUM('M', 'F') NOT NULL, -- ENUM - ainult 2 võimalikku väärtust
                             email VARCHAR(100) UNIQUE NOT NULL, -- VARCHAR(100) - email harva pikem kui 100 märki, UNIQUE - väldib duplikaate
                             phone VARCHAR(20), -- VARCHAR(20) - piisav rahvusvaheliste telefoninumbrite jaoks
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- TIMESTAMP - automaatne loomise aeg, vähem mälu kui DATETIME
);

CREATE TABLE registration (
                              id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- INT UNSIGNED - positiivsed täisarvud, AUTO_INCREMENT - järjestikune ID
                              competition_id INT UNSIGNED, -- INT UNSIGNED - viide competition tabelisse
                              category_id INT UNSIGNED, -- INT UNSIGNED - viide category tabelisse
                              participant_id INT UNSIGNED, -- INT UNSIGNED - viide participant tabelisse
                              registration_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- TIMESTAMP - registreerimise aeg automaatselt
                              status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending', -- ENUM - piiratud staatused, DEFAULT - vaikimisi olek
                              bib_number VARCHAR(10) NOT NULL, -- VARCHAR(10) - võistleja number võib sisaldada tähti ja numbreid
                              notes TEXT, -- TEXT - piiramatu pikkusega märkmed
                              FOREIGN KEY (competition_id) REFERENCES competition(id) ON DELETE CASCADE, -- Võistluse kustutamisel kustutatakse registreerimised
                              FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE, -- Kategooria kustutamisel kustutatakse registreerimised
                              FOREIGN KEY (participant_id) REFERENCES participant(id) ON DELETE CASCADE, -- Osaleja kustutamisel kustutatakse registreerimised
                              UNIQUE KEY unique_registration (competition_id, participant_id) -- Väldib topeltregistreerimisi samal võistlusel
);

CREATE TABLE results (
                         id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- INT UNSIGNED - positiivsed täisarvud, AUTO_INCREMENT - järjestikune ID
                         registration_id INT UNSIGNED, -- INT UNSIGNED - viide registration tabelisse
                         finish_time TIME, -- TIME - sobiv formaat lõpuaja salvestamiseks
                         position INT, -- INT - koht võistlusel, piisav ka suurte võistluste jaoks
                         status ENUM('finished', 'DNF', 'DSQ') DEFAULT 'finished', -- ENUM - piiratud tulemuste staatused
                         additional_data JSON, -- JSON - paindlik formaat lisaandmete jaoks (nt vaheajad, punktid)
                         FOREIGN KEY (registration_id) REFERENCES registration(id), -- Registreerimise kustutamisel säilitatakse tulemused
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- TIMESTAMP - tulemuse lisamise aeg
);