-- Consolidated Test Data Script
-- Populates explicit test cases, 72 paginated demands, and a 20-entry custom PL/pgSQL generator.

BEGIN;

-- =========================================================================
-- 1. EXPLICIT TEST CASES (Jean Dupont and Marie Martin)
-- =========================================================================

-- Clean up any existing records with test emails to avoid conflicts
DELETE FROM statut_demande WHERE id_demande IN (SELECT id_demande FROM demande WHERE id_demandeur IN (SELECT id_demandeur FROM demandeur WHERE email LIKE '%@email.com' OR email LIKE '%@test.%'));
DELETE FROM visa WHERE id_passport IN (SELECT id_passport FROM passport WHERE id_demandeur IN (SELECT id_demandeur FROM demandeur WHERE email LIKE '%@email.com' OR email LIKE '%@test.%'));
DELETE FROM carte_residence WHERE id_passport IN (SELECT id_passport FROM passport WHERE id_demandeur IN (SELECT id_demandeur FROM demandeur WHERE email LIKE '%@email.com' OR email LIKE '%@test.%'));
DELETE FROM demande WHERE id_demandeur IN (SELECT id_demandeur FROM demandeur WHERE email LIKE '%@email.com' OR email LIKE '%@test.%');
DELETE FROM visa_transformable WHERE id_demandeur IN (SELECT id_demandeur FROM demandeur WHERE email LIKE '%@email.com' OR email LIKE '%@test.%');
DELETE FROM passport WHERE id_demandeur IN (SELECT id_demandeur FROM demandeur WHERE email LIKE '%@email.com' OR email LIKE '%@test.%');
DELETE FROM demandeur WHERE email LIKE '%@email.com' OR email LIKE '%@test.%';

-- Insert explicit test demandeurs
INSERT INTO demandeur (id_demandeur, nom, prenom, nom_jeune_fille, dtn, adresse_mada, telephone, email, created_at, updated_at, id_nationalite, id_situation_famille, id_genre)
VALUES (
    'DM00000' || nextval('seq_demandeur'),
    'Dupont',
    'Jean',
    'Martin',
    '1990-05-15',
    'Antananarivo, Madagascar',
    '+261 32 12 345 67',
    'jean.dupont@email.com',
    CURRENT_DATE,
    CURRENT_DATE,
    'NA000001',
    'SF000001',
    'GEN01'
);

INSERT INTO demandeur (id_demandeur, nom, prenom, nom_jeune_fille, dtn, adresse_mada, telephone, email, created_at, updated_at, id_nationalite, id_situation_famille, id_genre)
VALUES (
    'DM00000' || nextval('seq_demandeur'),
    'Martin',
    'Marie',
    'Durand',
    '1995-08-20',
    'Toliara, Madagascar',
    '+261 34 56 789 01',
    'marie.martin@email.com',
    CURRENT_DATE,
    CURRENT_DATE,
    'NA000001',
    'SF000002',
    'GEN02'
);

-- Insert passports for explicit demandeurs
INSERT INTO passport (id_passport, numero, delivre_le, expire_le, id_demandeur)
VALUES (
    'P00000' || nextval('seq_passport'),
    'PASS2025',
    '2020-05-15',
    '2030-05-15',
    'DM000001'
);

-- Insert visa transformable
INSERT INTO visa_transformable (id_visa_transformable, ref_visa, date_debut, date_fin, id_passport, id_demandeur)
VALUES (
    'VT00000' || nextval('seq_visa_transformable'),
    'VISA2025001',
    '2024-01-01',
    '2026-12-31',
    'P000001',
    'DM000001'
);

-- Ensure test-specific statuses exist for testing filters and workflows
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'en attente paiement');
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'dossier incomplet');
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'refuse');

-- =========================================================================
-- 2. GENERATE SERIES SET (72 Paginated Demands with coherent states)
-- =========================================================================


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
    id_situation_famille,
    id_genre
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
    r.id_situation_famille,
    CASE WHEN d.n % 2 = 0 THEN 'GEN02' ELSE 'GEN01' END
FROM dataset d
CROSS JOIN refs r
WHERE r.id_nationalite IS NOT NULL
  AND r.id_situation_famille IS NOT NULL;

-- Passports for the 72 series demandeurs
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
FROM dataset d;

-- Visa transformables for the 72 series demandeurs
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
FROM dataset d;

-- Demands for the 72 series
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
CROSS JOIN refs r;

-- Status history per demand (3 entries each for status timelines)
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
WHERE sr.id_statut IS NOT NULL;

-- =========================================================================
-- 3. PL/pgSQL DYNAMIC DATA GENERATOR (20 demandeurs with details, visas and residence cards)
-- =========================================================================

DO $$
DECLARE
    i INTEGER;

    v_id_demandeur VARCHAR(50);
    v_id_passport VARCHAR(50);
    v_id_visa_transformable VARCHAR(50);
    v_id_demande VARCHAR(50);
    v_id_statut_demande VARCHAR(50);
    v_id_visa VARCHAR(50);
    v_id_carte_residence VARCHAR(50);

    v_id_type_visa VARCHAR(50);
    v_id_categorie VARCHAR(50);
    v_id_statut VARCHAR(50);

    v_created_at DATE;
BEGIN
    FOR i IN 1..20 LOOP

        v_id_demandeur := 'DM00000' || nextval('seq_demandeur');
        v_id_passport := 'P00000' || nextval('seq_passport');
        v_id_visa_transformable := 'VT00000' || nextval('seq_visa_transformable');
        v_id_demande := 'DMD00000' || nextval('seq_demande');
        v_id_statut_demande := 'SD00000' || nextval('seq_statut_demande');
        v_id_visa := 'V00000' || nextval('seq_visa');
        v_id_carte_residence := 'CR00000' || nextval('seq_carte_residence');

        -- Dates distribution for filter validation
        IF i <= 7 THEN
            v_created_at := CURRENT_DATE;
        ELSIF i <= 12 THEN
            v_created_at := CURRENT_DATE - INTERVAL '1 day';
        ELSIF i <= 16 THEN
            v_created_at := CURRENT_DATE - (i - 10);
        ELSE
            v_created_at := DATE '2026-04-20' + (i % 5);
        END IF;

        IF MOD(i, 2) = 0 THEN
            v_id_type_visa := 'TV000002';
        ELSE
            v_id_type_visa := 'TV000001';
        END IF;

        IF MOD(i, 3) = 1 THEN
            v_id_categorie := 'CD000001';
        ELSIF MOD(i, 3) = 2 THEN
            v_id_categorie := 'CD000002';
        ELSE
            v_id_categorie := 'CD000003';
        END IF;

        IF MOD(i, 3) = 1 THEN
            v_id_statut := 'ST000001';
        ELSIF MOD(i, 3) = 2 THEN
            v_id_statut := 'ST000002';
        ELSE
            v_id_statut := 'ST000003';
        END IF;

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
            id_situation_famille,
            id_genre
        ) VALUES (
            v_id_demandeur,
            CASE MOD(i, 5)
                WHEN 0 THEN 'Rakoto'
                WHEN 1 THEN 'Rabe'
                WHEN 2 THEN 'Rasoa'
                WHEN 3 THEN 'Randria'
                ELSE 'Andriamatoa'
            END,
            CASE MOD(i, 5)
                WHEN 0 THEN 'Jean'
                WHEN 1 THEN 'Marie'
                WHEN 2 THEN 'Paul'
                WHEN 3 THEN 'Lucie'
                ELSE 'Hery'
            END,
            NULL,
            DATE '1985-01-01' + (i * 137),
            'Adresse test ' || i || ', Madagascar',
            '+261 32 ' || LPAD((1000000 + i)::TEXT, 7, '0'),
            'demandeur' || i || '@test.com',
            v_created_at,
            v_created_at,
            CASE MOD(i, 4)
                WHEN 0 THEN 'NA000001'
                WHEN 1 THEN 'NA000002'
                WHEN 2 THEN 'NA000003'
                ELSE 'NA000004'
            END,
            CASE WHEN MOD(i, 2) = 0 THEN 'SF000002' ELSE 'SF000001' END,
            CASE WHEN MOD(i, 2) = 0 THEN 'GEN02' ELSE 'GEN01' END
        );

        INSERT INTO passport (
            id_passport,
            numero,
            delivre_le,
            expire_le,
            id_demandeur
        ) VALUES (
            v_id_passport,
            'PASSSEQ' || LPAD(i::TEXT, 4, '0'),
            DATE '2018-01-01' + (i * 30),
            DATE '2028-01-01' + (i * 30),
            v_id_demandeur
        );

        INSERT INTO visa_transformable (
            id_visa_transformable,
            ref_visa,
            date_debut,
            date_fin,
            id_passport,
            id_demandeur
        ) VALUES (
            v_id_visa_transformable,
            'VTSEQ' || LPAD(i::TEXT, 4, '0'),
            DATE '2024-01-01' + (i * 15),
            DATE '2026-01-01' + (i * 15),
            v_id_passport,
            v_id_demandeur
        );

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
        ) VALUES (
            v_id_demande,
            v_created_at,
            v_created_at,
            NULL,
            v_id_categorie,
            v_id_type_visa,
            v_id_demandeur,
            v_id_passport,
            v_id_visa_transformable
        );

        INSERT INTO statut_demande (
            id_statut_demande,
            date_,
            id_statut,
            id_demande
        ) VALUES (
            v_id_statut_demande,
            v_created_at,
            v_id_statut,
            v_id_demande
        );

        INSERT INTO visa (
            id_visa,
            ref_visa,
            date_debut,
            date_fin,
            id_passport,
            id_demande
        ) VALUES (
            v_id_visa,
            'VISASEQ' || LPAD(i::TEXT, 4, '0'),
            TIMESTAMP '2026-01-01 00:00:00' + (i * INTERVAL '10 days'),
            TIMESTAMP '2027-01-01 00:00:00' + (i * INTERVAL '10 days'),
            v_id_passport,
            v_id_demande
        );

        INSERT INTO carte_residence (
            id_carte_residence,
            ref_carte_residence,
            date_debut,
            date_fin,
            id_passport,
            id_demande
        ) VALUES (
            v_id_carte_residence,
            'CRSEQ' || LPAD(i::TEXT, 4, '0'),
            DATE '2026-01-01' + (i * 10),
            DATE '2027-01-01' + (i * 10),
            v_id_passport,
            v_id_demande
        );

    END LOOP;
END $$;

COMMIT;
