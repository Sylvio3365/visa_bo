package com.visa.bo.dto.demande;

import java.time.LocalDate;
import lombok.Data;
import lombok.ToString;

@Data
@ToString(exclude = { "currentStep" })
public class DemandeForm {

    // etat civil
    private String idDemandeur;
    private String nom;
    private String prenom;
    private String adresseMada;
    private String nomJeuneFille;
    private String email;
    private String telephone;
    private LocalDate dtn;
    private String idNationalite;
    private String idSituationFamille;

    // passport
    private String idPassport;
    private String numPassport;
    private LocalDate dateDelivrancePassport;
    private LocalDate dateExpirationPassport;

    // visa transformable
    private String idVisaTransformable;
    private String refVisa;
    private LocalDate dateDebut;
    private LocalDate dateFin;

    // pieces communes
    private String[] piecesCommunesIds;

    // type visa
    private String idTypeVisa;

    // pieces complementaires
    private String[] piecesComplementairesIds;

    // demande
    private String idDemande;
    private String currentStep;
    private boolean createdFromSearch = false;
    
    // categorie (duplicata, transfert-visa, or null)
    private String demandCategory;

    // indique si les etapes 7/8 (visa + carte residence) sont requises
    private boolean needsVisaCarte = false;
    
    // visa (pour la page de création de visa)
    private String visaRefVisa;
    private LocalDate visaDateDebut;
    private LocalDate visaDateFin;
    
    // carte residence (pour la page de création de carte résidence)
    private String carteResidenceRef;
    private LocalDate carteResidenceDateDebut;
    private LocalDate carteResidenceDateFin;

}
