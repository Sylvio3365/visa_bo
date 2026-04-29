package com.visa.bo.dto.demande;

import java.util.ArrayList;
import java.util.List;

import com.visa.bo.models.etatCivil.Demandeur;
import com.visa.bo.models.passport.Passport;
import com.visa.bo.models.visa.CarteResidence;
import com.visa.bo.models.visa.Visa;
import com.visa.bo.models.visa.VisaTransformable;

// Classe pour encapsuler les résultats de recherche
public class DemandeurSearchResult {
    private boolean found = false;
    private Demandeur demandeur;
    private Passport lastPassport;
    private VisaTransformable lastVisaTransformable;
    private Visa lastVisa;
    private CarteResidence lastCarteResidence;
    private List<Visa> visas = new ArrayList<>();

    public List<Visa> getVisas() {
        return visas;
    }

    public void setVisas(List<Visa> visas) {
        this.visas = visas;
    }

    public boolean isFound() {
        return found;
    }

    public void setFound(boolean found) {
        this.found = found;
    }

    public Demandeur getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(Demandeur demandeur) {
        this.demandeur = demandeur;
    }

    public Passport getLastPassport() {
        return lastPassport;
    }

    public void setLastPassport(Passport lastPassport) {
        this.lastPassport = lastPassport;
    }

    public VisaTransformable getLastVisaTransformable() {
        return lastVisaTransformable;
    }

    public void setLastVisaTransformable(VisaTransformable lastVisaTransformable) {
        this.lastVisaTransformable = lastVisaTransformable;
    }

    public Visa getLastVisa() {
        return lastVisa;
    }

    public void setLastVisa(Visa lastVisa) {
        this.lastVisa = lastVisa;
    }

    public CarteResidence getLastCarteResidence() {
        return lastCarteResidence;
    }

    public void setLastCarteResidence(CarteResidence lastCarteResidence) {
        this.lastCarteResidence = lastCarteResidence;
    }
}
