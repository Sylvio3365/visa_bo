-- Consolidated Database Schema (DDL)
-- This file contains all table creations, sequences, performance indexes and database views.

-- =========================================================================
-- 1. CLEANUP (Drop existing objects with CASCADE to handle foreign keys)
-- =========================================================================

DROP VIEW IF EXISTS v_demande_resume CASCADE;

DROP TABLE IF EXISTS statut_demande CASCADE;
DROP TABLE IF EXISTS check_piece CASCADE;
DROP TABLE IF EXISTS visa CASCADE;
DROP TABLE IF EXISTS carte_residence CASCADE;
DROP TABLE IF EXISTS demande CASCADE;
DROP TABLE IF EXISTS visa_transformable CASCADE;
DROP TABLE IF EXISTS passport CASCADE;
DROP TABLE IF EXISTS demandeur CASCADE;
DROP TABLE IF EXISTS piece CASCADE;
DROP TABLE IF EXISTS type_visa CASCADE;
DROP TABLE IF EXISTS situation_famille CASCADE;
DROP TABLE IF EXISTS categorie_demande CASCADE;
DROP TABLE IF EXISTS nationalite CASCADE;
DROP TABLE IF EXISTS statut CASCADE;
DROP TABLE IF EXISTS champs CASCADE;
DROP TABLE IF EXISTS genre CASCADE;

DROP SEQUENCE IF EXISTS seq_type_visa CASCADE;
DROP SEQUENCE IF EXISTS seq_situation_famille CASCADE;
DROP SEQUENCE IF EXISTS seq_categorie_demande CASCADE;
DROP SEQUENCE IF EXISTS seq_piece CASCADE;
DROP SEQUENCE IF EXISTS seq_nationalite CASCADE;
DROP SEQUENCE IF EXISTS seq_statut CASCADE;
DROP SEQUENCE IF EXISTS seq_champs CASCADE;
DROP SEQUENCE IF EXISTS seq_demandeur CASCADE;
DROP SEQUENCE IF EXISTS seq_passport CASCADE;
DROP SEQUENCE IF EXISTS seq_demande CASCADE;
DROP SEQUENCE IF EXISTS seq_carte_residence CASCADE;
DROP SEQUENCE IF EXISTS seq_visa_transformable CASCADE;
DROP SEQUENCE IF EXISTS seq_visa CASCADE;
DROP SEQUENCE IF EXISTS seq_statut_demande CASCADE;

-- =========================================================================
-- 2. SEQUENCES CREATION
-- =========================================================================

CREATE SEQUENCE seq_type_visa START 1;
CREATE SEQUENCE seq_situation_famille START 1;
CREATE SEQUENCE seq_categorie_demande START 1;
CREATE SEQUENCE seq_piece START 1;
CREATE SEQUENCE seq_nationalite START 1;
CREATE SEQUENCE seq_statut START 1;
CREATE SEQUENCE seq_champs START 1;
CREATE SEQUENCE seq_demandeur START 1;
CREATE SEQUENCE seq_passport START 1;
CREATE SEQUENCE seq_demande START 1;
CREATE SEQUENCE seq_carte_residence START 1;
CREATE SEQUENCE seq_visa_transformable START 1;
CREATE SEQUENCE seq_visa START 1;
CREATE SEQUENCE seq_statut_demande START 1;

-- =========================================================================
-- 3. TABLES CREATION
-- =========================================================================

CREATE TABLE type_visa(
   id_type_visa VARCHAR(50),
   libelle VARCHAR(150) NOT NULL,
   PRIMARY KEY(id_type_visa)
);

CREATE TABLE situation_famille(
   id_situation_famille VARCHAR(50), 
   libelle VARCHAR(150) NOT NULL,
   PRIMARY KEY(id_situation_famille)
);

CREATE TABLE categorie_demande(
   id_categorie VARCHAR(50),
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_categorie)
);

CREATE TABLE genre(
   id_genre VARCHAR(50),
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_genre)
);

CREATE TABLE piece(
   id_piece VARCHAR(50),
   libelle VARCHAR(250) NOT NULL,
   est_obligatoire INTEGER NOT NULL,
   id_type_visa VARCHAR(50),
   PRIMARY KEY(id_piece),
   FOREIGN KEY(id_type_visa) REFERENCES type_visa(id_type_visa)
);

CREATE TABLE nationalite(
   id_nationalite VARCHAR(50),
   libelle VARCHAR(150) NOT NULL,
   flag VARCHAR(2),
   PRIMARY KEY(id_nationalite)
);

CREATE TABLE statut(
   id_statut VARCHAR(50),
   libelle VARCHAR(150) NOT NULL,
   PRIMARY KEY(id_statut)
);

CREATE TABLE champs(
   id_champs VARCHAR(50),
   libelle VARCHAR(150) NOT NULL,
   est_obligatoire INTEGER NOT NULL,
   PRIMARY KEY(id_champs)
);

CREATE TABLE demandeur(
   id_demandeur VARCHAR(50),
   nom VARCHAR(250),
   prenom VARCHAR(250),
   nom_jeune_fille VARCHAR(50),
   dtn DATE,
   adresse_mada VARCHAR(250),
   telephone VARCHAR(50),
   email VARCHAR(50),
   created_at DATE,
   updated_at DATE,
   id_nationalite VARCHAR(50) NOT NULL,
   id_situation_famille VARCHAR(50) NOT NULL,
   id_genre VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_demandeur),
   FOREIGN KEY(id_nationalite) REFERENCES nationalite(id_nationalite),
   FOREIGN KEY(id_situation_famille) REFERENCES situation_famille(id_situation_famille),
   FOREIGN KEY(id_genre) REFERENCES genre(id_genre)
);

CREATE TABLE passport(
   id_passport VARCHAR(50),
   numero VARCHAR(150) NOT NULL,
   delivre_le DATE NOT NULL,
   expire_le DATE NOT NULL,
   id_demandeur VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_passport),
   UNIQUE(numero),
   FOREIGN KEY(id_demandeur) REFERENCES demandeur(id_demandeur)
);

CREATE TABLE visa_transformable(
   id_visa_transformable VARCHAR(50),
   ref_visa VARCHAR(50) NOT NULL,
   date_debut DATE NOT NULL,
   date_fin DATE NOT NULL,
   id_passport VARCHAR(50) NOT NULL,
   id_demandeur VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_visa_transformable),
   UNIQUE(ref_visa),
   FOREIGN KEY(id_passport) REFERENCES passport(id_passport),
   FOREIGN KEY(id_demandeur) REFERENCES demandeur(id_demandeur)
);

CREATE TABLE demande(
   id_demande VARCHAR(50),
   created_at DATE NOT NULL,
   updated_at DATE,
   id_demande_1 VARCHAR(50),
   id_categorie VARCHAR(50) NOT NULL,
   id_type_visa VARCHAR(50) NOT NULL,
   id_demandeur VARCHAR(50) NOT NULL,
   id_passport VARCHAR(50) REFERENCES passport(id_passport),
   id_visa_transformable VARCHAR(50) REFERENCES visa_transformable(id_visa_transformable),
   PRIMARY KEY(id_demande),
   FOREIGN KEY(id_demande_1) REFERENCES demande(id_demande),
   FOREIGN KEY(id_categorie) REFERENCES categorie_demande(id_categorie),
   FOREIGN KEY(id_type_visa) REFERENCES type_visa(id_type_visa),
   FOREIGN KEY(id_demandeur) REFERENCES demandeur(id_demandeur)
);

CREATE TABLE carte_residence(
   id_carte_residence VARCHAR(50),
   ref_carte_residence VARCHAR(50),
   date_debut DATE NOT NULL,
   date_fin DATE NOT NULL,
   id_passport VARCHAR(50) NOT NULL,
   id_demande VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_carte_residence),
   UNIQUE(ref_carte_residence),
   FOREIGN KEY(id_passport) REFERENCES passport(id_passport),
   FOREIGN KEY(id_demande) REFERENCES demande(id_demande)
);

CREATE TABLE visa(
   id_visa VARCHAR(50),
   ref_visa VARCHAR(50) NOT NULL,
   date_debut TIMESTAMP NOT NULL,
   date_fin TIMESTAMP NOT NULL,
   id_passport VARCHAR(50) NOT NULL,
   id_demande VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_visa),
   UNIQUE(ref_visa),
   FOREIGN KEY(id_passport) REFERENCES passport(id_passport),
   FOREIGN KEY(id_demande) REFERENCES demande(id_demande)
);

CREATE TABLE check_piece(
   id_demande VARCHAR(50),
   id_piece VARCHAR(50),
   est_fourni BOOLEAN,
   updated_at DATE,
   est_uploade BOOLEAN DEFAULT FALSE,
   chemin_document VARCHAR(255),
   PRIMARY KEY(id_demande, id_piece),
   FOREIGN KEY(id_demande) REFERENCES demande(id_demande),
   FOREIGN KEY(id_piece) REFERENCES piece(id_piece)
);

CREATE TABLE statut_demande(
   id_statut_demande VARCHAR(50),
   date_ DATE NOT NULL,
   id_statut VARCHAR(50) NOT NULL,
   id_demande VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_statut_demande),
   FOREIGN KEY(id_statut) REFERENCES statut(id_statut),
   FOREIGN KEY(id_demande) REFERENCES demande(id_demande)
);

-- =========================================================================
-- 4. INDEXES CREATION
-- =========================================================================

CREATE INDEX idx_piece_type_visa ON piece(id_type_visa);
CREATE INDEX idx_demandeur_nationalite ON demandeur(id_nationalite);
CREATE INDEX idx_demandeur_situation_famille ON demandeur(id_situation_famille);
CREATE INDEX idx_demandeur_genre ON demandeur(id_genre);
CREATE INDEX idx_passport_demandeur ON passport(id_demandeur);

CREATE INDEX idx_demande_demande_parent ON demande(id_demande_1);
CREATE INDEX idx_demande_categorie ON demande(id_categorie);
CREATE INDEX idx_demande_type_visa ON demande(id_type_visa);
CREATE INDEX idx_demande_demandeur ON demande(id_demandeur);
CREATE INDEX idx_demande_passport ON demande(id_passport);
CREATE INDEX idx_demande_visa_transformable ON demande(id_visa_transformable);

CREATE INDEX idx_carte_residence_passport ON carte_residence(id_passport);
CREATE INDEX idx_carte_residence_demande ON carte_residence(id_demande);

CREATE INDEX idx_visa_transformable_passport ON visa_transformable(id_passport);
CREATE INDEX idx_visa_transformable_demandeur ON visa_transformable(id_demandeur);

CREATE INDEX idx_visa_passport ON visa(id_passport);
CREATE INDEX idx_visa_demande ON visa(id_demande);

CREATE INDEX idx_check_piece_piece ON check_piece(id_piece);
CREATE INDEX idx_check_piece_demande ON check_piece(id_demande);

CREATE INDEX idx_statut_demande_statut ON statut_demande(id_statut);
CREATE INDEX idx_statut_demande_demande ON statut_demande(id_demande);

-- =========================================================================
-- 5. VIEWS CREATION
-- =========================================================================

CREATE OR REPLACE VIEW v_demande_resume AS
SELECT
    d.id_demande,
    d.created_at,
    d.updated_at,

    dem.id_demandeur,
    dem.nom AS nom_demandeur,
    dem.prenom AS prenom_demandeur,
    dem.telephone AS telephone_demandeur,
    dem.email AS email_demandeur,

    tv.id_type_visa,
    tv.libelle AS libelle_type_visa,

    cd.id_categorie,
    cd.libelle AS libelle_categorie,

    p.id_passport,
    p.numero AS numero_passport,

    vt.id_visa_transformable,
    vt.ref_visa
FROM demande d
JOIN demandeur dem ON dem.id_demandeur = d.id_demandeur
JOIN type_visa tv ON tv.id_type_visa = d.id_type_visa
JOIN categorie_demande cd ON cd.id_categorie = d.id_categorie
LEFT JOIN passport p ON p.id_passport = d.id_passport
LEFT JOIN visa_transformable vt ON vt.id_visa_transformable = d.id_visa_transformable;
