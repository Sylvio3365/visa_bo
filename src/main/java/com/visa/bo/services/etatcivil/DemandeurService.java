package com.visa.bo.services.etatcivil;

import com.visa.bo.repositories.passport.PassportRepository;
import com.visa.bo.repositories.visa.VisaTransformableRepository;
import com.visa.bo.repositories.visa.TypeVisaRepository;
import com.visa.bo.repositories.demande.CategorieDemandeRepository;
import com.visa.bo.repositories.demande.DemandeRepository;
import com.visa.bo.repositories.demande.StatutDemandeRepository;
import com.visa.bo.repositories.demande.StatutRepository;
import com.visa.bo.repositories.piece.PieceRepository;
import com.visa.bo.repositories.piece.CheckPieceRepository;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.visa.bo.dto.demande.DemandeForm;
import com.visa.bo.exceptions.ValidationException;
import com.visa.bo.models.etatCivil.Demandeur;
import com.visa.bo.models.etatCivil.Nationalite;
import com.visa.bo.models.etatCivil.SituationFamille;
import com.visa.bo.models.demande.CategorieDemande;
import com.visa.bo.models.demande.Demande;
import com.visa.bo.models.demande.Statut;
import com.visa.bo.models.demande.StatutDemande;
import com.visa.bo.models.passport.Passport;
import com.visa.bo.models.piece.Piece;
import com.visa.bo.models.piece.CheckPiece;
import com.visa.bo.models.piece.CheckPieceId;
import com.visa.bo.models.visa.VisaTransformable;
import com.visa.bo.models.visa.TypeVisa;
import com.visa.bo.repositories.etatcivil.DemandeurRepository;
import com.visa.bo.repositories.etatcivil.NationaliteRepository;
import com.visa.bo.repositories.etatcivil.SituationFamilleRepository;
import com.visa.bo.services.demande.ChampsValidationService;

@Service
public class DemandeurService {

    private final PassportRepository passportRepository;
    private final VisaTransformableRepository visaTransformableRepository;

    @Autowired
    private DemandeurRepository demandeurRepository;

    @Autowired
    private NationaliteRepository nationaliteRepository;

    @Autowired
    private SituationFamilleRepository situationFamilleRepository;

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private ChampsValidationService champsValidationService;

    @Autowired
    private CategorieDemandeRepository categorieDemandeRepository;

    @Autowired
    private TypeVisaRepository typeVisaRepository;

    @Autowired
    private StatutDemandeRepository statutDemandeRepository;

    @Autowired
    private StatutRepository statutRepository;

    @Autowired
    private PieceRepository pieceRepository;

    @Autowired
    private CheckPieceRepository checkPieceRepository;

    DemandeurService(PassportRepository passportRepository, VisaTransformableRepository visaTransformableRepository) {
        this.passportRepository = passportRepository;
        this.visaTransformableRepository = visaTransformableRepository;
    }

    public Optional<Demandeur> findById(String idDemandeur) {
        return demandeurRepository.findById(idDemandeur);
    }

    @Transactional
    public void creerNouveauTitre(DemandeForm dm) {

        List<String> validation = champsValidationService.validateRequiredFields(dm);

        if (!validation.isEmpty()) {
            throw new ValidationException(validation);
        }

        // Déterminer le statut à utiliser :
        // - Si createdFromSearch = true (recherche infructueuse) → "visa approuvé"
        // - Sinon → "dossier cree"
        boolean isCreatedFromSearch = dm.isCreatedFromSearch();

        // Traitement du demandeur
        Demandeur demandeur = creerOuRechercharDemandeur(dm);
        dm.setIdDemandeur(demandeur.getIdDemandeur());

        // Traitement du passport
        Passport passport = creerOuRechercharPassport(dm, demandeur);
        dm.setIdPassport(passport.getIdPassport());

        // Traitement du visa transformable
        VisaTransformable visaTransformable = creerOuRechercharVisaTransformable(dm, demandeur, passport);
        dm.setIdVisaTransformable(visaTransformable.getIdVisaTransformable());

        // Création de la demande
        Demande demande = creerDemande(dm, demandeur, passport, visaTransformable);
        dm.setIdDemande(demande.getIdDemande());

        // Vérification et insertion des pièces communes
        verifierEtInsererPiecesCommunces(dm, demande);

        // Vérification et insertion des pièces complémentaires
        verifierEtInsererPiecesComplementaires(dm, demande);

        // Création du statut demande
        creerStatutDemande(demande, isCreatedFromSearch);

        // Créer automatiquement une demande de catégorie si elle existe
        if (dm.getDemandCategory() != null && !dm.getDemandCategory().isBlank()) {
            creerDemandeCategorie(demande, dm.getDemandCategory());
        }
    }

    private void creerDemandeCategorie(Demande nouvelleDemandeParente, String category) {
        try {
            System.out.println("\n=== CRÉATION DEMANDE CATÉGORIE START ===");
            System.out.println("Parent ID: " + nouvelleDemandeParente.getIdDemande());
            System.out.println("Category: " + category);

            String idCategorie;
            if ("duplicata".equalsIgnoreCase(category)) {
                idCategorie = "CD000002"; // Duplicata
            } else if ("transfert-visa".equalsIgnoreCase(category)) {
                idCategorie = "CD000003"; // Transfert de Visa
            } else {
                System.out.println("❌ Catégorie inconnue: " + category);
                return;
            }

            System.out.println("✓ Catégorie ID: " + idCategorie);

            Optional<CategorieDemande> categorieOpt = categorieDemandeRepository.findById(idCategorie);
            if (!categorieOpt.isPresent()) {
                System.out.println("❌ CategorieDemande non trouvée: " + idCategorie);
                return;
            }
            System.out.println("✓ CategorieDemande trouvée: " + categorieOpt.get().getLibelle());

            Demande demandeCategorie = new Demande();
            demandeCategorie.setIdDemande(Demande.nextId());
            System.out.println("✓ ID générée: " + demandeCategorie.getIdDemande());

            demandeCategorie.setCreatedAt(LocalDate.now());
            demandeCategorie.setUpdatedAt(LocalDate.now());
            demandeCategorie.setParentDemande(nouvelleDemandeParente);
            demandeCategorie.setCategorie(categorieOpt.get());
            demandeCategorie.setTypeVisa(nouvelleDemandeParente.getTypeVisa());
            demandeCategorie.setDemandeur(nouvelleDemandeParente.getDemandeur());
            demandeCategorie.setPassport(nouvelleDemandeParente.getPassport());
            demandeCategorie.setVisaTransformable(nouvelleDemandeParente.getVisaTransformable());

            System.out.println("→ Sauvegarde en cours...");
            demandeRepository.save(demandeCategorie);
            System.out.println("✓ Demande catégorie créée: " + demandeCategorie.getIdDemande());

            System.out.println("→ Création du statut...");
            creerStatutDemande(demandeCategorie, false);
            System.out.println("✓ Statut de la demande catégorie créé (nouvelle demande)");

            System.out.println("✅ CRÉATION DEMANDE CATÉGORIE SUCCESS");
            System.out.println("Demande catégorie finalisée: " + demandeCategorie.getIdDemande() + " pour catégorie: " + category);
            System.out.println("=== CRÉATION DEMANDE CATÉGORIE END ===\n");
        } catch (Exception e) {
            System.out.println("❌ ERREUR lors de la création de la demande catégorie");
            System.out.println("Message: " + e.getMessage());
            System.out.println("Cause: " + (e.getCause() != null ? e.getCause().getMessage() : "N/A"));
            e.printStackTrace();
            System.out.println("=== CRÉATION DEMANDE CATÉGORIE FAILED ===\n");
        }
    }

    private Demandeur creerOuRechercharDemandeur(DemandeForm dm) {
        String idDemandeur = dm.getIdDemandeur();
        System.out.println("====>>>>> " + idDemandeur);
        Demandeur demandeur;

        // Chercher ou créer le demandeur
        if (idDemandeur != null && !idDemandeur.isBlank()) {
            demandeur = demandeurRepository.findById(idDemandeur).orElseThrow(
                    () -> new IllegalArgumentException("Demandeur introuvable: " + idDemandeur));
        } else {
            demandeur = new Demandeur();
            demandeur.setIdDemandeur(Demandeur.nextId());
            demandeur.setCreatedAt(LocalDate.now());
        }

        // Valider et charger les références
        if (dm.getIdNationalite() == null || dm.getIdNationalite().isBlank()) {
            throw new IllegalArgumentException("Nationalite non sélectionnée");
        }
        if (dm.getIdSituationFamille() == null || dm.getIdSituationFamille().isBlank()) {
            throw new IllegalArgumentException("Situation familiale non sélectionnée");
        }

        Optional<Nationalite> nationaliteOpt = nationaliteRepository.findById(dm.getIdNationalite());
        if (!nationaliteOpt.isPresent()) {
            throw new IllegalArgumentException("Nationalite introuvable: " + dm.getIdNationalite());
        }
        Nationalite nationalite = nationaliteOpt.get();

        Optional<SituationFamille> situationFamilleOpt = situationFamilleRepository
                .findById(dm.getIdSituationFamille());
        if (!situationFamilleOpt.isPresent()) {
            throw new IllegalArgumentException("Situation familiale introuvable: " + dm.getIdSituationFamille());
        }
        SituationFamille situationFamille = situationFamilleOpt.get();

        // Mapper tous les champs
        demandeur.setNom(dm.getNom());
        demandeur.setPrenom(dm.getPrenom());
        demandeur.setNomJeuneFille(dm.getNomJeuneFille());
        demandeur.setDtn(dm.getDtn());
        demandeur.setAdresseMada(dm.getAdresseMada());
        demandeur.setTelephone(dm.getTelephone());
        demandeur.setEmail(dm.getEmail());
        demandeur.setNationalite(nationalite);
        demandeur.setSituationFamille(situationFamille);
        demandeur.setUpdatedAt(LocalDate.now());

        // Persister et synchroniser l'ID
        demandeurRepository.save(demandeur);
        return demandeur;
    }

    private Passport creerOuRechercharPassport(DemandeForm dm, Demandeur demandeur) {
        if (dm.getIdPassport() != null && !dm.getIdPassport().isBlank()) {
            Optional<Passport> passportExistantOpt = passportRepository.findById(dm.getIdPassport());
            if (passportExistantOpt.isPresent()) {
                Passport passportExistant = passportExistantOpt.get();

                // Si le numero change, on cree un nouveau passport rattache au demandeur.
                if (dm.getNumPassport() != null && !dm.getNumPassport().equals(passportExistant.getNumero())) {
                    verifierNumeroPassportUnique(dm.getNumPassport(), null);
                    Passport nouveauPassport = new Passport();
                    nouveauPassport.setIdPassport(Passport.nextId());
                    nouveauPassport.setNumero(dm.getNumPassport());
                    nouveauPassport.setDelivreLe(dm.getDateDelivrancePassport());
                    nouveauPassport.setExpireLe(dm.getDateExpirationPassport());
                    nouveauPassport.setDemandeur(demandeur);
                    return sauvegarderPassport(nouveauPassport);
                }

                return passportExistant;
            }
            // ID en session devenu invalide (ex: rollback). On l'ignore et on recree/recherche proprement.
            dm.setIdPassport(null);
        }

        verifierNumeroPassportUnique(dm.getNumPassport(), null);
        Passport passport = new Passport();
        passport.setIdPassport(Passport.nextId());
        passport.setNumero(dm.getNumPassport());
        passport.setDelivreLe(dm.getDateDelivrancePassport());
        passport.setExpireLe(dm.getDateExpirationPassport());
        passport.setDemandeur(demandeur);
        return sauvegarderPassport(passport);
    }

    private VisaTransformable creerOuRechercharVisaTransformable(DemandeForm dm, Demandeur demandeur,
            Passport passport) {
        if (dm.getIdVisaTransformable() != null && !dm.getIdVisaTransformable().isBlank()) {
            Optional<VisaTransformable> visaTransformableExistantOpt = visaTransformableRepository
                    .findById(dm.getIdVisaTransformable());
            if (visaTransformableExistantOpt.isPresent()) {
                VisaTransformable visaTransformableExistant = visaTransformableExistantOpt.get();

                // Si la reference change, on cree un nouveau visa transformable.
                if (dm.getRefVisa() != null && !dm.getRefVisa().equals(visaTransformableExistant.getRefVisa())) {
                    verifierRefVisaUnique(dm.getRefVisa(), null);
                    VisaTransformable nouveauVisaTransformable = new VisaTransformable();
                    nouveauVisaTransformable.setIdVisaTransformable(VisaTransformable.nextId());
                    nouveauVisaTransformable.setRefVisa(dm.getRefVisa());
                    nouveauVisaTransformable.setDateDebut(dm.getDateDebut());
                    nouveauVisaTransformable.setDateFin(dm.getDateFin());
                    nouveauVisaTransformable.setPassport(passport);
                    nouveauVisaTransformable.setDemandeur(demandeur);
                    return sauvegarderVisaTransformable(nouveauVisaTransformable);
                }

                return visaTransformableExistant;
            }

            // ID en session devenu invalide (ex: rollback). On l'ignore et on recree/recherche proprement.
            dm.setIdVisaTransformable(null);
        }

        verifierRefVisaUnique(dm.getRefVisa(), null);
        VisaTransformable visaTransformable = new VisaTransformable();
        visaTransformable.setIdVisaTransformable(VisaTransformable.nextId());
        visaTransformable.setRefVisa(dm.getRefVisa());
        visaTransformable.setDateDebut(dm.getDateDebut());
        visaTransformable.setDateFin(dm.getDateFin());
        visaTransformable.setPassport(passport);
        visaTransformable.setDemandeur(demandeur);
        return sauvegarderVisaTransformable(visaTransformable);
    }

    private void verifierNumeroPassportUnique(String numeroPassport, String currentPassportId) {
        if (numeroPassport == null || numeroPassport.isBlank()) {
            return;
        }

        Optional<Passport> existing = passportRepository.findByNumero(numeroPassport);
        if (existing.isPresent()
                && (currentPassportId == null || !existing.get().getIdPassport().equals(currentPassportId))) {
            throw new ValidationException("Le numero de passeport '" + numeroPassport + "' existe deja.");
        }
    }

    private void verifierRefVisaUnique(String refVisa, String currentVisaId) {
        if (refVisa == null || refVisa.isBlank()) {
            return;
        }

        Optional<VisaTransformable> existing = visaTransformableRepository.findByRefVisa(refVisa);
        if (existing.isPresent()
                && (currentVisaId == null || !existing.get().getIdVisaTransformable().equals(currentVisaId))) {
            throw new ValidationException("La reference visa '" + refVisa + "' existe deja.");
        }
    }

    private Passport sauvegarderPassport(Passport passport) {
        try {
            return passportRepository.save(passport);
        } catch (DataIntegrityViolationException ex) {
            throw new ValidationException("Le numero de passeport '" + passport.getNumero() + "' existe deja.");
        }
    }

    private VisaTransformable sauvegarderVisaTransformable(VisaTransformable visaTransformable) {
        try {
            return visaTransformableRepository.save(visaTransformable);
        } catch (DataIntegrityViolationException ex) {
            throw new ValidationException("La reference visa '" + visaTransformable.getRefVisa() + "' existe deja.");
        }
    }

    private Demande creerDemande(DemandeForm dm, Demandeur demandeur, Passport passport,
            VisaTransformable visaTransformable) {
        // Créer et insérer un objet de type Demande
        Demande demande = new Demande();
        demande.setIdDemande(Demande.nextId());
        demande.setDemandeur(demandeur);
        demande.setPassport(passport);
        demande.setVisaTransformable(visaTransformable);
        demande.setCreatedAt(LocalDate.now());
        demande.setUpdatedAt(LocalDate.now());

        // Charger la catégorie de demande
        if (dm.getIdTypeVisa() == null || dm.getIdTypeVisa().isBlank()) {
            throw new IllegalArgumentException("Type Visa non sélectionné");
        }

        CategorieDemande cd = categorieDemandeRepository.findById("CD000001").orElseThrow(
                () -> new IllegalArgumentException("Catégorie de demande 'CD000001' introuvable en base de données"));
        demande.setCategorie(cd);

        // Charger et assigner le type de visa
        Optional<TypeVisa> typeVisaOpt = typeVisaRepository.findById(dm.getIdTypeVisa());
        if (!typeVisaOpt.isPresent()) {
            throw new IllegalArgumentException("Type Visa introuvable: " + dm.getIdTypeVisa());
        }
        demande.setTypeVisa(typeVisaOpt.get());

        demandeRepository.save(demande);
        return demande;
    }

    private void verifierEtInsererPiecesCommunces(DemandeForm dm, Demande demande) {
        List<Piece> piecesCommunesAll = pieceRepository.findAllPieceCommune();
        Set<String> piecesFournies = new HashSet<>();
        List<String> erreurs = new java.util.ArrayList<>();

        if (dm.getPiecesCommunesIds() != null) {
            piecesFournies = new HashSet<>(Arrays.asList(dm.getPiecesCommunesIds()));
        }

        for (Piece piece : piecesCommunesAll) {
            boolean isFournie = piecesFournies.contains(piece.getIdPiece());

            // Accumuler les erreurs si la pièce est obligatoire et non fournie
            if (piece.isObligatoire() && !isFournie) {
                erreurs.add("Pièce commune obligatoire manquante: " + piece.getLibelle());
            }

            // Insérer dans check_piece
            CheckPieceId checkPieceId = new CheckPieceId();
            checkPieceId.setIdDemande(demande.getIdDemande());
            checkPieceId.setIdPiece(piece.getIdPiece());

            CheckPiece checkPiece = new CheckPiece();
            checkPiece.setId(checkPieceId);
            checkPiece.setDemande(demande);
            checkPiece.setPiece(piece);
            checkPiece.setEstFourni(isFournie);
            checkPiece.setUpdatedAt(LocalDate.now());
            checkPieceRepository.save(checkPiece);
        }

        // Lever l'exception avec toutes les erreurs accumulées
        if (!erreurs.isEmpty()) {
            throw new ValidationException(erreurs);
        }
    }

    private void verifierEtInsererPiecesComplementaires(DemandeForm dm, Demande demande) {
        List<String> erreurs = new java.util.ArrayList<>();

        // Vérifier que le type de visa est sélectionné
        if (dm.getIdTypeVisa() == null || dm.getIdTypeVisa().isBlank()) {
            erreurs.add("Type Visa non sélectionné pour les pièces complémentaires");
            throw new ValidationException(erreurs);
        }

        List<Piece> piecesComplementairesAll = pieceRepository.findByIdTypeVisa(dm.getIdTypeVisa());
        Set<String> piecesFournies = new HashSet<>();

        if (dm.getPiecesComplementairesIds() != null) {
            piecesFournies = new HashSet<>(Arrays.asList(dm.getPiecesComplementairesIds()));
        }

        // Traiter les pièces complémentaires trouvées
        for (Piece piece : piecesComplementairesAll) {
            boolean isFournie = piecesFournies.contains(piece.getIdPiece());

            // Accumuler les erreurs si la pièce est obligatoire et non fournie
            if (piece.isObligatoire() && !isFournie) {
                erreurs.add("Pièce complémentaire obligatoire manquante: " + piece.getLibelle());
            }

            // Insérer dans check_piece (toutes les pièces, fournie ou non)
            CheckPieceId checkPieceId = new CheckPieceId();
            checkPieceId.setIdDemande(demande.getIdDemande());
            checkPieceId.setIdPiece(piece.getIdPiece());
            CheckPiece checkPiece = new CheckPiece();
            checkPiece.setId(checkPieceId);
            checkPiece.setDemande(demande);
            checkPiece.setPiece(piece);
            checkPiece.setEstFourni(isFournie);
            checkPiece.setUpdatedAt(LocalDate.now());
            checkPieceRepository.save(checkPiece);
        }

        // Lever l'exception avec toutes les erreurs accumulées
        if (!erreurs.isEmpty()) {
            throw new ValidationException(erreurs);
        }
    }

    public void creerStatutDemande(Demande demande, boolean isCreatedFromSearch) {
        String idStatut;
        
        // Si la demande vient d'une recherche infructueuse → "visa approuvé"
        // Sinon → "dossier cree"
        if (isCreatedFromSearch) {
            // "visa approve" - ST000003
            idStatut = "ST000003";
        } else {
            // "dossier cree" - ST000001
            idStatut = "ST000001";
        }
        
        Statut statut = statutRepository.findById(idStatut).orElseThrow(
                () -> new IllegalArgumentException("Statut introuvable: " + idStatut));

        StatutDemande statutDemande = new StatutDemande();
        statutDemande.setIdStatutDemande(StatutDemande.nextId());
        statutDemande.setDemande(demande);
        statutDemande.setStatut(statut);
        statutDemande.setDate(LocalDate.now());
        statutDemandeRepository.save(statutDemande);
    }
}
