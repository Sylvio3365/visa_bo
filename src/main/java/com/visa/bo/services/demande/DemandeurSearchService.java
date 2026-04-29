package com.visa.bo.services.demande;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.visa.bo.dto.demande.DemandeurSearchResult;
import com.visa.bo.models.etatCivil.Demandeur;
import com.visa.bo.models.passport.Passport;
import com.visa.bo.models.visa.CarteResidence;
import com.visa.bo.models.visa.Visa;
import com.visa.bo.models.visa.VisaTransformable;
import com.visa.bo.repositories.etatcivil.DemandeurRepository;
import com.visa.bo.repositories.passport.PassportRepository;
import com.visa.bo.repositories.visa.CarteResidenceRepository;
import com.visa.bo.repositories.visa.VisaRepository;
import com.visa.bo.repositories.visa.VisaTransformableRepository;

@Service
public class DemandeurSearchService {

    @Autowired
    private PassportRepository passportRepository;

    @Autowired
    private VisaTransformableRepository visaTransformableRepository;

    @Autowired
    private VisaRepository visaRepository;

    @Autowired
    private CarteResidenceRepository carteResidenceRepository;

    @Autowired
    private DemandeurRepository demandeurRepository;

    public DemandeurSearchResult searchByPassportOrVisa(String searchNumber) {
        DemandeurSearchResult result = new DemandeurSearchResult();

        // Rechercher par numéro de passport
        Optional<Passport> passport = passportRepository.findByNumero(searchNumber);
        if (passport.isPresent()) {
            populateResult(result, passport.get().getDemandeur());
            return result;
        }

        // Rechercher par numéro de visa transformable
        Optional<VisaTransformable> visaTransformable = visaTransformableRepository.findByRefVisa(searchNumber);
        if (visaTransformable.isPresent()) {
            populateResult(result, visaTransformable.get().getDemandeur());
            return result;
        }

        // Aucun résultat trouvé
        result.setFound(false);
        return result;
    }

    private void populateResult(DemandeurSearchResult result, Demandeur demandeur) {
        result.setFound(true);
        result.setDemandeur(demandeur);

        // Dernier passport
        List<Passport> passports = passportRepository.findAll();
        Optional<Passport> lastPassport = passports.stream()
                .filter(p -> p.getDemandeur().getIdDemandeur().equals(demandeur.getIdDemandeur()))
                .max((p1, p2) -> p2.getDelivreLe().compareTo(p1.getDelivreLe()));
        lastPassport.ifPresent(result::setLastPassport);

        // Dernier visa transformable
        Optional<VisaTransformable> lastVisaTransformable = visaTransformableRepository.findAll().stream()
                .filter(v -> v.getDemandeur().getIdDemandeur().equals(demandeur.getIdDemandeur()))
                .max((v1, v2) -> v2.getDateDebut().compareTo(v1.getDateDebut()));
        lastVisaTransformable.ifPresent(result::setLastVisaTransformable);

        // Dernier visa
        Optional<Visa> lastVisa = visaRepository.findByIdDemandeur(demandeur.getIdDemandeur()).stream()
                .findFirst();
        lastVisa.ifPresent(result::setLastVisa);

        // Dernière carte de résidence
        Optional<CarteResidence> lastCarteResidence = carteResidenceRepository.findByIdDemandeur(demandeur.getIdDemandeur()).stream()
                .findFirst();
        lastCarteResidence.ifPresent(result::setLastCarteResidence);
    }

}
