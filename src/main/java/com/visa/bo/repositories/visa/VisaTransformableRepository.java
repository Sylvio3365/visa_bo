package com.visa.bo.repositories.visa;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.visa.bo.models.visa.VisaTransformable;

public interface VisaTransformableRepository extends JpaRepository<VisaTransformable, String> {

    @Query("SELECT v FROM VisaTransformable v WHERE v.refVisa = :refVisa AND v.passport.idPassport = :idPassport AND v.demandeur.idDemandeur = :idDemandeur")
    Optional<VisaTransformable> findByRefVisaAndIdPassportAndIdDemandeur(@Param("refVisa") String refVisa, @Param("idPassport") String idPassport, @Param("idDemandeur") String idDemandeur);

}
