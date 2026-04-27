package com.visa.bo.repositories.demande;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import com.visa.bo.models.demande.StatutDemande;

public interface StatutDemandeRepository extends JpaRepository<StatutDemande, String> {

    List<StatutDemande> findByDemandeIdDemandeOrderByDateDescIdStatutDemandeDesc(String idDemande);
}
