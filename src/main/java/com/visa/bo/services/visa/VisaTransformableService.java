package com.visa.bo.services.visa;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.visa.bo.models.visa.VisaTransformable;
import com.visa.bo.repositories.visa.VisaTransformableRepository;

@Service
public class VisaTransformableService {

    @Autowired
    private VisaTransformableRepository visaTransformableRepository;

    public Optional<VisaTransformable> findByRefVisaAndIdPassportAndIdDemandeur(String refVisa, String idPassport, String idDemandeur) {
        return visaTransformableRepository.findByRefVisaAndIdPassportAndIdDemandeur(refVisa, idPassport, idDemandeur);
    }
}
