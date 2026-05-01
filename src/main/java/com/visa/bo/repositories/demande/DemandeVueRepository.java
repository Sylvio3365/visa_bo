package com.visa.bo.repositories.demande;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.visa.bo.models.demande.DemandeVue;

public interface DemandeVueRepository extends JpaRepository<DemandeVue, String> {

    Optional<DemandeVue> findByIdDemande(String idDemande);

    List<DemandeVue> findByIdDemandeur(String idDemandeur);

    List<DemandeVue> findByNumeroPassport(String numeroPassport);
}