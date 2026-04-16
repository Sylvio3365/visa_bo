package com.visa.bo.models.demande;

import java.time.LocalDate;

import com.visa.bo.models.etatcivique.Personne;
import com.visa.bo.models.visa.TypeVisa;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "demande_resident")
public class DemandeResident {
    @Id
    @Column(name = "id_demande_resident", length = 50)
    private String idDemandeResident;

    @Column(name = "date_", nullable = false)
    private LocalDate date;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_categorie", nullable = false)
    private CategorieDemande categorie;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_type_visa", nullable = false)
    private TypeVisa typeVisa;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_personne", nullable = false)
    private Personne personne;

    public String getIdDemandeResident() {
        return idDemandeResident;
    }

    public void setIdDemandeResident(String idDemandeResident) {
        this.idDemandeResident = idDemandeResident;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public CategorieDemande getCategorie() {
        return categorie;
    }

    public void setCategorie(CategorieDemande categorie) {
        this.categorie = categorie;
    }

    public TypeVisa getTypeVisa() {
        return typeVisa;
    }

    public void setTypeVisa(TypeVisa typeVisa) {
        this.typeVisa = typeVisa;
    }

    public Personne getPersonne() {
        return personne;
    }

    public void setPersonne(Personne personne) {
        this.personne = personne;
    }
}
