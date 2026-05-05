ROLLBACK;

DELETE FROM statut_demande 
WHERE id_demande IN (
    SELECT id_demande FROM demande 
    WHERE id_demandeur IN (
        SELECT id_demandeur FROM demandeur 
        WHERE email LIKE 'demandeur%@test.com'
    )
);

DELETE FROM visa 
WHERE ref_visa LIKE 'VISASEQ%';

DELETE FROM carte_residence 
WHERE ref_carte_residence LIKE 'CRSEQ%';

DELETE FROM demande 
WHERE id_demandeur IN (
    SELECT id_demandeur FROM demandeur 
    WHERE email LIKE 'demandeur%@test.com'
);

DELETE FROM visa_transformable 
WHERE ref_visa LIKE 'VTSEQ%';

DELETE FROM passport 
WHERE numero LIKE 'PASSSEQ%';

DELETE FROM demandeur 
WHERE email LIKE 'demandeur%@test.com';


BEGIN;

ALTER TABLE demande ADD COLUMN IF NOT EXISTS id_passport VARCHAR(50) REFERENCES passport(id_passport);
ALTER TABLE demande ADD COLUMN IF NOT EXISTS id_visa_transformable VARCHAR(50) REFERENCES visa_transformable(id_visa_transformable);

CREATE SEQUENCE IF NOT EXISTS seq_statut_demande START 1;

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

        -- Dates variées pour tester les filtres
IF i <= 7 THEN
    -- 7 demandes aujourd'hui pour tester l'affichage par défaut
    v_created_at := CURRENT_DATE;
ELSIF i <= 12 THEN
    -- 5 demandes hier
    v_created_at := CURRENT_DATE - INTERVAL '1 day';
ELSIF i <= 16 THEN
    -- 4 demandes il y a quelques jours
    v_created_at := CURRENT_DATE - (i - 10);
ELSE
    -- 4 demandes à des dates plus anciennes
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
            id_situation_famille
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
            CASE WHEN MOD(i, 2) = 0 THEN 'SF000002' ELSE 'SF000001' END
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