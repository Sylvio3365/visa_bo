package com.visa.bo.services.piece;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.visa.bo.models.piece.Piece;
import com.visa.bo.repositories.piece.PieceRepository;

@Service
public class PieceService {

    @Autowired
    private PieceRepository pieceRepository;

    public List<Piece> findAllPieceCommune() {
        return pieceRepository.findAllPieceCommune();
    }

    public List<Piece> findByIdTypeVisa(String idTypeVisa) {
        return pieceRepository.findByIdTypeVisa(idTypeVisa);
    }

    public List<Piece> findByIds(List<String> ids) {
        if (ids == null || ids.isEmpty()) {
            return new java.util.ArrayList<>();
        }
        return pieceRepository.findByIdPieceIn(ids);
    }
}
