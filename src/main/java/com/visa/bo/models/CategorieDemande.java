package com.visa.bo.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "categorie_demande")
public class CategorieDemande {
    @Id
    @Column(name = "id_categorie", length = 50)
    private String idCategorie;

    @Column(name = "libelle", nullable = false, length = 50)
    private String libelle;

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
