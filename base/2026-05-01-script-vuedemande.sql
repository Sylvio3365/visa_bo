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

select * from v_demande_resume where id_demande = 'DMD0000023';