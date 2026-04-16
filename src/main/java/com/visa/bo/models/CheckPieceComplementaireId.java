package com.visa.bo.models;

import java.io.Serializable;
import java.util.Objects;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

@Embeddable
public class CheckPieceComplementaireId implements Serializable {
    @Column(name = "id_demande_resident", length = 50)
    private String idDemandeResident;

    @Column(name = "id_piece_complementaire", length = 50)
    private String idPieceComplementaire;

    public String getIdDemandeResident() {
        return idDemandeResident;
    }

    public void setIdDemandeResident(String idDemandeResident) {
        this.idDemandeResident = idDemandeResident;
    }

    public String getIdPieceComplementaire() {
        return idPieceComplementaire;
    }

    public void setIdPieceComplementaire(String idPieceComplementaire) {
        this.idPieceComplementaire = idPieceComplementaire;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        CheckPieceComplementaireId that = (CheckPieceComplementaireId) o;
        return Objects.equals(idDemandeResident, that.idDemandeResident)
            && Objects.equals(idPieceComplementaire, that.idPieceComplementaire);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idDemandeResident, idPieceComplementaire);
    }
}
