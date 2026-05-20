-- Reference / Initial Parameter Data Setup

BEGIN;

-- =========================================================================
-- 1. GENRES
-- =========================================================================
INSERT INTO genre (id_genre, libelle) VALUES ('GEN01', 'Masculin');
INSERT INTO genre (id_genre, libelle) VALUES ('GEN02', 'Feminin');

-- =========================================================================
-- 2. TYPES OF VISA
-- =========================================================================
INSERT INTO type_visa (id_type_visa, libelle) VALUES ('TV00000' || nextval('seq_type_visa'), 'Travailleur');   -- TV000001
INSERT INTO type_visa (id_type_visa, libelle) VALUES ('TV00000' || nextval('seq_type_visa'), 'Investisseur');   -- TV000002

-- =========================================================================
-- 3. FAMILY SITUATION
-- =========================================================================
INSERT INTO situation_famille (id_situation_famille, libelle) VALUES ('SF00000' || nextval('seq_situation_famille'), 'Célibataire'); -- SF000001
INSERT INTO situation_famille (id_situation_famille, libelle) VALUES ('SF00000' || nextval('seq_situation_famille'), 'Marié');       -- SF000002

-- =========================================================================
-- 4. APPLICATION CATEGORIES
-- =========================================================================
INSERT INTO categorie_demande (id_categorie, libelle) VALUES ('CD00000' || nextval('seq_categorie_demande'), 'Nouvelle-demande');   -- CD000001
INSERT INTO categorie_demande (id_categorie, libelle) VALUES ('CD00000' || nextval('seq_categorie_demande'), 'Duplicata');           -- CD000002
INSERT INTO categorie_demande (id_categorie, libelle) VALUES ('CD00000' || nextval('seq_categorie_demande'), 'Transfert-de-visa');   -- CD000003

-- =========================================================================
-- 5. NATIONALITIES (with integrated country flags)
-- =========================================================================
INSERT INTO nationalite (id_nationalite, libelle, flag) VALUES ('NA00000' || nextval('seq_nationalite'), 'Malagasy', '🇲🇬'); -- NA000001
INSERT INTO nationalite (id_nationalite, libelle, flag) VALUES ('NA00000' || nextval('seq_nationalite'), 'French', '🇫🇷');   -- NA000002
INSERT INTO nationalite (id_nationalite, libelle, flag) VALUES ('NA00000' || nextval('seq_nationalite'), 'Comorian', '🇰🇲'); -- NA000003
INSERT INTO nationalite (id_nationalite, libelle, flag) VALUES ('NA00000' || nextval('seq_nationalite'), 'Mauritian', '🇲🇺');-- NA000004
INSERT INTO nationalite (id_nationalite, libelle, flag) VALUES ('NA00000' || nextval('seq_nationalite'), 'Japonais', NULL);  -- NA000005

-- =========================================================================
-- 6. APPLICATION STATUSES
-- =========================================================================
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'dossier cree');               -- ST000001
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'scanne valider');             -- ST000002
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'visa approve');               -- ST000003
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'en attente paiement');        -- ST000004
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'dossier incomplet');          -- ST000005
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'refuse');                     -- ST000006
INSERT INTO statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'Photo et signature terminés');-- ST000007

-- =========================================================================
-- 7. REQUIRED DOCUMENTS / PIECES (Linked to types of visa where applicable)
-- =========================================================================
-- Specific to Workers (TV000001)
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Autorisation emploi délivrée à Madagascar par le Ministère de la Fonction publique', 1, 'TV000001');
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Attestation d’emploi délivré par l’employeur (Original)', 1, 'TV000001');

-- Specific to Investors (TV000002)
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Statut de la Société', 1, 'TV000002');
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Extrait d’inscription au registre de commerce', 1, 'TV000002');
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Carte fiscale', 1, 'TV000002');

-- General / Common pieces (applicable to all, type_visa = NULL)
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), '02 photos d’identité', 1, NULL);
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Notice de renseignement', 1, NULL);
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Demande adressée à Mr le Ministère de l’Intérieur et de la Décentralisation avec adresse e-mail et numéro téléphone portable', 1, NULL);
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Photocopie certifiée du visa en cours de validité', 1, NULL);
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Photocopie certifiée de la première page du passeport', 1, NULL);
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Photocopie certifiée de la carte résident en cours de validité', 1, NULL);
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Certificat de résidence à Madagascar', 1, NULL);
INSERT INTO piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Extrait de casier judiciaire moins de 3 mois', 1, NULL);

-- =========================================================================
-- 8. SYSTEM DYNAMIC PARAMETER FIELDS (champs)
-- =========================================================================
ALTER SEQUENCE seq_champs RESTART WITH 1;

-- Demandeur basic info
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

-- Passport info
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'num_passport', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'date_delivrance_passport', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'date_expiration_passport', 1);

-- Transformable visa info
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'ref_visa', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'date_debut', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'date_fin', 1);

-- Visa / Demande metadata
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'id_type_visa', 1);
INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'id_genre', 1);

COMMIT;
