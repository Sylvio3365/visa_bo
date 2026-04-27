package com.visa.bo.services.visa;

import java.time.LocalDate;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.visa.bo.models.demande.Demande;
import com.visa.bo.models.visa.Visa;
import com.visa.bo.repositories.visa.VisaRepository;

@Service
public class VisaService {

    @Autowired
    private VisaRepository visaRepository;

    public Visa creerVisa(String refVisa, LocalDate dateDebut, LocalDate dateFin, Demande demande) {
        Visa visa = new Visa();
        visa.setIdVisa(Visa.nextId());
        visa.setRefVisa(refVisa);
        visa.setDateDebut(dateDebut);
        visa.setDateFin(dateFin);
        visa.setDemande(demande);
        visa.setPassport(demande.getPassport());
        return visaRepository.save(visa);
    }

    public Optional<Visa> findById(String id) {
        return visaRepository.findById(id);
    }
}
