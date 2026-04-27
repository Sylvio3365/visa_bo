package com.visa.bo.controllers.demande;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.visa.bo.models.demande.StatutDemande;
import com.visa.bo.services.demande.DemandeService;
import java.util.Optional;

@Controller
@RequestMapping("/demandes")
public class DemandeHistoriqueController {

    @Autowired
    private DemandeService demandeService;

    @GetMapping("/{id}/historique")
    public String voirHistorique(@PathVariable("id") String idDemande, Model model) {
        List<StatutDemande> historique = demandeService.findStatutHistory(idDemande);
        Optional<DemandeService.DemandeDetail> detail = demandeService.findDemandeDetail(idDemande);
        
        model.addAttribute("idDemande", idDemande);
        model.addAttribute("historique", historique);
        detail.ifPresent(d -> model.addAttribute("demandeDetail", d));
        
        return "pages/demande/historique/statut";
    }
}
