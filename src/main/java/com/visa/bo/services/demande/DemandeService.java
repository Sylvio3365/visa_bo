package com.visa.bo.services.demande;

import java.util.Optional;
import java.util.List;
import java.util.ArrayList;
import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.visa.bo.models.demande.Demande;
import com.visa.bo.models.piece.CheckPiece;
import com.visa.bo.repositories.demande.DemandeRepository;
import com.visa.bo.repositories.piece.CheckPieceRepository;

@Service
public class DemandeService {

    private static final int DEFAULT_PAGE_SIZE = 10;
    private static final int MAX_PAGE_SIZE = 100;

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private CheckPieceRepository checkPieceRepository;

    public Page<DemandeListItem> findPaginatedDemandes(
            int page,
            int size,
            String statusFilter,
            String searchFilter,
            LocalDate startDate,
            LocalDate endDate,
            String typeVisaFilter) {
        int safePage = Math.max(page, 1);
        int safeSize = size <= 0 ? DEFAULT_PAGE_SIZE : Math.min(size, MAX_PAGE_SIZE);

        Pageable pageable = PageRequest.of(safePage - 1, safeSize);
        return demandeRepository.findPageWithLatestStatus(
                pageable,
                normalizeFilterValue(statusFilter),
                normalizeFilterValue(searchFilter),
                startDate,
                endDate,
                normalizeFilterValue(typeVisaFilter))
                .map(item -> {
                    List<CheckPiece> checkPieces = checkPieceRepository.findByDemandeIdDemande(item.getDemande().getIdDemande());
                    List<PieceDetailItem> piecesList = buildPieceDetailList(checkPieces);
                    return new DemandeListItem(item.getDemande(), normalizeStatus(item.getStatut()), item.getIdStatut(), piecesList);
                });
    }

    private List<PieceDetailItem> buildPieceDetailList(List<CheckPiece> checkPieces) {
        List<PieceDetailItem> pieces = new ArrayList<>();
        for (CheckPiece checkPiece : checkPieces) {
            if (checkPiece.getPiece() == null) {
                continue;
            }
            pieces.add(new PieceDetailItem(
                    checkPiece.getPiece().getIdPiece(),
                    checkPiece.getPiece().getLibelle(),
                    checkPiece.getPiece().isObligatoire(),
                    Boolean.TRUE.equals(checkPiece.getEstFourni()),
                    Boolean.TRUE.equals(checkPiece.getEstUploade()),
                    checkPiece.getCheminDocument()));
        }
        return pieces;
    }

    public List<String> findAvailableStatuses() {
        return demandeRepository.findDistinctStatusLabels();
    }

    public Optional<DemandeDetail> findDemandeDetail(String idDemande) {
        if (idDemande == null || idDemande.trim().isEmpty()) {
            return Optional.empty();
        }

        String normalizedId = idDemande.trim();
        Optional<Demande> demandeOpt = demandeRepository.findDetailedByIdDemande(normalizedId);
        if (!demandeOpt.isPresent()) {
            return Optional.empty();
        }

        String status = demandeRepository.findLatestStatusLabelByDemandeId(normalizedId)
                .map(this::normalizeStatus)
                .orElse("-");

        String idStatut = demandeRepository.findLatestStatusIdByDemandeId(normalizedId)
                .orElse(null);

        List<CheckPiece> checkPieces = checkPieceRepository.findByDemandeIdDemande(normalizedId);
        List<PieceDetailItem> piecesCommunes = new ArrayList<>();
        List<PieceDetailItem> piecesComplementaires = new ArrayList<>();

        for (CheckPiece checkPiece : checkPieces) {
            if (checkPiece.getPiece() == null) {
                continue;
            }

            PieceDetailItem item = new PieceDetailItem(
                    checkPiece.getPiece().getIdPiece(),
                    checkPiece.getPiece().getLibelle(),
                    checkPiece.getPiece().isObligatoire(),
                    Boolean.TRUE.equals(checkPiece.getEstFourni()),
                    Boolean.TRUE.equals(checkPiece.getEstUploade()),
                    checkPiece.getCheminDocument());

            if (checkPiece.getPiece().getTypeVisa() == null) {
                piecesCommunes.add(item);
            } else {
                piecesComplementaires.add(item);
            }
        }

        return Optional.of(new DemandeDetail(demandeOpt.get(), status, idStatut, piecesCommunes, piecesComplementaires));
    }

    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "-";
        }
        return status;
    }

    private String normalizeFilterValue(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    public static class DemandeListItem {
        private final Demande demande;
        private final String statut;
        private final String idStatut;
        private final List<PieceDetailItem> pieces;

        public DemandeListItem(Demande demande, String statut, String idStatut, List<PieceDetailItem> pieces) {
            this.demande = demande;
            this.statut = statut;
            this.idStatut = idStatut;
            this.pieces = pieces != null ? pieces : new ArrayList<>();
        }

        public Demande getDemande() {
            return demande;
        }

        public String getStatut() {
            return statut;
        }

        public String getIdStatut() {
            return idStatut;
        }

        public List<PieceDetailItem> getPieces() {
            return pieces;
        }

        public boolean isScanComplet() {
            if (pieces.isEmpty()) return false;
            return pieces.stream()
                    .filter(PieceDetailItem::isObligatoire)
                    .allMatch(PieceDetailItem::isUploade);
        }
    }

    public static class DemandeDetail {
        private final Demande demande;
        private final String statut;
        private final String idStatut;
        private final List<PieceDetailItem> piecesCommunes;
        private final List<PieceDetailItem> piecesComplementaires;

        public DemandeDetail(Demande demande, String statut, String idStatut, List<PieceDetailItem> piecesCommunes,
                List<PieceDetailItem> piecesComplementaires) {
            this.demande = demande;
            this.statut = statut;
            this.idStatut = idStatut;
            this.piecesCommunes = piecesCommunes;
            this.piecesComplementaires = piecesComplementaires;
        }

        public Demande getDemande() {
            return demande;
        }

        public String getStatut() {
            return statut;
        }

        public String getIdStatut() {
            return idStatut;
        }

        public List<PieceDetailItem> getPiecesCommunes() {
            return piecesCommunes;
        }

        public List<PieceDetailItem> getPiecesComplementaires() {
            return piecesComplementaires;
        }

        public boolean isScanComplet() {
            List<PieceDetailItem> all = new ArrayList<>(piecesCommunes);
            all.addAll(piecesComplementaires);
            if (all.isEmpty()) return false;
            return all.stream()
                    .filter(PieceDetailItem::isObligatoire)
                    .allMatch(PieceDetailItem::isUploade);
        }
    }

    public static class PieceDetailItem {
        private final String idPiece;
        private final String libelle;
        private final boolean obligatoire;
        private final boolean fourni;
        private final boolean uploade;
        private final String chemin;

        public PieceDetailItem(String idPiece, String libelle, boolean obligatoire, boolean fourni, boolean uploade, String chemin) {
            this.idPiece = idPiece;
            this.libelle = libelle;
            this.obligatoire = obligatoire;
            this.fourni = fourni;
            this.uploade = uploade;
            this.chemin = chemin;
        }

        public String getIdPiece() {
            return idPiece;
        }

        public String getLibelle() {
            return libelle;
        }

        public boolean isObligatoire() {
            return obligatoire;
        }

        public boolean isFourni() {
            return fourni;
        }

        public boolean isUploade() {
            return uploade;
        }

        public String getChemin() {
            return chemin;
        }
    }

    public Optional<Demande> findById(String idDemande) {
        return demandeRepository.findById(idDemande);
    }
}
