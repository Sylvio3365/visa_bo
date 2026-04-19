package com.visa.bo.repositories.demande;

import org.springframework.data.jpa.repository.JpaRepository;

import com.visa.bo.models.demande.StatutDemande;

public interface StatutDemandeRepository extends JpaRepository<StatutDemande, String> {

}
