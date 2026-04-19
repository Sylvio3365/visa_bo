package com.visa.bo.repositories.passport;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.visa.bo.models.passport.Passport;

public interface PassportRepository extends JpaRepository<Passport, String> {

    @Query("SELECT p FROM Passport p WHERE p.numero = :numero AND p.demandeur.idDemandeur = :idDemandeur")
    Optional<Passport> findByNumeroAndIdDemandeur(@Param("numero") String numero, @Param("idDemandeur") String idDemandeur);
}
