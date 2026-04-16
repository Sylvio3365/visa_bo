package com.visa.bo.models.demande;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "statut")
public class Statut {
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
