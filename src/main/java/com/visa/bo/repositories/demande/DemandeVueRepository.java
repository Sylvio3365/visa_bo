package com.visa.bo.repositories.demande;

import java.util.List;
import java.util.Optional;
import java.time.LocalDate;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.visa.bo.models.demande.DemandeVue;

public interface DemandeVueRepository extends JpaRepository<DemandeVue, String> {

    Optional<DemandeVue> findByIdDemande(String idDemande);

    List<DemandeVue> findByIdDemandeur(String idDemandeur);

    List<DemandeVue> findByNumeroPassport(String numeroPassport);

    List<DemandeVue> findByCreatedAt(LocalDate date);

    Page<DemandeVue> findByIdDemandeur(String idDemandeur, Pageable pageable);

    Page<DemandeVue> findByNumeroPassport(String numeroPassport, Pageable pageable);

    Page<DemandeVue> findByCreatedAt(LocalDate createdAt, Pageable pageable);
    
}