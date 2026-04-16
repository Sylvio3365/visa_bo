package com.visa.bo.models.visa;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "piece")
public class Piece {
    @Id
    @Column(name = "id_piece", length = 50)
    private String idPiece;

    @Column(name = "libelle", nullable = false, length = 250)
    private String libelle;

    @ManyToOne
    @JoinColumn(name = "id_type_visa")
    private TypeVisa typeVisa;

    public String getIdPiece() {
        return idPiece;
    }

    public void setIdPiece(String idPiece) {
        this.idPiece = idPiece;
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
