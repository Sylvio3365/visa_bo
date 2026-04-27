-- Script d'insertion de données de test - 19 avril 2026

DELETE FROM champs;

ALTER SEQUENCE seq_champs RESTART WITH 1;

-- Reinsertion de tous les attributs demandeur dans la table champs
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'id_demandeur', 0);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'nom', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'prenom', 0);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'nom_jeune_fille', 0);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'dtn', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'adresse_mada', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'telephone', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'email', 0);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'created_at', 0);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'updated_at', 0);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'id_nationalite', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'id_situation_famille', 0);

-- Ajout des champs de passeport
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'num_passport', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'date_delivrance_passport', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'date_expiration_passport', 1);

-- Ajout des champs de visa transformable
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'ref_visa', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'date_debut', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'date_fin', 1);

-- Ajout du champ de type de visa
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'id_type_visa', 1);

-- Insertion de 2 demandeurs
INSERT INTO demandeur (id_demandeur, nom, prenom, nom_jeune_fille, dtn, adresse_mada, telephone, email, created_at, updated_at, id_nationalite, id_situation_famille)
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
    'SF000001'
);

INSERT INTO demandeur (id_demandeur, nom, prenom, nom_jeune_fille, dtn, adresse_mada, telephone, email, created_at, updated_at, id_nationalite, id_situation_famille)
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
    'SF000002'
);

-- Insertion d'un passeport pour le premier demandeur
INSERT INTO passport (id_passport, numero, delivre_le, expire_le, id_demandeur)
VALUES (
    'P00000' || nextval('seq_passport'),
    'PASS2025',
    '2020-05-15',
    '2030-05-15',
    'DM000001'
);

-- Insertion d'un visa transformable pour le premier demandeur
-- Ajout des colonnes id_passport et id_visa_transformable à la table demande
ALTER TABLE demande ADD COLUMN IF NOT EXISTS id_passport VARCHAR(50) REFERENCES passport(id_passport);
ALTER TABLE demande ADD COLUMN IF NOT EXISTS id_visa_transformable VARCHAR(50) REFERENCES visa_transformable(id_visa_transformable);

INSERT INTO visa_transformable (id_visa_transformable, ref_visa, date_debut, date_fin, id_passport, id_demandeur)
VALUES (
    'VT00000' || nextval('seq_visa_transformable'),
    'VISA2025001',
    '2024-01-01',
    '2026-12-31',
    'P000001',
    'DM000001'
);

select * from statut;