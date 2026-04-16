package com.visa.bo.models.passport;

import java.time.LocalDate;

import com.visa.bo.models.etatCivil.Demandeur;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "passport")
public class Passport {
    @Id
    @Column(name = "id_passport", length = 50)
    private String idPassport;

    @Column(name = "numero", nullable = false, length = 150, unique = true)
    private String numero;

    @Column(name = "delivre_le", nullable = false)
    private LocalDate delivreLe;

    @Column(name = "expire_le", nullable = false)
    private LocalDate expireLe;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_demandeur", nullable = false)
    private Demandeur demandeur;

    public String getIdPassport() {
        return idPassport;
    }

    public void setIdPassport(String idPassport) {
        this.idPassport = idPassport;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public LocalDate getDelivreLe() {
        return delivreLe;
    }

    public void setDelivreLe(LocalDate delivreLe) {
        this.delivreLe = delivreLe;
    }

    public LocalDate getExpireLe() {
        return expireLe;
    }

    public void setExpireLe(LocalDate expireLe) {
        this.expireLe = expireLe;
    }

    public Demandeur getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(Demandeur demandeur) {
        this.demandeur = demandeur;
    }
}
