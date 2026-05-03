package com.visa.bo.api.demande;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Page;

import com.visa.bo.dto.api.ApiResponseDTO;
import com.visa.bo.models.demande.DemandeVue;
import com.visa.bo.services.demande.DemandeService;

@RestController
@RequestMapping("/api/demandes")
public class DemandeApi {

    @Autowired
    private DemandeService demandeService;

    @GetMapping
    public ApiResponseDTO<Page<DemandeVue>> getDemandes(
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "7") int size) {
        try {
            Page<DemandeVue> demandes;

            if (search != null && !search.isBlank()) {
                demandes = demandeService.getDemandesResume(search, page, size);
            } else {
                demandes = demandeService.getDemandesResumeDate(date, page, size);
            }

            if (demandes.isEmpty()) {
                return ApiResponseDTO.success("Aucune demande trouvée", null);
            }

            return ApiResponseDTO.success("Demandes récupérées avec succès", demandes);

        } catch (Exception e) {
            return ApiResponseDTO.error(e.getMessage());
        }
    }

}