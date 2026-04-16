package com.visa.bo.models.visa;

import java.time.LocalDateTime;

import com.visa.bo.models.demande.Demande;
import com.visa.bo.models.passport.Passport;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "visa")
public class Visa {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("visa", "id_visa", "VS", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_visa", length = 50)
    private String idVisa;

    @Column(name = "ref_visa", nullable = false, length = 50, unique = true)
    private String refVisa;

    @Column(name = "date_debut", nullable = false)
    private LocalDateTime dateDebut;

    @Column(name = "date_fin", nullable = false)
    private LocalDateTime dateFin;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_passport", nullable = false)
    private Passport passport;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_demande", nullable = false)
    private Demande demande;

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

    public Passport getPassport() {
        return passport;
    }

    public void setPassport(Passport passport) {
        this.passport = passport;
    }

    public Demande getDemande() {
        return demande;
    }

    public void setDemande(Demande demande) {
        this.demande = demande;
    }
}
