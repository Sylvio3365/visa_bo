package com.visa.bo.repositories.demande;

import org.springframework.data.jpa.repository.JpaRepository;

import com.visa.bo.models.demande.Champs;

public interface ChampsRepository extends JpaRepository<Champs, String> {
}
