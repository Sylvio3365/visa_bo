package com.visa.bo.models;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;

@Entity
@Table(name = "check_piece_complementaire")
public class CheckPieceComplementaire {
    @EmbeddedId
    private CheckPieceComplementaireId id;

    @ManyToOne(optional = false)
    @MapsId("idDemandeResident")
    @JoinColumn(name = "id_demande_resident", nullable = false)
    private DemandeResident demandeResident;

    @ManyToOne(optional = false)
    @MapsId("idPieceComplementaire")
    @JoinColumn(name = "id_piece_complementaire", nullable = false)
    private PieceComplementaire pieceComplementaire;

    @Column(name = "est_fourni", nullable = false)
    private Boolean estFourni;

    public CheckPieceComplementaireId getId() {
        return id;
    }

    public void setId(CheckPieceComplementaireId id) {
        this.id = id;
    }

    public DemandeResident getDemandeResident() {
        return demandeResident;
    }

    public void setDemandeResident(DemandeResident demandeResident) {
        this.demandeResident = demandeResident;
    }

    public PieceComplementaire getPieceComplementaire() {
        return pieceComplementaire;
    }

    public void setPieceComplementaire(PieceComplementaire pieceComplementaire) {
        this.pieceComplementaire = pieceComplementaire;
    }

    public Boolean getEstFourni() {
        return estFourni;
    }

    public void setEstFourni(Boolean estFourni) {
        this.estFourni = estFourni;
    }
}
