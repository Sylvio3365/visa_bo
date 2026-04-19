package com.visa.bo.services.visa;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.visa.bo.models.visa.TypeVisa;
import com.visa.bo.repositories.visa.TypeVisaRepository;

@Service
public class TypeVisaService {

    @Autowired
    private TypeVisaRepository typeVisaRepository;

    public List<TypeVisa> findAll() {
        return typeVisaRepository.findAll();
    }
}
