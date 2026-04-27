package com.visa.bo.repositories.visa;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.visa.bo.models.visa.CarteResidence;

public interface CarteResidenceRepository extends JpaRepository<CarteResidence, String> {

    @Query(value = "SELECT c FROM CarteResidence c WHERE c.passport.demandeur.idDemandeur = :idDemandeur ORDER BY c.dateDebut DESC")
    List<CarteResidence> findByIdDemandeur(@Param("idDemandeur") String idDemandeur);
}
