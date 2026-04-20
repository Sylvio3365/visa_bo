package com.visa.bo.repositories.demande;

import org.springframework.data.jpa.repository.JpaRepository;

import com.visa.bo.models.demande.Demande;

public interface DemandeRepository extends JpaRepository<Demande, String> {

}
