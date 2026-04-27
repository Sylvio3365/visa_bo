-- Test data for demandes pagination and status filtering.
-- Usage: execute after base schema + init scripts.
-- Safe rerun behavior: deterministic IDs are inserted only when missing.

BEGIN;

-- Ensure optional columns used by the Java model are present.
ALTER TABLE demande ADD COLUMN IF NOT EXISTS id_passport VARCHAR(50) REFERENCES passport(id_passport);
ALTER TABLE demande ADD COLUMN IF NOT EXISTS id_visa_transformable VARCHAR(50) REFERENCES visa_transformable(id_visa_transformable);

-- Ensure additional statuses exist so filters can be tested with many values.
INSERT INTO statut (id_statut, libelle)
SELECT 'ST00000' || nextval('seq_statut'), 'en attente paiement'
WHERE NOT EXISTS (
    SELECT 1 FROM statut WHERE lower(libelle) = lower('en attente paiement')
);

INSERT INTO statut (id_statut, libelle)
SELECT 'ST00000' || nextval('seq_statut'), 'dossier incomplet'
WHERE NOT EXISTS (
    SELECT 1 FROM statut WHERE lower(libelle) = lower('dossier incomplet')
);

INSERT INTO statut (id_statut, libelle)
SELECT 'ST00000' || nextval('seq_statut'), 'refuse'
WHERE NOT EXISTS (
    SELECT 1 FROM statut WHERE lower(libelle) = lower('refuse')
);

-- 72 demandes with coherent linked entities:
-- - 72 demandeur
-- - 72 passport
-- - 72 visa_transformable
-- - 72 demande
WITH refs AS (
    SELECT
        (SELECT id_nationalite FROM nationalite ORDER BY id_nationalite LIMIT 1) AS id_nationalite,
        (SELECT id_situation_famille FROM situation_famille ORDER BY id_situation_famille LIMIT 1) AS id_situation_famille,
        COALESCE(
            (SELECT id_categorie FROM categorie_demande WHERE lower(libelle) IN ('Nouvelle-demande', 'nouveau titre') ORDER BY id_categorie LIMIT 1),
            (SELECT id_categorie FROM categorie_demande ORDER BY id_categorie LIMIT 1)
        ) AS id_categorie,
        (SELECT id_type_visa FROM type_visa ORDER BY id_type_visa LIMIT 1) AS id_type_visa_1,
        (SELECT id_type_visa FROM type_visa ORDER BY id_type_visa OFFSET 1 LIMIT 1) AS id_type_visa_2
),
dataset AS (
    SELECT
        gs AS n,
        ('TDM2604' || lpad(gs::text, 4, '0')) AS suffix,
        ('DMT2604' || lpad(gs::text, 4, '0')) AS id_demandeur,
        ('PPT2604' || lpad(gs::text, 4, '0')) AS id_passport,
        ('VTT2604' || lpad(gs::text, 4, '0')) AS id_visa_transformable,
        ('DMD2604' || lpad(gs::text, 4, '0')) AS id_demande,
        ('PPNUM2604' || lpad(gs::text, 4, '0')) AS numero_passport,
        ('TVREF2604' || lpad(gs::text, 4, '0')) AS ref_visa,
        (CURRENT_DATE - ((gs % 60) || ' days')::interval)::date AS created_date
    FROM generate_series(1, 72) AS gs
)
INSERT INTO demandeur (
    id_demandeur,
    nom,
    prenom,
    nom_jeune_fille,
    dtn,
    adresse_mada,
    telephone,
    email,
    created_at,
    updated_at,
    id_nationalite,
    id_situation_famille
)
SELECT
    d.id_demandeur,
    'Nom' || d.suffix,
    'Prenom' || d.suffix,
    'NJF' || d.suffix,
    (DATE '1980-01-01' + (d.n * 120)),
    'Quartier ' || d.n || ', Antananarivo',
    '+2613200' || lpad(d.n::text, 4, '0'),
    lower('demandeur.' || d.n || '@test.local'),
    d.created_date,
    d.created_date,
    r.id_nationalite,
    r.id_situation_famille
FROM dataset d
CROSS JOIN refs r
WHERE r.id_nationalite IS NOT NULL
  AND r.id_situation_famille IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM demandeur dm WHERE dm.id_demandeur = d.id_demandeur
  );

WITH dataset AS (
    SELECT
        gs AS n,
        ('DMT2604' || lpad(gs::text, 4, '0')) AS id_demandeur,
        ('PPT2604' || lpad(gs::text, 4, '0')) AS id_passport,
        ('PPNUM2604' || lpad(gs::text, 4, '0')) AS numero_passport,
        (CURRENT_DATE - ((gs % 60) || ' days')::interval)::date AS created_date
    FROM generate_series(1, 72) AS gs
)
INSERT INTO passport (id_passport, numero, delivre_le, expire_le, id_demandeur)
SELECT
    d.id_passport,
    d.numero_passport,
    (d.created_date - INTERVAL '3 years')::date,
    (d.created_date + INTERVAL '7 years')::date,
    d.id_demandeur
FROM dataset d
WHERE NOT EXISTS (
    SELECT 1 FROM passport p WHERE p.id_passport = d.id_passport OR p.numero = d.numero_passport
);

WITH dataset AS (
    SELECT
        gs AS n,
        ('DMT2604' || lpad(gs::text, 4, '0')) AS id_demandeur,
        ('PPT2604' || lpad(gs::text, 4, '0')) AS id_passport,
        ('VTT2604' || lpad(gs::text, 4, '0')) AS id_visa_transformable,
        ('TVREF2604' || lpad(gs::text, 4, '0')) AS ref_visa,
        (CURRENT_DATE - ((gs % 60) || ' days')::interval)::date AS created_date
    FROM generate_series(1, 72) AS gs
)
INSERT INTO visa_transformable (
    id_visa_transformable,
    ref_visa,
    date_debut,
    date_fin,
    id_passport,
    id_demandeur
)
SELECT
    d.id_visa_transformable,
    d.ref_visa,
    (d.created_date - INTERVAL '180 days')::date,
    (d.created_date + INTERVAL '180 days')::date,
    d.id_passport,
    d.id_demandeur
FROM dataset d
WHERE EXISTS (SELECT 1 FROM passport p WHERE p.id_passport = d.id_passport)
  AND EXISTS (SELECT 1 FROM demandeur dm WHERE dm.id_demandeur = d.id_demandeur)
  AND NOT EXISTS (
      SELECT 1
      FROM visa_transformable vt
      WHERE vt.id_visa_transformable = d.id_visa_transformable OR vt.ref_visa = d.ref_visa
  );

WITH refs AS (
    SELECT
        COALESCE(
            (SELECT id_categorie FROM categorie_demande WHERE lower(libelle) IN ('Nouvelle-demande', 'nouveau titre') ORDER BY id_categorie LIMIT 1),
            (SELECT id_categorie FROM categorie_demande ORDER BY id_categorie LIMIT 1)
        ) AS id_categorie,
        (SELECT id_type_visa FROM type_visa ORDER BY id_type_visa LIMIT 1) AS id_type_visa_1,
        (SELECT id_type_visa FROM type_visa ORDER BY id_type_visa OFFSET 1 LIMIT 1) AS id_type_visa_2
),
dataset AS (
    SELECT
        gs AS n,
        ('DMD2604' || lpad(gs::text, 4, '0')) AS id_demande,
        ('DMT2604' || lpad(gs::text, 4, '0')) AS id_demandeur,
        ('PPT2604' || lpad(gs::text, 4, '0')) AS id_passport,
        ('VTT2604' || lpad(gs::text, 4, '0')) AS id_visa_transformable,
        (CURRENT_DATE - ((gs % 60) || ' days')::interval)::date AS created_date
    FROM generate_series(1, 72) AS gs
)
INSERT INTO demande (
    id_demande,
    created_at,
    updated_at,
    id_demande_1,
    id_categorie,
    id_type_visa,
    id_demandeur,
    id_passport,
    id_visa_transformable
)
SELECT
    d.id_demande,
    d.created_date,
    (d.created_date + INTERVAL '1 day')::date,
    NULL,
    r.id_categorie,
    CASE WHEN d.n % 2 = 0 THEN COALESCE(r.id_type_visa_2, r.id_type_visa_1) ELSE r.id_type_visa_1 END,
    d.id_demandeur,
    d.id_passport,
    d.id_visa_transformable
FROM dataset d
CROSS JOIN refs r
WHERE r.id_categorie IS NOT NULL
  AND r.id_type_visa_1 IS NOT NULL
  AND EXISTS (SELECT 1 FROM demandeur dm WHERE dm.id_demandeur = d.id_demandeur)
  AND EXISTS (SELECT 1 FROM passport p WHERE p.id_passport = d.id_passport)
  AND EXISTS (SELECT 1 FROM visa_transformable vt WHERE vt.id_visa_transformable = d.id_visa_transformable)
  AND NOT EXISTS (
      SELECT 1 FROM demande de WHERE de.id_demande = d.id_demande
  );

-- Create status history per demande (3 entries each) so "latest status" filtering can be validated.
-- Latest status distribution (based on demande index):
-- - visa approve
-- - en attente paiement
-- - refuse
-- plus intermediate statuses: dossier cree, scanne valider, dossier incomplet.
WITH status_ids AS (
    SELECT
        MAX(CASE WHEN lower(libelle) = lower('dossier cree') THEN id_statut END) AS st_dossier_cree,
        MAX(CASE WHEN lower(libelle) = lower('scanne valider') THEN id_statut END) AS st_scanne_valider,
        MAX(CASE WHEN lower(libelle) = lower('visa approve') THEN id_statut END) AS st_visa_approve,
        MAX(CASE WHEN lower(libelle) = lower('en attente paiement') THEN id_statut END) AS st_en_attente_paiement,
        MAX(CASE WHEN lower(libelle) = lower('dossier incomplet') THEN id_statut END) AS st_dossier_incomplet,
        MAX(CASE WHEN lower(libelle) = lower('refuse') THEN id_statut END) AS st_refuse
    FROM statut
),
dataset AS (
    SELECT
        gs AS n,
        ('DMD2604' || lpad(gs::text, 4, '0')) AS id_demande,
        (CURRENT_DATE - ((gs % 60) || ' days')::interval)::date AS created_date
    FROM generate_series(1, 72) AS gs
),
status_rows AS (
    SELECT
        ('SDT2604' || lpad(d.n::text, 4, '0') || '1') AS id_statut_demande,
        d.id_demande,
        s.st_dossier_cree AS id_statut,
        d.created_date AS date_
    FROM dataset d
    CROSS JOIN status_ids s

    UNION ALL

    SELECT
        ('SDT2604' || lpad(d.n::text, 4, '0') || '2') AS id_statut_demande,
        d.id_demande,
        CASE WHEN d.n % 5 = 0 THEN s.st_dossier_incomplet ELSE s.st_scanne_valider END AS id_statut,
        (d.created_date + INTERVAL '1 day')::date AS date_
    FROM dataset d
    CROSS JOIN status_ids s

    UNION ALL

    SELECT
        ('SDT2604' || lpad(d.n::text, 4, '0') || '3') AS id_statut_demande,
        d.id_demande,
        CASE
            WHEN d.n % 6 = 0 THEN s.st_refuse
            WHEN d.n % 4 = 0 THEN s.st_en_attente_paiement
            ELSE s.st_visa_approve
        END AS id_statut,
        (d.created_date + INTERVAL '2 day')::date AS date_
    FROM dataset d
    CROSS JOIN status_ids s
)
INSERT INTO statut_demande (id_statut_demande, date_, id_statut, id_demande)
SELECT
    sr.id_statut_demande,
    sr.date_,
    sr.id_statut,
    sr.id_demande
FROM status_rows sr
WHERE sr.id_statut IS NOT NULL
  AND EXISTS (SELECT 1 FROM demande d WHERE d.id_demande = sr.id_demande)
  AND NOT EXISTS (
      SELECT 1 FROM statut_demande sd WHERE sd.id_statut_demande = sr.id_statut_demande
  );

COMMIT;

select * from carte_residence;

select * from demande;