package com.visa.bo.models.visa;

import java.time.LocalDate;
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
@Table(name = "carte_residence")
public class CarteResidence {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("carte_residence", "id_carte_residence", "CR", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_carte_residence", length = 50)
    private String idCarteResidence;

    @Column(name = "ref_carte_residence", length = 50, unique = true)
    private String refCarteResidence;

    @Column(name = "date_debut", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "date_fin", nullable = false)
    private LocalDate dateFin;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_passport", nullable = false)
    private Passport passport;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_demande", nullable = false)
    private Demande demande;

    public String getIdCarteResidence() {
        return idCarteResidence;
    }

    public void setIdCarteResidence(String idCarteResidence) {
        this.idCarteResidence = idCarteResidence;
    }

    public String getRefCarteResidence() {
        return refCarteResidence;
    }

    public void setRefCarteResidence(String refCarteResidence) {
        this.refCarteResidence = refCarteResidence;
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

    public Demande getDemande() {
        return demande;
    }

    public void setDemande(Demande demande) {
        this.demande = demande;
    }
}
