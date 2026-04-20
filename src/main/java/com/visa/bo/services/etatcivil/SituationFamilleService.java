package com.visa.bo.services.etatcivil;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.visa.bo.models.etatCivil.SituationFamille;
import com.visa.bo.repositories.etatcivil.SituationFamilleRepository;

@Service
public class SituationFamilleService {

    @Autowired
    SituationFamilleRepository situationFamilleRepository;

    public List<SituationFamille> findAll() {
        return situationFamilleRepository.findAll();
    }
}
