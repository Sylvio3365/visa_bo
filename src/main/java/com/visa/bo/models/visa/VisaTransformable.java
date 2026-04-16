package com.visa.bo.models.visa;

import java.time.LocalDate;

import com.visa.bo.models.etatCivil.Demandeur;
import com.visa.bo.models.passport.Passport;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "visa_transformable")
public class VisaTransformable {
    @Id
    @Column(name = "id_visa_transformable", length = 50)
    private String idVisaTransformable;

    @Column(name = "ref_visa", nullable = false, length = 50, unique = true)
    private String refVisa;

    @Column(name = "date_debut", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "date_fin", nullable = false)
    private LocalDate dateFin;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_passport", nullable = false)
    private Passport passport;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_demandeur", nullable = false)
    private Demandeur demandeur;

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

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    public Passport getPassport() {
        return passport;
    }

    public void setPassport(Passport passport) {
        this.passport = passport;
    }

    public Demandeur getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(Demandeur demandeur) {
        this.demandeur = demandeur;
    }
}
