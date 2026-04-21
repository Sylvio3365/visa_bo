package com.visa.bo.controllers.demande;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.data.domain.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;
import com.visa.bo.dto.demande.DemandeForm;
import com.visa.bo.exceptions.ValidationException;
import com.visa.bo.models.demande.Demande;
import com.visa.bo.models.etatCivil.Demandeur;
import com.visa.bo.models.passport.Passport;
import com.visa.bo.models.piece.Piece;
import com.visa.bo.models.visa.TypeVisa;
import com.visa.bo.models.visa.VisaTransformable;
import com.visa.bo.services.demande.ChampsValidationService;
import com.visa.bo.services.demande.DemandeService;
import com.visa.bo.services.etatcivil.NationaliteService;
import com.visa.bo.services.etatcivil.SituationFamilleService;
import com.visa.bo.services.etatcivil.DemandeurService;
import com.visa.bo.services.piece.PieceService;
import com.visa.bo.services.passport.PassportService;
import com.visa.bo.services.visa.TypeVisaService;
import com.visa.bo.services.visa.VisaTransformableService;
import org.springframework.web.bind.annotation.ModelAttribute;

@Controller
@SessionAttributes("demandeForm")
public class DemandeController {

    private static final int DEFAULT_PAGE_SIZE = 10;
    private static final Set<Integer> ALLOWED_PAGE_SIZES = new HashSet<>(Arrays.asList(10, 20, 50, 100));
    private static final int SEARCH_FILTER_MAX_LENGTH = 100;

    @Autowired
    private NationaliteService nationaliteService;

    @Autowired
    private SituationFamilleService situationFamilleService;

    @Autowired
    private DemandeurService demandeurService;

    @Autowired
    private PieceService pieceService;

    @Autowired
    private PassportService passportService;

    @Autowired
    private TypeVisaService typeVisaService;

    @Autowired
    private VisaTransformableService visaTransformableService;

    @Autowired
    private ChampsValidationService champsValidationService;

    @Autowired
    private DemandeService demandeService;

    @ModelAttribute("demandeForm")
    public DemandeForm getDemandeForm() {
        return new DemandeForm();
    }

    @GetMapping("/demandes")
    public String demandesList(
            @RequestParam(value = "page", required = false) String pageParam,
            @RequestParam(value = "size", required = false) String sizeParam,
            @RequestParam(value = "status", required = false) String statusParam,
            @RequestParam(value = "search", required = false) String searchParam,
            @RequestParam(value = "startDate", required = false) String startDateParam,
            @RequestParam(value = "endDate", required = false) String endDateParam,
            @RequestParam(value = "typeVisa", required = false) String typeVisaParam,
            Model model) {
        int page = parsePositiveIntOrDefault(pageParam, 1);
        int size = parsePageSizeOrDefault(sizeParam);
        String rawStatusFilter = normalizeFilterParam(statusParam);
        String searchFilter = normalizeSearchFilter(searchParam);
        ParsedDateParam parsedStartDate = parseDateOrDefaultToday(startDateParam);
        ParsedDateParam parsedEndDate = parseDateOrDefaultToday(endDateParam);
        LocalDate startDate = parsedStartDate.getValue();
        LocalDate endDate = parsedEndDate.getValue();
        boolean dateRangeAdjusted = false;

        if (startDate.isAfter(endDate)) {
            LocalDate temp = startDate;
            startDate = endDate;
            endDate = temp;
            dateRangeAdjusted = true;
        }

        List<String> statusOptions = demandeService.findAvailableStatuses();
        List<TypeVisa> typeVisaOptions = typeVisaService.findAll();
        String statusFilter = resolveStatusFilter(rawStatusFilter, statusOptions);
        String rawTypeVisaFilter = normalizeFilterParam(typeVisaParam);
        String typeVisaFilter = resolveTypeVisaFilter(rawTypeVisaFilter, typeVisaOptions);
        String warningMessage = buildListWarningMessage(
            pageParam,
            sizeParam,
            rawStatusFilter,
            statusFilter,
            searchParam,
            searchFilter,
            parsedStartDate.isInvalid(),
            parsedEndDate.isInvalid(),
            dateRangeAdjusted,
            rawTypeVisaFilter,
            typeVisaFilter);

        Page<DemandeService.DemandeListItem> demandesPage = demandeService.findPaginatedDemandes(
            page,
            size,
            statusFilter,
            searchFilter,
            startDate,
            endDate,
            typeVisaFilter);

        if (demandesPage.getTotalPages() > 0 && page > demandesPage.getTotalPages()) {
            page = demandesPage.getTotalPages();
            demandesPage = demandeService.findPaginatedDemandes(
                page,
                size,
                statusFilter,
                searchFilter,
                startDate,
                endDate,
                typeVisaFilter);
            String outOfRangeWarning = "Numero de page hors limite, derniere page utilisee.";
            warningMessage = warningMessage == null ? outOfRangeWarning : warningMessage + " " + outOfRangeWarning;
        }

        setupview(model, "demande-list", "Liste des demandes", "/WEB-INF/jsp/pages/demande/demande-list.jsp");
        model.addAttribute("demandesPage", demandesPage);
        model.addAttribute("demandes", demandesPage.getContent());
        model.addAttribute("currentPage", demandesPage.getNumber() + 1);
        model.addAttribute("pageSize", demandesPage.getSize());
        model.addAttribute("pageSizeOptions", ALLOWED_PAGE_SIZES.stream().sorted().collect(Collectors.toList()));
        model.addAttribute("statusOptions", statusOptions);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("searchFilter", searchFilter);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("typeVisaFilter", typeVisaFilter);
        model.addAttribute("typeVisaOptions", typeVisaOptions);

        if (warningMessage != null) {
            model.addAttribute("warningMessage", warningMessage);
        }

        return "layout/main";
    }

    @GetMapping("/demandes/{idDemande}")
    public String demandeDetail(
            @PathVariable("idDemande") String idDemande,
            @RequestParam(value = "page", required = false) String pageParam,
            @RequestParam(value = "size", required = false) String sizeParam,
            @RequestParam(value = "status", required = false) String statusParam,
            @RequestParam(value = "search", required = false) String searchParam,
            @RequestParam(value = "startDate", required = false) String startDateParam,
            @RequestParam(value = "endDate", required = false) String endDateParam,
            @RequestParam(value = "typeVisa", required = false) String typeVisaParam,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (idDemande == null || idDemande.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Identifiant demande invalide.");
            return "redirect:/demandes";
        }

        Optional<DemandeService.DemandeDetail> demandeDetailOpt = demandeService.findDemandeDetail(idDemande);
        if (!demandeDetailOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Demande introuvable: " + idDemande);
            return "redirect:/demandes";
        }

        DemandeService.DemandeDetail demandeDetail = demandeDetailOpt.get();
        Demande demande = demandeDetail.getDemande();

        setupview(model, "demande-list", "Detail de la demande", "/WEB-INF/jsp/pages/demande/demande-details.jsp");
        model.addAttribute("demandeDetail", demandeDetail);
        model.addAttribute("demande", demande);
        model.addAttribute("demandeStatus", demandeDetail.getStatut());
        model.addAttribute("demandesBackUrl",
            buildDemandesBackUrl(pageParam, sizeParam, statusParam, searchParam, startDateParam, endDateParam,
                typeVisaParam));

        return "layout/main";
    }

    private int parsePositiveIntOrDefault(String rawValue, int defaultValue) {
        if (rawValue == null) {
            return defaultValue;
        }
        try {
            int value = Integer.parseInt(rawValue);
            return value > 0 ? value : defaultValue;
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    private int parsePageSizeOrDefault(String rawSize) {
        int parsed = parsePositiveIntOrDefault(rawSize, DEFAULT_PAGE_SIZE);
        return ALLOWED_PAGE_SIZES.contains(parsed) ? parsed : DEFAULT_PAGE_SIZE;
    }

    private String normalizeFilterParam(String rawValue) {
        if (rawValue == null) {
            return null;
        }
        String trimmed = rawValue.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String normalizeSearchFilter(String rawSearch) {
        String normalized = normalizeFilterParam(rawSearch);
        if (normalized == null) {
            return null;
        }
        if (normalized.length() > SEARCH_FILTER_MAX_LENGTH) {
            return normalized.substring(0, SEARCH_FILTER_MAX_LENGTH);
        }
        return normalized;
    }

    private String resolveStatusFilter(String rawStatusFilter, List<String> statusOptions) {
        if (rawStatusFilter == null) {
            return null;
        }
        return statusOptions.stream()
                .filter(option -> option.equalsIgnoreCase(rawStatusFilter))
                .findFirst()
                .orElse(null);
    }

    private String resolveTypeVisaFilter(String rawTypeVisaFilter, List<TypeVisa> typeVisaOptions) {
        if (rawTypeVisaFilter == null) {
            return null;
        }
        return typeVisaOptions.stream()
                .map(TypeVisa::getIdTypeVisa)
                .filter(option -> option != null && option.equalsIgnoreCase(rawTypeVisaFilter))
                .findFirst()
                .orElse(null);
    }

    private String buildListWarningMessage(String pageParam, String sizeParam, String rawStatusFilter,
            String resolvedStatusFilter, String rawSearch, String resolvedSearch, boolean invalidStartDate,
            boolean invalidEndDate, boolean dateRangeAdjusted, String rawTypeVisaFilter, String resolvedTypeVisaFilter) {
        StringBuilder warnings = new StringBuilder();

        if (pageParam != null && !isPositiveInteger(pageParam)) {
            warnings.append("Numero de page invalide, page 1 utilisee. ");
        }
        if (sizeParam != null && !isAllowedPageSize(sizeParam)) {
            warnings.append("Taille de page invalide, taille par defaut utilisee. ");
        }
        if (rawStatusFilter != null && resolvedStatusFilter == null) {
            warnings.append("Filtre statut invalide, filtre ignore. ");
        }
        if (rawSearch != null && resolvedSearch != null && rawSearch.trim().length() > SEARCH_FILTER_MAX_LENGTH) {
            warnings.append("Recherche tronquee a 100 caracteres. ");
        }
        if (invalidStartDate) {
            warnings.append("Date de debut invalide, date du jour utilisee. ");
        }
        if (invalidEndDate) {
            warnings.append("Date de fin invalide, date du jour utilisee. ");
        }
        if (dateRangeAdjusted) {
            warnings.append("Plage de dates invalide, dates reordonnees automatiquement. ");
        }
        if (rawTypeVisaFilter != null && resolvedTypeVisaFilter == null) {
            warnings.append("Filtre type visa invalide, filtre ignore. ");
        }

        String message = warnings.toString().trim();
        return message.isEmpty() ? null : message;
    }

    private ParsedDateParam parseDateOrDefaultToday(String rawValue) {
        LocalDate today = LocalDate.now();
        if (rawValue == null || rawValue.trim().isEmpty()) {
            return ParsedDateParam.valid(today);
        }

        try {
            return ParsedDateParam.valid(LocalDate.parse(rawValue.trim()));
        } catch (Exception ex) {
            return ParsedDateParam.invalid(today);
        }
    }

    private boolean isPositiveInteger(String rawValue) {
        try {
            return Integer.parseInt(rawValue) > 0;
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    private boolean isAllowedPageSize(String rawSize) {
        try {
            return ALLOWED_PAGE_SIZES.contains(Integer.parseInt(rawSize));
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    private String buildDemandesBackUrl(
            String pageParam,
            String sizeParam,
            String statusParam,
            String searchParam,
            String startDateParam,
            String endDateParam,
            String typeVisaParam) {
        int page = parsePositiveIntOrDefault(pageParam, 1);
        int size = parsePageSizeOrDefault(sizeParam);
        String statusFilter = normalizeFilterParam(statusParam);
        String searchFilter = normalizeSearchFilter(searchParam);
        String typeVisaFilter = normalizeFilterParam(typeVisaParam);
        LocalDate startDate = parseDateOrDefaultToday(startDateParam).getValue();
        LocalDate endDate = parseDateOrDefaultToday(endDateParam).getValue();

        if (startDate.isAfter(endDate)) {
            LocalDate temp = startDate;
            startDate = endDate;
            endDate = temp;
        }

        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("/demandes")
                .queryParam("page", page)
                .queryParam("size", size)
                .queryParam("startDate", startDate)
                .queryParam("endDate", endDate);

        if (statusFilter != null) {
            builder.queryParam("status", statusFilter);
        }
        if (searchFilter != null) {
            builder.queryParam("search", searchFilter);
        }
        if (typeVisaFilter != null) {
            builder.queryParam("typeVisa", typeVisaFilter);
        }

        return builder.toUriString();
    }

    private static class ParsedDateParam {
        private final LocalDate value;
        private final boolean invalid;

        private ParsedDateParam(LocalDate value, boolean invalid) {
            this.value = value;
            this.invalid = invalid;
        }

        static ParsedDateParam valid(LocalDate value) {
            return new ParsedDateParam(value, false);
        }

        static ParsedDateParam invalid(LocalDate value) {
            return new ParsedDateParam(value, true);
        }

        LocalDate getValue() {
            return value;
        }

        boolean isInvalid() {
            return invalid;
        }
    }

    @GetMapping("/demande/nouveau-titre")
    public String renderViewNouveauTitre(Model model) {
        DemandeForm form = new DemandeForm();
        model.addAttribute("demandeForm", form);
        setupview(model, "nouveau-titre", "Nouveau titre", "");
        return "redirect:/demande/etape1";
    }

    @GetMapping("/demande/rechercher-demandeur")
    public String rechercherDemandeur(@RequestParam String searchId,
            @ModelAttribute("demandeForm") DemandeForm form,
            RedirectAttributes redirectAttributes) {
        Optional<Demandeur> demandeurOpt = demandeurService.findById(searchId);

        if (demandeurOpt.isPresent()) {
            Demandeur demandeur = demandeurOpt.get();
            form.setIdDemandeur(demandeur.getIdDemandeur());
            form.setNom(demandeur.getNom());
            form.setPrenom(demandeur.getPrenom());
            form.setNomJeuneFille(demandeur.getNomJeuneFille());
            form.setDtn(demandeur.getDtn());
            form.setAdresseMada(demandeur.getAdresseMada());
            form.setTelephone(demandeur.getTelephone());
            form.setEmail(demandeur.getEmail());
            form.setIdNationalite(demandeur.getNationalite().getIdNationalite());
            form.setIdSituationFamille(demandeur.getSituationFamille().getIdSituationFamille());
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Demandeur non trouvé avec l'ID : " + searchId);
        }

        return "redirect:/demande/etape1";
    }

    @GetMapping("/demande/etape1")
    public String etape1(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/etape1.jsp";
        setupview(model, "nouveau-titre", "", pageActuel);
        form.setCurrentStep("Etat civil");
        model.addAttribute("currentStep", form.getCurrentStep());
        model.addAttribute("nationalites", nationaliteService.findAll());
        model.addAttribute("situation_familles", situationFamilleService.findAll());
        return "layout/main";
    }

    @PostMapping("/demande/etape1")
    public String saveEtape1(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam String nom,
            @RequestParam String prenom,
            @RequestParam String nomJeuneFille,
            @RequestParam String email,
            @RequestParam String telephone,
            @RequestParam String adresseMada,
            @RequestParam String dtn,
            @RequestParam String idNationalite,
            @RequestParam String idSituationFamille,
            RedirectAttributes redirectAttributes) {
        form.setNom(nom);
        form.setPrenom(prenom);
        form.setNomJeuneFille(nomJeuneFille);
        form.setEmail(email);
        form.setTelephone(telephone);
        form.setAdresseMada(adresseMada);
        form.setIdNationalite(idNationalite);
        form.setIdSituationFamille(idSituationFamille);

        try {
            if (dtn != null && dtn != "") {
                form.setDtn(LocalDate.parse(dtn));
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Date de naissance invalide.");
            return "redirect:/demande/etape1";
        }

        // List<String> validationErrors =
        // champsValidationService.validateRequiredFields(form);
        // if (!validationErrors.isEmpty()) {
        // redirectAttributes.addFlashAttribute("errorMessage", String.join("\\n",
        // validationErrors));
        // return "redirect:/demande/etape1";
        // }

        form.setCurrentStep("Passport");
        return "redirect:/demande/etape2";
    }

    @GetMapping("/demande/etape2")
    public String etape2(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/etape2.jsp";
        setupview(model, "nouveau-titre", "Nouvelle demande - Étape 2", pageActuel);
        form.setCurrentStep("Passport");
        model.addAttribute("currentStep", form.getCurrentStep());
        return "layout/main";
    }

    @GetMapping("/demande/rechercher-passport")
    public String rechercherPassport(@RequestParam String numPassport,
            @ModelAttribute("demandeForm") DemandeForm form,
            RedirectAttributes redirectAttributes) {
        Optional<Passport> passportOpt = passportService
                .findByNumeroAndIdDemandeur(numPassport, form.getIdDemandeur());

        if (passportOpt.isPresent()) {
            Passport passport = passportOpt.get();
            form.setIdPassport(passport.getIdPassport());
            form.setNumPassport(passport.getNumero());
            form.setDateDelivrancePassport(passport.getDelivreLe());
            form.setDateExpirationPassport(passport.getExpireLe());
        } else {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Passeport non trouvé avec le numéro : " + numPassport);
        }

        return "redirect:/demande/etape2";
    }

    @PostMapping("/demande/etape2")
    public String saveEtape2(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam String numPassport,
            @RequestParam String dateDelivrancePassport,
            @RequestParam String dateExpirationPassport) {
        form.setNumPassport(numPassport);
        if (dateDelivrancePassport != null && dateDelivrancePassport != "") {
            form.setDateDelivrancePassport(LocalDate.parse(dateDelivrancePassport));
        }
        if (dateExpirationPassport != null && dateExpirationPassport != "") {
            form.setDateExpirationPassport(LocalDate.parse(dateExpirationPassport));
        }
        form.setCurrentStep("Visa Transformable");
        return "redirect:/demande/etape3";
    }

    @GetMapping("/demande/etape3")
    public String etape3(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/etape3.jsp";
        setupview(model, "nouveau-titre", "Nouvelle demande - Étape 3", pageActuel);
        form.setCurrentStep("Visa Transformable");
        model.addAttribute("currentStep", form.getCurrentStep());
        return "layout/main";
    }

    @PostMapping("/demande/etape3")
    public String saveEtape3(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam String refVisa,
            @RequestParam String dateDebut,
            @RequestParam String dateFin) {
        form.setRefVisa(refVisa);
        if (dateDebut != null && dateDebut != "") {
            form.setDateDebut(LocalDate.parse(dateDebut));
        }
        if (dateFin != null && dateFin != "") {
            form.setDateFin(LocalDate.parse(dateFin));
        }
        form.setCurrentStep("Pieces");
        return "redirect:/demande/etape4";
    }

    @GetMapping("/demande/rechercher-visa-transformable")
    public String rechercherVisaTransformable(@RequestParam String refVisa,
            @ModelAttribute("demandeForm") DemandeForm form,
            RedirectAttributes redirectAttributes) {
        if (refVisa == null || refVisa.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Veuillez entrer une référence visa");
            return "redirect:/demande/etape3";
        }

        Optional<VisaTransformable> visaOpt = visaTransformableService
                .findByRefVisaAndIdPassportAndIdDemandeur(refVisa, form.getIdPassport(), form.getIdDemandeur());

        if (visaOpt.isPresent()) {
            VisaTransformable visa = visaOpt.get();
            form.setIdVisaTransformable(visa.getIdVisaTransformable());
            form.setRefVisa(visa.getRefVisa());
            form.setDateDebut(visa.getDateDebut());
            form.setDateFin(visa.getDateFin());
        } else {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Visa transformable non trouvé avec la référence : " + refVisa);
        }

        return "redirect:/demande/etape3";
    }

    @GetMapping("/demande/etape4")
    public String etape4(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/etape4.jsp";
        setupview(model, "nouveau-titre", "Nouvelle demande - Étape 4", pageActuel);
        form.setCurrentStep("Pieces");
        model.addAttribute("currentStep", form.getCurrentStep());
        model.addAttribute("piecesCommunas", pieceService.findAllPieceCommune());
        return "layout/main";
    }

    @PostMapping("/demande/etape4")
    public String saveEtape4(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam(value = "piecesCommunesIds", required = false) String[] piecesCommunesIds) {
        form.setPiecesCommunesIds(piecesCommunesIds);
        form.setCurrentStep("Type Visa");
        return "redirect:/demande/etape5";
    }

    @GetMapping("/demande/etape5")
    public String etape5(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/etape5.jsp";
        setupview(model, "nouveau-titre", "Nouvelle demande - Étape 5", pageActuel);
        form.setCurrentStep("Type Visa");
        model.addAttribute("currentStep", form.getCurrentStep());
        model.addAttribute("typesVisa", typeVisaService.findAll());
        return "layout/main";
    }

    @PostMapping("/demande/etape5")
    public String saveEtape5(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam String idTypeVisa) {
        form.setIdTypeVisa(idTypeVisa);
        form.setCurrentStep("Pieces Complementaires");
        return "redirect:/demande/etape6";
    }

    @GetMapping("/demande/etape6")
    public String etape6(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/etape6.jsp";
        setupview(model, "nouveau-titre", "Nouvelle demande - Étape 6", pageActuel);
        form.setCurrentStep("Pieces Complementaires");
        model.addAttribute("currentStep", form.getCurrentStep());
        model.addAttribute("piecesComplementaires", pieceService.findByIdTypeVisa(form.getIdTypeVisa()));
        return "layout/main";
    }

    @PostMapping("/demande/etape6")
    public String saveEtape6(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam(value = "piecesComplementairesIds", required = false) String[] piecesComplementairesIds) {
        form.setPiecesComplementairesIds(piecesComplementairesIds);
        form.setCurrentStep("complete");
        return "redirect:/demande/confirmation";
    }

    @GetMapping("/demande/confirmation")
    public String confirmation(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/confirmation.jsp";
        setupview(model, "nouveau-titre", "Confirmation", pageActuel);

        String typeVisaLibelle = typeVisaService.findAll().stream()
                .filter(tv -> tv.getIdTypeVisa().equals(form.getIdTypeVisa()))
                .map(tv -> tv.getLibelle())
                .findFirst()
                .orElse(form.getIdTypeVisa());

        Set<String> selectedPiecesCommunesIds = form.getPiecesCommunesIds() != null
                ? new HashSet<>(Arrays.asList(form.getPiecesCommunesIds()))
                : new HashSet<>();

        Set<String> selectedPiecesComplementairesIds = form.getPiecesComplementairesIds() != null
                ? new HashSet<>(Arrays.asList(form.getPiecesComplementairesIds()))
                : new HashSet<>();

        List<Piece> piecesCommunesAll = pieceService.findAllPieceCommune();
        List<Piece> piecesComplementairesAll = pieceService.findByIdTypeVisa(form.getIdTypeVisa());

        model.addAttribute("currentStep", "Confirmation");
        model.addAttribute("typeVisaLibelle", typeVisaLibelle);
        model.addAttribute("selectedPiecesCommunesIds", selectedPiecesCommunesIds);
        model.addAttribute("selectedPiecesComplementairesIds", selectedPiecesComplementairesIds);
        model.addAttribute("piecesCommunesAll", piecesCommunesAll);
        model.addAttribute("piecesComplementairesAll", piecesComplementairesAll);

        return "layout/main";
    }

    @GetMapping("/demande/terminer")
    public String terminer(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/submit.jsp";
        setupview(model, "nouveau-titre", "Nouvelle demande - Terminer", pageActuel);
        model.addAttribute("demandeForm", form);

        try {
            if (form.getIdDemandeur() != null && !form.getIdDemandeur().isBlank()) {
                Optional<Demandeur> demandeurCheck = demandeurService.findById(form.getIdDemandeur());
                if (!demandeurCheck.isPresent()) {
                    form.setIdDemandeur(null);
                }
            }

            demandeurService.creerNouveauTitre(form);
        } catch (ValidationException e) {
            model.addAttribute("validationErrors", e.getErrors());
            model.addAttribute("hasErrors", true);

            return "layout/main";
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("hasErrors", true);
            return "layout/main";
        }

        return "layout/main";
    }

    public void setupview(Model m, String activePage, String pageTitle, String pageActuel) {
        m.addAttribute("activePage", activePage);
        m.addAttribute("showBack", false);
        m.addAttribute("pageTitle", pageTitle);
        m.addAttribute("headerTitle", "Visa Backoffice");
        m.addAttribute("headerSubtitle", "Gestion des demandes");
        m.addAttribute("footerRight", "");
        m.addAttribute("backHref", "#");
        m.addAttribute("backLabel", "");
        m.addAttribute("contentPage", pageActuel);
    }

}
