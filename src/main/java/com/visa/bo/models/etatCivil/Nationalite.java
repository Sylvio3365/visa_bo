package com.visa.bo.models.etatCivil;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "nationalite")
public class Nationalite {
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
