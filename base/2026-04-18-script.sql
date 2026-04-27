UPDATE categorie_demande 
SET libelle = 'Nouveau titre'
WHERE libelle = 'Nouvelle demande';

ALTER TABLE nationalite ADD COLUMN flag VARCHAR(2);

UPDATE nationalite SET flag = '🇲🇬' WHERE libelle = 'Malagasy';
UPDATE nationalite SET flag = '🇫🇷' WHERE libelle = 'French';
UPDATE nationalite SET flag = '🇰🇲' WHERE libelle = 'Comorian';
UPDATE nationalite SET flag = '🇲🇺' WHERE libelle = 'Mauritian';