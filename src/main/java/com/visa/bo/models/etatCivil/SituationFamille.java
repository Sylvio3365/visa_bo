package com.visa.bo.models.etatCivil;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "situation_famille")
public class SituationFamille {
    @Id
    @Column(name = "id_situation_famille", length = 50)
    private String idSituationFamille;

    @Column(name = "libelle", nullable = false, length = 150)
    private String libelle;

    public String getIdSituationFamille() {
        return idSituationFamille;
    }

    public void setIdSituationFamille(String idSituationFamille) {
        this.idSituationFamille = idSituationFamille;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
