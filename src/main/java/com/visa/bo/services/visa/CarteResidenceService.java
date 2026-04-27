package com.visa.bo.services.visa;

import java.time.LocalDate;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.visa.bo.models.demande.Demande;
import com.visa.bo.models.visa.CarteResidence;
import com.visa.bo.repositories.visa.CarteResidenceRepository;

@Service
public class CarteResidenceService {

    @Autowired
    private CarteResidenceRepository carteResidenceRepository;

    public CarteResidence creerCarteResidence(String refCarteResidence, LocalDate dateDebut, LocalDate dateFin, Demande demande) {
        CarteResidence carteResidence = new CarteResidence();
        carteResidence.setIdCarteResidence(CarteResidence.nextId());
        carteResidence.setRefCarteResidence(refCarteResidence);
        carteResidence.setDateDebut(dateDebut);
        carteResidence.setDateFin(dateFin);
        carteResidence.setDemande(demande);
        carteResidence.setPassport(demande.getPassport());
        return carteResidenceRepository.save(carteResidence);
    }

    public Optional<CarteResidence> findById(String id) {
        return carteResidenceRepository.findById(id);
    }
}
