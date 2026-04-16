package com.visa.bo.models.demande;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "categorie_demande")
public class CategorieDemande {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("categorie_demande", "id_categorie", "CD", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

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
