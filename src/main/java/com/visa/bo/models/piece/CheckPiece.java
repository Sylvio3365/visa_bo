package com.visa.bo.models.piece;

import java.time.LocalDate;

import com.visa.bo.models.demande.Demande;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;

@Entity
@Table(name = "check_piece")
public class CheckPiece {
    @EmbeddedId
    private CheckPieceId id;

    @ManyToOne(optional = false)
    @MapsId("idDemande")
    @JoinColumn(name = "id_demande", nullable = false)
    private Demande demande;

    @ManyToOne(optional = false)
    @MapsId("idPiece")
    @JoinColumn(name = "id_piece", nullable = false)
    private Piece piece;

    @Column(name = "est_fourni")
    private Boolean estFourni;

    @Column(name = "updated_at")
    private LocalDate updatedAt;

    public CheckPieceId getId() {
        return id;
    }

    public void setId(CheckPieceId id) {
        this.id = id;
    }

    public Demande getDemande() {
        return demande;
    }

    public void setDemande(Demande demande) {
        this.demande = demande;
    }

    public Piece getPiece() {
        return piece;
    }

    public void setPiece(Piece piece) {
        this.piece = piece;
    }

    public Boolean getEstFourni() {
        return estFourni;
    }

    public void setEstFourni(Boolean estFourni) {
        this.estFourni = estFourni;
    }

    public LocalDate getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDate updatedAt) {
        this.updatedAt = updatedAt;
    }
}
