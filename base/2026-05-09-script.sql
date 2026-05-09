CREATE TABLE genre (
    id_genre VARCHAR(50) PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

INSERT INTO genre (id_genre, libelle) VALUES ('GEN01', 'Masculin'), ('GEN02', 'Feminin');

ALTER TABLE demandeur ADD COLUMN id_genre VARCHAR(50) REFERENCES genre(id_genre);
UPDATE demandeur SET id_genre = 'GEN01';
ALTER TABLE demandeur ALTER COLUMN id_genre SET NOT NULL;

INSERT INTO champs (id_champs, libelle, est_obligatoire) VALUES ('CH00000' || nextval('seq_champs'), 'id_genre', 1);

-- Script du 09-05-2026 : Ajout du statut 'Photo et signature terminés'
insert into statut (id_statut, libelle) VALUES ('ST00000' || nextval('seq_statut'), 'Photo et signature terminés');

