-- Active: 1736646695640@@127.0.0.1@5432@visa_db

insert INTO type_visa (id_type_visa, libelle) VALUES ('TV00000' || nextval('seq_type_visa'), 'Travailleur');
insert INTO type_visa (id_type_visa, libelle) VALUES ('TV00000' || nextval('seq_type_visa'), 'Investisseur');


insert into situation_famille (id_situation_famille, libelle) VALUES ('SF00000' || nextval('seq_situation_famille'), 'Célibataire');
insert into situation_famille (id_situation_famille, libelle) VALUES ('SF00000' || nextval('seq_situation_famille'), 'Marié');

insert into categorie_demande (id_categorie, libelle) VALUES ('CD00000' || nextval('seq_categorie_demande'), 'Nouvelle demande');
insert into categorie_demande (id_categorie, libelle) VALUES ('CD00000' || nextval('seq_categorie_demande'), 'Duplicata');
insert into categorie_demande (id_categorie, libelle) VALUES ('CD00000' || nextval('seq_categorie_demande'), 'Transfert de visa');
select * from categorie_demande;
insert into nationalite (id_nationalite, libelle) VALUES ('NA00000' || nextval('seq_nationalite'), 'Malagasy');
insert into nationalite (id_nationalite, libelle) VALUES ('NA00000' || nextval('seq_nationalite'), 'French');
insert into nationalite (id_nationalite, libelle) VALUES ('NA00000' || nextval('seq_nationalite'), 'Comorian');
insert into nationalite (id_nationalite, libelle) VALUES ('NA00000' || nextval('seq_nationalite'), 'Mauritian');

insert into statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'dossier cree');
insert into statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'scanne valider');
insert into statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'visa approve');

insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Autorisation emploi délivrée à Madagascar par le Ministère de la Fonction publique', 1, 'TV000001');
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Attestation d’emploi délivré par l’employeur (Original)', 1, 'TV000001');
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Statut de la Société', 1, 'TV000002');
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Extrait d’inscription au registre de commerce', 1, 'TV000002');
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Carte fiscale', 1, 'TV000002');

insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), '02 photos d’identité', 1, NULL);
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Notice de renseignement', 1, NULL);
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Demande adressée à Mr le Ministère de l’Intérieur et de la Décentralisation avec adresse e-mail et numéro téléphone portable', 1, NULL);
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Photocopie certifiée du visa en cours de validité', 1, NULL);
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Photocopie certifiée de la première page du passeport', 1, NULL);
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Photocopie certifiée de la carte résident en cours de validité', 1, NULL);
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Certificat de résidence à Madagascar', 1, NULL);
insert into piece (id_piece, libelle, est_obligatoire, id_type_visa) VALUES ('P00000' || nextval('seq_piece'), 'Extrait de casier judiciaire moins de 3 mois', 1, NULL);

insert into champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'nom', 1);
insert into champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'prenom', 0);
insert into champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'nom_jeune_fille', 0);
insert into champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'dtn', 1);
insert into champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'adresse_mada', 1);
insert into champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'telephone', 1);
insert into champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'email', 0);
insert into champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'ref_visa', 1);

ALTER TABLE nationalite ADD COLUMN flag VARCHAR(2);

UPDATE nationalite SET flag = '🇲🇬' WHERE libelle = 'Malagasy';
UPDATE nationalite SET flag = '🇫🇷' WHERE libelle = 'French';
UPDATE nationalite SET flag = '🇰🇲' WHERE libelle = 'Comorian';
UPDATE nationalite SET flag = '🇲🇺' WHERE libelle = 'Mauritian';