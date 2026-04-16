package com.visa.bo.models.demande;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "statut_demande")
public class StatutDemande {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("statut_demande", "id_statut_demande", "SD", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_statut_demande", length = 50)
    private String idStatutDemande;

    @Column(name = "date_", nullable = false)
    private LocalDate date;

    @ManyToOne
    @JoinColumn(name = "id_statut")
    private Statut statut;

    @ManyToOne
    @JoinColumn(name = "id_demande")
    private Demande demande;

    public String getIdStatutDemande() {
        return idStatutDemande;
    }

    public void setIdStatutDemande(String idStatutDemande) {
        this.idStatutDemande = idStatutDemande;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }

    public Demande getDemande() {
        return demande;
    }

    public void setDemande(Demande demande) {
        this.demande = demande;
    }
}
