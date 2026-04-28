package com.visa.bo.repositories.visa;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.visa.bo.models.visa.Visa;

public interface VisaRepository extends JpaRepository<Visa, String> {

    @Query(value = "SELECT v FROM Visa v WHERE v.passport.demandeur.idDemandeur = :idDemandeur ORDER BY v.dateDebut DESC")
    List<Visa> findByIdDemandeur(@Param("idDemandeur") String idDemandeur);

    @Query(value = "SELECT v FROM Visa v WHERE v.passport.idPassport = :idPassport ORDER BY v.dateDebut DESC")
    List<Visa> findByIdPassport(@Param("idPassport") String idPassport);
}
