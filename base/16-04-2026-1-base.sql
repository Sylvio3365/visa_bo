-- Active: 1736646695640@@127.0.0.1@5432@visa_db

create database visa_db;
use visa_db;

CREATE TABLE type_visa(
   id_type_visa VARCHAR(50),
   libelle VARCHAR(150) NOT NULL,
   PRIMARY KEY(id_type_visa)
);

CREATE TABLE situation_famille(
   id_situation_famille VARCHAR(50), 
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_situation_famille)
);

CREATE TABLE categorie_demande(
   id_categorie VARCHAR(50),
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_categorie)
);

CREATE TABLE piece(
   id_piece VARCHAR(50),
   libelle VARCHAR(250) NOT NULL,
   id_type_visa VARCHAR(50) set default null,
   PRIMARY KEY(id_piece),
   FOREIGN KEY(id_type_visa) REFERENCES type_visa(id_type_visa)
);


CREATE TABLE nationalite(
   id_nationalite VARCHAR(50),
   libelle VARCHAR(250) NOT NULL,
   PRIMARY KEY(id_nationalite)
);

CREATE TABLE personne(
   id_personne VARCHAR(50),
   nom VARCHAR(250) NOT NULL,
   prenom VARCHAR(250) NOT NULL,
   profession VARCHAR(50) NOT NULL,
   nom_jeune_fille VARCHAR(50),
   domicile VARCHAR(50) NOT NULL,
   dtn DATE NOT NULL,
   email VARCHAR(50) NOT NULL,
   telephone VARCHAR(50) NOT NULL,
   id_nationalite VARCHAR(50) NOT NULL,
   id_situation_famille VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_personne),
   FOREIGN KEY(id_nationalite) REFERENCES nationalite(id_nationalite),
   FOREIGN KEY(id_situation_famille) REFERENCES situation_famille(id_situation_famille)
);

CREATE TABLE passport(
   id_passport VARCHAR(50),
   numero VARCHAR(150) NOT NULL,
   delivre_le DATE NOT NULL,
   expire_le DATE NOT NULL,
   id_personne VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_passport),
   UNIQUE(id_personne),
   UNIQUE(numero),
   FOREIGN KEY(id_personne) REFERENCES personne(id_personne)
);

CREATE TABLE demande_resident(
   id_demande_resident VARCHAR(50),
   date_ DATE NOT NULL,
   id_categorie VARCHAR(50) NOT NULL,
   id_type_visa VARCHAR(50) NOT NULL,
   id_personne VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_demande_resident),
   FOREIGN KEY(id_categorie) REFERENCES categorie_demande(id_categorie),
   FOREIGN KEY(id_type_visa) REFERENCES type_visa(id_type_visa),
   FOREIGN KEY(id_personne) REFERENCES personne(id_personne)
);

CREATE TABLE visa(
   id_visa VARCHAR(50),
   ref_visa VARCHAR(150) NOT NULL,
   date_debut TIMESTAMP NOT NULL,
   date_fin TIMESTAMP NOT NULL,
   actif INTEGER NOT NULL,
   date_ DATE NOT NULL,
   origine VARCHAR(50),
   id_type_visa VARCHAR(50) NOT NULL,
   id_personne VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_visa),
   UNIQUE(ref_visa),
   FOREIGN KEY(id_type_visa) REFERENCES type_visa(id_type_visa),
   FOREIGN KEY(id_personne) REFERENCES personne(id_personne)
);

CREATE TABLE check_piece(
   id_demande_resident VARCHAR(50),
   id_piece VARCHAR(50),
   est_fourni BOOLEAN,
   PRIMARY KEY(id_demande_resident, id_piece),
   FOREIGN KEY(id_demande_resident) REFERENCES demande_resident(id_demande_resident),
   FOREIGN KEY(id_piece) REFERENCES piece(id_piece)
);

CREATE SEQUENCE seq_type_visa START 1;
CREATE SEQUENCE seq_situation_famille START 1;
CREATE SEQUENCE seq_categorie_demande START 1;
CREATE SEQUENCE seq_piece START 1;
CREATE SEQUENCE seq_nationalite START 1;
CREATE SEQUENCE seq_personne START 1;
CREATE SEQUENCE seq_passport START 1;
CREATE SEQUENCE seq_demande_resident START 1;
CREATE SEQUENCE seq_visa START 1;

CREATE INDEX idx_piece_type_visa
ON piece(id_type_visa);

CREATE INDEX idx_personne_nationalite
ON personne(id_nationalite);

CREATE INDEX idx_personne_situation_famille
ON personne(id_situation_famille);

CREATE INDEX idx_passport_personne
ON passport(id_personne);

CREATE INDEX idx_demande_resident_categorie
ON demande_resident(id_categorie);

CREATE INDEX idx_demande_resident_type_visa
ON demande_resident(id_type_visa);

CREATE INDEX idx_demande_resident_personne
ON demande_resident(id_personne);

CREATE INDEX idx_visa_type_visa
ON visa(id_type_visa);

CREATE INDEX idx_visa_personne
ON visa(id_personne);

CREATE INDEX idx_check_piece_piece
ON check_piece(id_piece);