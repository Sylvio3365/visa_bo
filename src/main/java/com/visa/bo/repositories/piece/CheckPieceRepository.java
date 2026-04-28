package com.visa.bo.repositories.piece;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.visa.bo.models.piece.CheckPiece;
import com.visa.bo.models.piece.CheckPieceId;
import java.util.List;

@Repository
public interface CheckPieceRepository extends JpaRepository<CheckPiece, CheckPieceId> {

    List<CheckPiece> findByDemandeIdDemande(String idDemande);

    List<CheckPiece> findByEstFourniTrue();

    List<CheckPiece> findByEstFourniFalse();

    void deleteByDemandeIdDemande(String idDemande);

}
