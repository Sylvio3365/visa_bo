package com.visa.bo.models.demande;

import java.time.LocalDate;

import org.hibernate.annotations.Immutable;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Immutable
@Table(name = "v_demande_resume")
public class DemandeVue {

    @Id
    private String idDemande;

    private LocalDate createdAt;
    private LocalDate updatedAt;

    private String idDemandeur;
    private String nomDemandeur;
    private String prenomDemandeur;
    private String telephoneDemandeur;
    private String emailDemandeur;

    private String idTypeVisa;
    private String libelleTypeVisa;

    private String idCategorie;
    private String libelleCategorie;

    private String idPassport;
    private String numeroPassport;

    private String idVisaTransformable;
    private String refVisa;

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

    public String getIdDemandeur() {
        return idDemandeur;
    }

    public void setIdDemandeur(String idDemandeur) {
        this.idDemandeur = idDemandeur;
    }

    public String getNomDemandeur() {
        return nomDemandeur;
    }

    public void setNomDemandeur(String nomDemandeur) {
        this.nomDemandeur = nomDemandeur;
    }

    public String getPrenomDemandeur() {
        return prenomDemandeur;
    }

    public void setPrenomDemandeur(String prenomDemandeur) {
        this.prenomDemandeur = prenomDemandeur;
    }

    public String getTelephoneDemandeur() {
        return telephoneDemandeur;
    }

    public void setTelephoneDemandeur(String telephoneDemandeur) {
        this.telephoneDemandeur = telephoneDemandeur;
    }

    public String getEmailDemandeur() {
        return emailDemandeur;
    }

    public void setEmailDemandeur(String emailDemandeur) {
        this.emailDemandeur = emailDemandeur;
    }

    public String getIdTypeVisa() {
        return idTypeVisa;
    }

    public void setIdTypeVisa(String idTypeVisa) {
        this.idTypeVisa = idTypeVisa;
    }

    public String getLibelleTypeVisa() {
        return libelleTypeVisa;
    }

    public void setLibelleTypeVisa(String libelleTypeVisa) {
        this.libelleTypeVisa = libelleTypeVisa;
    }

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getLibelleCategorie() {
        return libelleCategorie;
    }

    public void setLibelleCategorie(String libelleCategorie) {
        this.libelleCategorie = libelleCategorie;
    }

    public String getIdPassport() {
        return idPassport;
    }

    public void setIdPassport(String idPassport) {
        this.idPassport = idPassport;
    }

    public String getNumeroPassport() {
        return numeroPassport;
    }

    public void setNumeroPassport(String numeroPassport) {
        this.numeroPassport = numeroPassport;
    }

    public String getIdVisaTransformable() {
        return idVisaTransformable;
    }

    public void setIdVisaTransformable(String idVisaTransformable) {
        this.idVisaTransformable = idVisaTransformable;
    }

    public String getRefVisa() {
        return refVisa;
    }

    public void setRefVisa(String refVisa) {
        this.refVisa = refVisa;
    }
}