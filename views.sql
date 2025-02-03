-- View: Osalejate arv võistluste kaupa
CREATE OR REPLACE VIEW competition_participants AS
SELECT
    c.id AS competition_id,
    c.name AS competition_name,
    COUNT(r.id) AS participant_count
FROM competition c
         LEFT JOIN category cat ON c.id = cat.competition_id
         LEFT JOIN registration r ON cat.id = r.category_id
GROUP BY c.id, c.name;

-- View: Keskmine osalejate vanus võistlustel
CREATE OR REPLACE VIEW competition_avg_age AS
SELECT
    c.id AS competition_id,
    c.name AS competition_name,
    AVG(YEAR(CURDATE()) - YEAR(p.birth_date)) AS avg_age
FROM competition c
         JOIN category cat ON c.id = cat.competition_id
         JOIN registration r ON cat.id = r.category_id
         JOIN participant p ON r.participant_id = p.id
GROUP BY c.id, c.name;

