-- Migration pour ajouter le suivi des documents uploades
ALTER TABLE check_piece ADD COLUMN est_uploade BOOLEAN DEFAULT FALSE;
ALTER TABLE check_piece ADD COLUMN chemin_document VARCHAR(255);
