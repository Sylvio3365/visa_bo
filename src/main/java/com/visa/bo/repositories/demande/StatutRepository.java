package com.visa.bo.repositories.demande;

import org.springframework.data.jpa.repository.JpaRepository;

import com.visa.bo.models.demande.Statut;

public interface StatutRepository extends JpaRepository<Statut, String> {

}