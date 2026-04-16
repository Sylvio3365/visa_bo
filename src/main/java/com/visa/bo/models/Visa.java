package com.visa.bo.models;

import java.time.LocalDate;
import java.time.LocalDateTime;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "visa")
public class Visa {
    @Id
    @Column(name = "id_visa", length = 50)
    private String idVisa;

    @Column(name = "ref_visa", nullable = false, length = 150, unique = true)
    private String refVisa;

    @Column(name = "date_debut", nullable = false)
    private LocalDateTime dateDebut;

    @Column(name = "date_fin", nullable = false)
    private LocalDateTime dateFin;

    @Column(name = "actif", nullable = false)
    private Integer actif;

    @Column(name = "date_", nullable = false)
    private LocalDate date;

    @Column(name = "origine", length = 50)
    private String origine;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_type_visa", nullable = false)
    private TypeVisa typeVisa;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_personne", nullable = false)
    private Personne personne;

    public String getIdVisa() {
        return idVisa;
    }

    public void setIdVisa(String idVisa) {
        this.idVisa = idVisa;
    }

    public String getRefVisa() {
        return refVisa;
    }

    public void setRefVisa(String refVisa) {
        this.refVisa = refVisa;
    }

    public LocalDateTime getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDateTime dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDateTime getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDateTime dateFin) {
        this.dateFin = dateFin;
    }

    public Integer getActif() {
        return actif;
    }

    public void setActif(Integer actif) {
        this.actif = actif;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getOrigine() {
        return origine;
    }

    public void setOrigine(String origine) {
        this.origine = origine;
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
