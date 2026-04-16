package com.visa.bo.models.demande;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "champs")
public class Champs {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("champs", "id_champs", "CH", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_champs", length = 50)
    private String idChamps;

    @Column(name = "libelle", nullable = false, length = 150)
    private String libelle;

    @Column(name = "est_obligatoire", nullable = false)
    private Integer estObligatoire;

    public String getIdChamps() {
        return idChamps;
    }

    public void setIdChamps(String idChamps) {
        this.idChamps = idChamps;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Integer getEstObligatoire() {
        return estObligatoire;
    }

    public void setEstObligatoire(Integer estObligatoire) {
        this.estObligatoire = estObligatoire;
    }
}
