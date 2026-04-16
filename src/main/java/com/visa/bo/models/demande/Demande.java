package com.visa.bo.models.demande;

import java.time.LocalDate;

import com.visa.bo.models.etatCivil.Demandeur;
import com.visa.bo.models.visa.TypeVisa;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "demande")
public class Demande {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("demande", "id_demande", "DMD", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_demande", length = 50)
    private String idDemande;

    @Column(name = "created_at", nullable = false)
    private LocalDate createdAt;

    @Column(name = "updated_at")
    private LocalDate updatedAt;

    @ManyToOne
    @JoinColumn(name = "id_demande_1")
    private Demande parentDemande;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_categorie", nullable = false)
    private CategorieDemande categorie;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_type_visa", nullable = false)
    private TypeVisa typeVisa;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_demandeur", nullable = false)
    private Demandeur demandeur;

    public String getIdDemande() {
        return idDemande;
    }

    public void setIdDemande(String idDemande) {
        this.idDemande = idDemande;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDate getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDate updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Demande getParentDemande() {
        return parentDemande;
    }

    public void setParentDemande(Demande parentDemande) {
        this.parentDemande = parentDemande;
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

    public Demandeur getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(Demandeur demandeur) {
        this.demandeur = demandeur;
    }
}
