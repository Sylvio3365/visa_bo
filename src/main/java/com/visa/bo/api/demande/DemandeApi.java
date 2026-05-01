package com.visa.bo.api.demande;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.visa.bo.dto.api.ApiResponseDTO;
import com.visa.bo.dto.demande.DemandeDTO;
import com.visa.bo.models.demande.DemandeVue;
import com.visa.bo.services.demande.DemandeService;

@RestController
@RequestMapping("/api/demandes")
public class DemandeApi {

    @Autowired
    private DemandeService demandeService;

    @GetMapping("/search/{value}")
    public ApiResponseDTO<List<DemandeVue>> getDemandesByPassportOrIdDemande(
            @PathVariable String value) {
        List<DemandeVue> demandes = new ArrayList<>();
        try {
            demandes = demandeService.getDemandesResume(value);
            if (demandes.isEmpty()) {
                return ApiResponseDTO.success("Aucune demande trouvée",null);
            }
        } catch (Exception e) {
            return ApiResponseDTO.error(e.getMessage());
        }
        return ApiResponseDTO.success("Demandes récupérées avec succès", demandes);
    }
}