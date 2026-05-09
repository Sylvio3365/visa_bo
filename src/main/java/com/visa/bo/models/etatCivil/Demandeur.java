package com.visa.bo.models.etatCivil;

import java.time.LocalDate;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.visa.bo.models.ClassMapTable;
import com.visa.bo.models.passport.Passport;

@Entity
@Table(name = "demandeur")
public class Demandeur {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("demandeur", "id_demandeur", "DEM", 6) {
    };

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_demandeur", length = 50)
    private String idDemandeur;

    @Column(name = "nom", length = 250)
    private String nom;

    @Column(name = "prenom", length = 250)
    private String prenom;

    @Column(name = "nom_jeune_fille", length = 50)
    private String nomJeuneFille;

    @Column(name = "dtn")
    private LocalDate dtn;

    @Column(name = "adresse_mada", length = 250)
    private String adresseMada;

    @Column(name = "telephone", length = 50)
    private String telephone;

    @Column(name = "email", length = 50)
    private String email;

    @Column(name = "created_at")
    private LocalDate createdAt;

    @Column(name = "updated_at")
    private LocalDate updatedAt;

    @Column(name = "photo", columnDefinition = "TEXT")
    private String photo;

    @Column(name = "signature", columnDefinition = "TEXT")
    private String signature;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_nationalite", nullable = false)
    private Nationalite nationalite;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_situation_famille", nullable = false)
    private SituationFamille situationFamille;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_genre", nullable = false)
    private Genre genre;

    @OneToMany(mappedBy = "demandeur")
    @JsonIgnore
    private List<Passport> passports;

    public String getIdDemandeur() {
        return idDemandeur;
    }

    public void setIdDemandeur(String idDemandeur) {
        this.idDemandeur = idDemandeur;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getNomJeuneFille() {
        return nomJeuneFille;
    }

    public void setNomJeuneFille(String nomJeuneFille) {
        this.nomJeuneFille = nomJeuneFille;
    }

    public LocalDate getDtn() {
        return dtn;
    }

    public void setDtn(LocalDate dtn) {
        this.dtn = dtn;
    }

    public String getAdresseMada() {
        return adresseMada;
    }

    public void setAdresseMada(String adresseMada) {
        this.adresseMada = adresseMada;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    public Nationalite getNationalite() {
        return nationalite;
    }

    public void setNationalite(Nationalite nationalite) {
        this.nationalite = nationalite;
    }

    public SituationFamille getSituationFamille() {
        return situationFamille;
    }

    public void setSituationFamille(SituationFamille situationFamille) {
        this.situationFamille = situationFamille;
    }

    public Genre getGenre() {
        return genre;
    }

    public void setGenre(Genre genre) {
        this.genre = genre;
    }
}
