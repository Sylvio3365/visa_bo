package com.visa.bo.models.piece;

import com.visa.bo.models.visa.TypeVisa;

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

    @Column(name = "est_obligatoire", nullable = false)
    private Integer estObligatoire;

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

    public Integer getEstObligatoire() {
        return estObligatoire;
    }

    public void setEstObligatoire(Integer estObligatoire) {
        this.estObligatoire = estObligatoire;
    }

    public TypeVisa getTypeVisa() {
        return typeVisa;
    }

    public void setTypeVisa(TypeVisa typeVisa) {
        this.typeVisa = typeVisa;
    }
}
