package com.visa.bo.models.demande;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "statut")
public class Statut {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("statut", "id_statut", "ST", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_statut", length = 50)
    private String idStatut;

    @Column(name = "libelle", nullable = false, length = 150)
    private String libelle;

    public String getIdStatut() {
        return idStatut;
    }

    public void setIdStatut(String idStatut) {
        this.idStatut = idStatut;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
