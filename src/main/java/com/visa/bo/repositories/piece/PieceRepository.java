package com.visa.bo.repositories.piece;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.visa.bo.models.piece.Piece;
import java.util.List;

public interface PieceRepository extends JpaRepository<Piece, String> {

    @Query("SELECT p FROM Piece p WHERE p.typeVisa IS NULL")
    List<Piece> findAllPieceCommune();

    @Query("SELECT p FROM Piece p WHERE p.typeVisa.idTypeVisa = :idTypeVisa")
    List<Piece> findByIdTypeVisa(String idTypeVisa);

    List<Piece> findByIdPieceIn(List<String> ids);

}
