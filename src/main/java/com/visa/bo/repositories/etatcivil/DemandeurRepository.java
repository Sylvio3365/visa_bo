package com.visa.bo.repositories.etatcivil;

import org.springframework.data.jpa.repository.JpaRepository;

import com.visa.bo.models.etatCivil.Demandeur;

public interface DemandeurRepository extends JpaRepository<Demandeur, String> {

}
