package com.visa.bo.config;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.visa.bo.models.demande.CategorieDemande;
import com.visa.bo.repositories.demande.CategorieDemandeRepository;

@ControllerAdvice
public class GlobalViewControllerAdvice {
    
    @Autowired
    private CategorieDemandeRepository categorieDemandeRepository;

    @ModelAttribute("categories")
    public List<CategorieDemande> getCategories() {
        return categorieDemandeRepository.findAll();
    }
}
