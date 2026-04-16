package com.visa.bo.models.piece;

import java.io.Serializable;
import java.util.Objects;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

@Embeddable
public class CheckPieceId implements Serializable {
    @Column(name = "id_demande", length = 50)
    private String idDemande;

    @Column(name = "id_piece", length = 50)
    private String idPiece;

    public String getIdDemande() {
        return idDemande;
    }

    public void setIdDemande(String idDemande) {
        this.idDemande = idDemande;
    }

    public String getIdPiece() {
        return idPiece;
    }

    public void setIdPiece(String idPiece) {
        this.idPiece = idPiece;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        CheckPieceId that = (CheckPieceId) o;
        return Objects.equals(idDemande, that.idDemande)
            && Objects.equals(idPiece, that.idPiece);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idDemande, idPiece);
    }
}
