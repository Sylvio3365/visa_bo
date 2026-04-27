package com.visa.bo.controllers.demande;

import org.springframework.stereotype.Controller;

import com.visa.bo.repositories.demande.CategorieDemandeRepository;

@Controller
public class CategorieDemandeController {
    private CategorieDemandeRepository categorieDemandeRepository;

    public CategorieDemandeController(CategorieDemandeRepository categorieDemandeRepository){
        this.categorieDemandeRepository = categorieDemandeRepository;
    }

    public String index() {
        return "redirect:/categorie-demande";
    }
}
