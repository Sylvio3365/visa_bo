package com.visa.bo.services.passport;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.visa.bo.models.passport.Passport;
import com.visa.bo.repositories.passport.PassportRepository;

@Service
public class PassportService {

    @Autowired
    private PassportRepository passportRepository;

    public Optional<Passport> findByNumeroAndIdDemandeur(String numero, String idDemandeur) {
        return passportRepository.findByNumeroAndIdDemandeur(numero, idDemandeur);
    }
}
