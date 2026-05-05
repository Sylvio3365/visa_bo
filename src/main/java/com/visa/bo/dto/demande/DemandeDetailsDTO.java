package com.visa.bo.dto.demande;

import java.util.List;

import com.visa.bo.models.demande.DemandeVue;
import com.visa.bo.models.demande.StatutDemande;

public class DemandeDetailsDTO {
    private DemandeVue demande;
    private List<StatutDemande> statuts;

    public DemandeDetailsDTO() {
    }

    public DemandeDetailsDTO(DemandeVue demande, List<StatutDemande> statuts) {
        this.demande = demande;
        this.statuts = statuts;
    }

    public DemandeVue getDemande() {
        return demande;
    }

    public void setDemande(DemandeVue demande) {
        this.demande = demande;
    }

    public List<StatutDemande> getStatuts() {
        return statuts;
    }

    public void setStatuts(List<StatutDemande> statuts) {
        this.statuts = statuts;
    }
}