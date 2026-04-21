package com.visa.bo.services.demande;

import java.util.Optional;
import java.util.List;
import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.visa.bo.models.demande.Demande;
import com.visa.bo.repositories.demande.DemandeRepository;

@Service
public class DemandeService {

    private static final int DEFAULT_PAGE_SIZE = 10;
    private static final int MAX_PAGE_SIZE = 100;

    @Autowired
    private DemandeRepository demandeRepository;

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
                .map(item -> new DemandeListItem(item.getDemande(), normalizeStatus(item.getStatut())));
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

        return Optional.of(new DemandeDetail(demandeOpt.get(), status));
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

        public DemandeListItem(Demande demande, String statut) {
            this.demande = demande;
            this.statut = statut;
        }

        public Demande getDemande() {
            return demande;
        }

        public String getStatut() {
            return statut;
        }
    }

    public static class DemandeDetail {
        private final Demande demande;
        private final String statut;

        public DemandeDetail(Demande demande, String statut) {
            this.demande = demande;
            this.statut = statut;
        }

        public Demande getDemande() {
            return demande;
        }

        public String getStatut() {
            return statut;
        }
    }
}
