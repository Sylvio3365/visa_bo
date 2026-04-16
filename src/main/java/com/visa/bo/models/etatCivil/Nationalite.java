package com.visa.bo.models.etatCivil;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "nationalite")
public class Nationalite {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("nationalite", "id_nationalite", "NA", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_nationalite", length = 50)
    private String idNationalite;

    @Column(name = "libelle", nullable = false, length = 150)
    private String libelle;

    public String getIdNationalite() {
        return idNationalite;
    }

    public void setIdNationalite(String idNationalite) {
        this.idNationalite = idNationalite;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
