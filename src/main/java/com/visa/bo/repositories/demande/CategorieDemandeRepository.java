package com.visa.bo.repositories.demande;

import org.springframework.data.jpa.repository.JpaRepository;

import com.visa.bo.models.demande.CategorieDemande;

public interface CategorieDemandeRepository extends JpaRepository<CategorieDemande, String> {

}
