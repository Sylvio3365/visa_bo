package com.visa.bo.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "piece_complementaire")
public class PieceComplementaire {
    @Id
    @Column(name = "id_piece_complementaire", length = 50)
    private String idPieceComplementaire;

    @Column(name = "libelle", nullable = false, length = 150)
    private String libelle;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_type_visa", nullable = false)
    private TypeVisa typeVisa;

    public String getIdPieceComplementaire() {
        return idPieceComplementaire;
    }

    public void setIdPieceComplementaire(String idPieceComplementaire) {
        this.idPieceComplementaire = idPieceComplementaire;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public TypeVisa getTypeVisa() {
        return typeVisa;
    }

    public void setTypeVisa(TypeVisa typeVisa) {
        this.typeVisa = typeVisa;
    }
}
