package com.visa.bo.services.etatcivil;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.visa.bo.models.etatCivil.Nationalite;
import com.visa.bo.repositories.etatcivil.NationaliteRepository;

@Service
public class NationaliteService {

    @Autowired
    private NationaliteRepository nationaliteRepository;

    public List<Nationalite> findAll() {
        return nationaliteRepository.findAll();
    }
}
