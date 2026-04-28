package com.visa.bo.controllers.demande;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
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
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;
import com.visa.bo.dto.demande.DemandeForm;
import com.visa.bo.exceptions.ValidationException;
import com.visa.bo.models.demande.Demande;
import com.visa.bo.models.etatCivil.Demandeur;
import com.visa.bo.models.passport.Passport;
import com.visa.bo.models.piece.Piece;
import com.visa.bo.models.piece.CheckPiece;
import com.visa.bo.models.visa.TypeVisa;
import com.visa.bo.models.visa.Visa;
import com.visa.bo.models.visa.VisaTransformable;
import com.visa.bo.repositories.demande.DemandeRepository;
import com.visa.bo.repositories.demande.StatutDemandeRepository;
import com.visa.bo.repositories.demande.StatutRepository;
import com.visa.bo.repositories.piece.CheckPieceRepository;
import com.visa.bo.services.demande.ChampsValidationService;
import com.visa.bo.services.demande.DemandeService;
import com.visa.bo.services.demande.DemandeurSearchService;
import com.visa.bo.services.etatcivil.NationaliteService;
import com.visa.bo.services.etatcivil.SituationFamilleService;
import com.visa.bo.services.etatcivil.DemandeurService;
import com.visa.bo.services.piece.PieceService;
import com.visa.bo.services.passport.PassportService;
import com.visa.bo.services.visa.TypeVisaService;
import com.visa.bo.services.visa.VisaTransformableService;
import com.visa.bo.services.visa.VisaService;
import com.visa.bo.services.visa.CarteResidenceService;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Value;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import java.net.MalformedURLException;

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

    @Autowired
    private DemandeurSearchService demandeurSearchService;

    @Autowired
    private VisaService visaService;

    @Autowired
    private CarteResidenceService carteResidenceService;

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private StatutRepository statutRepository;

    @Autowired
    private StatutDemandeRepository statutDemandeRepository;

    @Autowired
    private CheckPieceRepository checkPieceRepository;

    @Value("${upload.path:uploads/documents}")
    private String uploadPath;

    @PostMapping("/demandes/upload-piece")
    public String uploadPiece(
            @RequestParam("idDemande") String idDemande,
            @RequestParam("idPiece") String idPiece,
            @RequestParam("file") MultipartFile file,
            RedirectAttributes redirectAttributes) {

        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Le fichier est vide.");
            return "redirect:/demandes/" + idDemande;
        }

        try {
            // 1. Créer le dossier s'il n'existe pas
            Path root = Paths.get(uploadPath);
            if (!Files.exists(root)) {
                Files.createDirectories(root);
            }

            // 2. Générer un nom unique
            String extension = "";
            String originalFilename = file.getOriginalFilename();
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = UUID.randomUUID().toString() + extension;
            Path destination = root.resolve(filename);

            // 3. Sauvegarder le fichier
            Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);

            // 4. Mettre à jour la base de données
            Optional<CheckPiece> checkPieceOpt = checkPieceRepository
                    .findById(new com.visa.bo.models.piece.CheckPieceId(idDemande, idPiece));
            if (checkPieceOpt.isPresent()) {
                CheckPiece cp = checkPieceOpt.get();
                cp.setEstUploade(true);
                cp.setCheminDocument(filename);
                cp.setUpdatedAt(LocalDate.now());
                checkPieceRepository.save(cp);

                redirectAttributes.addFlashAttribute("successMessage", "Document importe avec succes.");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Lien piece-demande introuvable.");
            }

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de l'upload : " + e.getMessage());
        }

        return "redirect:/demandes/" + idDemande;
    }

    @PostMapping("/demandes/valider-scan") 
    public String validerScan(
            @RequestParam("idDemande") String idDemande,
            RedirectAttributes redirectAttributes) {

        Optional<com.visa.bo.models.demande.Statut> statutOpt = statutRepository.findById("ST000002");
        if (statutOpt.isPresent()) {
            com.visa.bo.models.demande.StatutDemande nouveauStatut = new com.visa.bo.models.demande.StatutDemande();
            nouveauStatut.setIdStatutDemande(com.visa.bo.models.demande.StatutDemande.nextId());
            nouveauStatut.setDemande(demandeRepository.findById(idDemande).orElse(null));
            nouveauStatut.setStatut(statutOpt.get());
            nouveauStatut.setDate(LocalDate.now());
            statutDemandeRepository.save(nouveauStatut);
            redirectAttributes.addFlashAttribute("successMessage", "Statut mis a jour : Demande de.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Statut ST000002 introuvable.");
        }

        return "redirect:/demandes/" + idDemande;
    }

    @GetMapping(value = "/demandes/{idDemande}/qr", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> demandeQr(@PathVariable("idDemande") String idDemande) {
        byte[] imageBytes = demandeService.genererQr(idDemande);
        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_PNG)
                .body(imageBytes);
    }

    @GetMapping(value = "/demandes/{idDemande}/qr/download", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> downloadDemandeQr(@PathVariable("idDemande") String idDemande) {
        byte[] imageBytes = demandeService.genererQr(idDemande);
        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_PNG)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=demande-" + idDemande + "-qr.png")
                .body(imageBytes);
    }

    @GetMapping("/demandes/document/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> serveFile(@PathVariable String filename) {
        try {
            Path file = Paths.get(uploadPath).resolve(filename);
            Resource resource = new UrlResource(file.toUri());
            if (resource.exists() || resource.isReadable()) {
                String contentType = "application/octet-stream";
                try {
                    contentType = Files.probeContentType(file);
                } catch (IOException e) {
                    // fall back to default
                }

                return ResponseEntity.ok()
                        .contentType(MediaType.parseMediaType(contentType))
                        .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + resource.getFilename() + "\"")
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (MalformedURLException e) {
            return ResponseEntity.badRequest().build();
        }
    }

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
        model.addAttribute("piecesCommunes", demandeDetail.getPiecesCommunes());
        model.addAttribute("piecesComplementaires", demandeDetail.getPiecesComplementaires());
        model.addAttribute("isModifiable", true);
        model.addAttribute("demandesBackUrl",
                buildDemandesBackUrl(pageParam, sizeParam, statusParam, searchParam, startDateParam, endDateParam,
                        typeVisaParam));

        return "layout/main";
    }

    @GetMapping("/demandes/{idDemande}/modifier")
    public String modifierDemande(@PathVariable("idDemande") String idDemande, Model model,
            RedirectAttributes redirectAttributes) {
        Optional<Demande> demandeOpt = demandeRepository.findDetailedByIdDemande(idDemande);
        if (!demandeOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Demande introuvable");
            return "redirect:/demandes";
        }

        Demande d = demandeOpt.get();
        DemandeForm form = new DemandeForm();

        // Données Demandeur
        Demandeur dm = d.getDemandeur();
        if (dm != null) {
            form.setIdDemandeur(dm.getIdDemandeur());
            form.setNom(dm.getNom());
            form.setPrenom(dm.getPrenom());
            form.setNomJeuneFille(dm.getNomJeuneFille());
            form.setDtn(dm.getDtn());
            form.setEmail(dm.getEmail());
            form.setTelephone(dm.getTelephone());
            form.setAdresseMada(dm.getAdresseMada());
            if (dm.getNationalite() != null)
                form.setIdNationalite(dm.getNationalite().getIdNationalite());
            if (dm.getSituationFamille() != null)
                form.setIdSituationFamille(dm.getSituationFamille().getIdSituationFamille());
        }

        // Données Passport
        Passport p = d.getPassport();
        if (p != null) {
            form.setIdPassport(p.getIdPassport());
            form.setNumPassport(p.getNumero());
            form.setDateDelivrancePassport(p.getDelivreLe());
            form.setDateExpirationPassport(p.getExpireLe());
        }

        // Données Visa Transformable
        VisaTransformable vt = d.getVisaTransformable();
        if (vt != null) {
            form.setIdVisaTransformable(vt.getIdVisaTransformable());
            form.setRefVisa(vt.getRefVisa());
            form.setDateDebut(vt.getDateDebut());
            form.setDateFin(vt.getDateFin());
        }

        // Type Visa
        if (d.getTypeVisa() != null) {
            form.setIdTypeVisa(d.getTypeVisa().getIdTypeVisa());
        }

        // Pieces
        List<CheckPiece> checks = checkPieceRepository.findByDemandeIdDemande(idDemande);
        List<String> communes = new ArrayList<>();
        List<String> complements = new ArrayList<>();
        for (CheckPiece cp : checks) {
            if (cp.getEstFourni() != null && cp.getEstFourni() && cp.getPiece() != null) {
                if (cp.getPiece().getTypeVisa() == null)
                    communes.add(cp.getPiece().getIdPiece());
                else
                    complements.add(cp.getPiece().getIdPiece());
            }
        }
        form.setPiecesCommunesIds(communes.toArray(new String[0]));
        form.setPiecesComplementairesIds(complements.toArray(new String[0]));

        form.setIdDemande(idDemande);
        form.setCurrentStep("1");
        form.setCreatedFromSearch(false); // Ce n'est pas une recherche infructueuse, c'est une modif
        form.setDemandCategory(d.getCategorie() != null ? d.getCategorie().getLibelle() : null);

        redirectAttributes.addFlashAttribute("demandeForm", form);
        return "redirect:/demande/etape1";
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
            boolean invalidEndDate, boolean dateRangeAdjusted, String rawTypeVisaFilter,
            String resolvedTypeVisaFilter) {
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

    // Pages de recherche et redirection pour Duplicata et Transfert
    @GetMapping("/demande/Duplicata")
    public String duplicata(Model model) {
        setupview(model, "demande", "Recherche demandeur - Duplicata",
                "/WEB-INF/jsp/pages/demande/recherche-demandeur.jsp");
        model.addAttribute("operationType", "duplicata");
        return "layout/main";
    }

    @GetMapping("/demande/Transfert-de-visa")
    public String transfertVisa(Model model) {
        setupview(model, "demande", "Recherche demandeur - Transfert de visa",
                "/WEB-INF/jsp/pages/demande/recherche-demandeur.jsp");
        model.addAttribute("operationType", "transfert-visa");
        return "layout/main";
    }

    @GetMapping("/demande/recherche-demandeur")
    public String searchDemandeur(@RequestParam String searchNumber,
            @RequestParam(required = false) String operationType,
            Model model) {
        if (searchNumber == null || searchNumber.trim().isEmpty()) {
            model.addAttribute("errorMessage", "Veuillez entrer un numéro de passport ou de visa");
            setupview(model, "demande", "Recherche demandeur", "/WEB-INF/jsp/pages/demande/recherche-demandeur.jsp");
            model.addAttribute("operationType", operationType != null ? operationType : "");
            return "layout/main";
        }

        DemandeurSearchService.DemandeurSearchResult searchResult = demandeurSearchService
                .searchByPassportOrVisa(searchNumber.trim());

        boolean needsVisaCarte = false;
        if ("duplicata".equalsIgnoreCase(operationType) || "transfert-visa".equalsIgnoreCase(operationType)) {
            needsVisaCarte = !searchResult.isFound();
        }

        setupview(model, "demande", "Résultats de recherche", "/WEB-INF/jsp/pages/demande/recherche-demandeur.jsp");
        model.addAttribute("searchResult", searchResult);
        model.addAttribute("searchNumber", searchNumber);
        model.addAttribute("operationType", operationType != null ? operationType : "");
        model.addAttribute("needsVisaCarte", needsVisaCarte);

        return "layout/main";
    }

    @GetMapping("/demande/creer-categorie")
    public String creerCategorieDirecte(@RequestParam String idDemandeur,
            @RequestParam String type,
            @RequestParam(value = "visaId", required = false) String visaId,
            RedirectAttributes redirectAttributes,
            SessionStatus sessionStatus) {
        if (idDemandeur == null || idDemandeur.isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Identifiant demandeur invalide.");
            return "redirect:/demandes";
        }
        if (type == null || type.isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Catégorie invalide.");
            return "redirect:/demandes";
        }

        Optional<Demande> sourceDemandeOpt = Optional.empty();

        if (visaId != null && !visaId.isBlank()) {
            Optional<Visa> visaOpt = visaService.findById(visaId);
            if (visaOpt.isPresent() && visaOpt.get().getDemande() != null) {
                String demandeId = visaOpt.get().getDemande().getIdDemande();
                sourceDemandeOpt = demandeRepository.findDetailedByIdDemande(demandeId);
                if (!sourceDemandeOpt.isPresent()) {
                    sourceDemandeOpt = Optional.of(visaOpt.get().getDemande());
                }
            }
        }

        if (!sourceDemandeOpt.isPresent()) {
            sourceDemandeOpt = demandeRepository
                    .findTopByDemandeurIdDemandeurOrderByCreatedAtDescIdDemandeDesc(idDemandeur);
        }

        if (!sourceDemandeOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Aucune demande existante pour ce demandeur.");
            return "redirect:/demande/Nouvelle-demande?idDemandeur=" + idDemandeur + "&type=" + type;
        }

        Demande lastDemande = sourceDemandeOpt.get();
        DemandeForm form = new DemandeForm();

        if (lastDemande.getDemandeur() != null) {
            Demandeur demandeur = lastDemande.getDemandeur();
            form.setIdDemandeur(demandeur.getIdDemandeur());
            form.setNom(demandeur.getNom());
            form.setPrenom(demandeur.getPrenom());
            form.setNomJeuneFille(demandeur.getNomJeuneFille());
            form.setDtn(demandeur.getDtn());
            form.setAdresseMada(demandeur.getAdresseMada());
            form.setTelephone(demandeur.getTelephone());
            form.setEmail(demandeur.getEmail());
            if (demandeur.getNationalite() != null) {
                form.setIdNationalite(demandeur.getNationalite().getIdNationalite());
            }
            if (demandeur.getSituationFamille() != null) {
                form.setIdSituationFamille(demandeur.getSituationFamille().getIdSituationFamille());
            }
        }

        if (lastDemande.getPassport() != null) {
            Passport passport = lastDemande.getPassport();
            form.setIdPassport(passport.getIdPassport());
            form.setNumPassport(passport.getNumero());
            form.setDateDelivrancePassport(passport.getDelivreLe());
            form.setDateExpirationPassport(passport.getExpireLe());
        }

        if (visaId != null && !visaId.isBlank()) {
            Optional<Visa> visaOpt = visaService.findById(visaId);
            if (visaOpt.isPresent()) {
                Visa visa = visaOpt.get();
                form.setRefVisa(visa.getRefVisa());
                form.setDateDebut(visa.getDateDebut());
                form.setDateFin(visa.getDateFin());
                if (visa.getPassport() != null) {
                    form.setIdPassport(visa.getPassport().getIdPassport());
                    form.setNumPassport(visa.getPassport().getNumero());
                    form.setDateDelivrancePassport(visa.getPassport().getDelivreLe());
                    form.setDateExpirationPassport(visa.getPassport().getExpireLe());
                }
            }
        } else if (lastDemande.getVisaTransformable() != null) {
            VisaTransformable visaTransformable = lastDemande.getVisaTransformable();
            form.setIdVisaTransformable(visaTransformable.getIdVisaTransformable());
            form.setRefVisa(visaTransformable.getRefVisa());
            form.setDateDebut(visaTransformable.getDateDebut());
            form.setDateFin(visaTransformable.getDateFin());
        }

        if (lastDemande.getTypeVisa() != null) {
            form.setIdTypeVisa(lastDemande.getTypeVisa().getIdTypeVisa());
        }

        List<CheckPiece> checkPieces = checkPieceRepository.findByDemandeIdDemande(lastDemande.getIdDemande());
        List<String> piecesCommunesIds = new ArrayList<>();
        List<String> piecesComplementairesIds = new ArrayList<>();
        for (CheckPiece checkPiece : checkPieces) {
            if (!Boolean.TRUE.equals(checkPiece.getEstFourni()) || checkPiece.getPiece() == null) {
                continue;
            }
            if (checkPiece.getPiece().getTypeVisa() == null) {
                piecesCommunesIds.add(checkPiece.getPiece().getIdPiece());
            } else {
                piecesComplementairesIds.add(checkPiece.getPiece().getIdPiece());
            }
        }
        if (!piecesCommunesIds.isEmpty()) {
            form.setPiecesCommunesIds(piecesCommunesIds.toArray(new String[0]));
        }
        if (!piecesComplementairesIds.isEmpty()) {
            form.setPiecesComplementairesIds(piecesComplementairesIds.toArray(new String[0]));
        }

        form.setDemandCategory(type);
        form.setNeedsVisaCarte(false);
        form.setCreatedFromSearch(false);

        try {
            demandeurService.creerNouveauTitre(form);
            sessionStatus.setComplete();
            return "redirect:/demandes/" + form.getIdDemande();
        } catch (ValidationException e) {
            redirectAttributes.addFlashAttribute("validationErrors", e.getErrors());
            redirectAttributes.addFlashAttribute("hasErrors", true);
            return "redirect:/demandes";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur: " + e.getMessage());
            return "redirect:/demandes";
        }
    }

    @GetMapping("/demande/Nouvelle-demande")
    public String renderViewNouveauTitre(
            @RequestParam(value = "idDemandeur", required = false) String idDemandeur,
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "createdFromSearch", required = false) String createdFromSearch,
            @RequestParam(value = "needsVisaCarte", required = false) String needsVisaCarte,
            Model model) {
        DemandeForm form = new DemandeForm();

        if (idDemandeur != null && !idDemandeur.isBlank()) {
            form.setIdDemandeur(idDemandeur);
        }

        if (type != null && !type.isBlank()) {
            form.setDemandCategory(type);
        }

        boolean requireVisaCarte = "true".equalsIgnoreCase(needsVisaCarte);
        form.setNeedsVisaCarte(requireVisaCarte);

        if ("true".equalsIgnoreCase(createdFromSearch) || requireVisaCarte) {
            form.setCreatedFromSearch(true);
        }

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
        if (form.getIdDemande() != null && !form.getIdDemande().isBlank()) {
            model.addAttribute("isModification", true);
        }
        model.addAttribute("currentStep", form.getCurrentStep());
        model.addAttribute("nationalites", nationaliteService.findAll());
        model.addAttribute("situation_familles", situationFamilleService.findAll());
        addRequiredFieldMap(model, "nom", "prenom", "nomJeuneFille", "dtn", "email", "telephone",
                "idNationalite", "idSituationFamille", "adresseMada");
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
        addRequiredFieldMap(model, "numPassport", "dateDelivrancePassport", "dateExpirationPassport");
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
        addRequiredFieldMap(model, "refVisa", "dateDebut", "dateFin");
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
        addRequiredFieldMap(model, "idTypeVisa");
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

    @GetMapping("/demande/etape7")
    public String etape7(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/etape7.jsp";
        setupview(model, "nouveau-titre", "Nouvelle demande - Créer Visa", pageActuel);
        form.setCurrentStep("Visa");
        model.addAttribute("currentStep", form.getCurrentStep());
        return "layout/main";
    }

    @PostMapping("/demande/etape7")
    public String saveEtape7(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam String visaRefVisa,
            @RequestParam String visaDateDebut,
            @RequestParam String visaDateFin) {
        form.setVisaRefVisa(visaRefVisa);
        form.setVisaDateDebut(LocalDate.parse(visaDateDebut));
        form.setVisaDateFin(LocalDate.parse(visaDateFin));
        form.setCurrentStep("CarteResidence");
        return "redirect:/demande/etape8";
    }

    @GetMapping("/demande/etape8")
    public String etape8(Model model, @ModelAttribute("demandeForm") DemandeForm form) {
        String pageActuel = "/WEB-INF/jsp/pages/demande/nouveautitre/etape8.jsp";
        setupview(model, "nouveau-titre", "Nouvelle demande - Créer Carte Résidence", pageActuel);
        form.setCurrentStep("CarteResidence");
        model.addAttribute("currentStep", form.getCurrentStep());
        return "layout/main";
    }

    @PostMapping("/demande/etape8")
    public String saveEtape8(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam String carteResidenceRef,
            @RequestParam String carteResidenceDateDebut,
            @RequestParam String carteResidenceDateFin,
            RedirectAttributes redirectAttributes) {
        try {
            form.setCarteResidenceRef(carteResidenceRef);
            form.setCarteResidenceDateDebut(LocalDate.parse(carteResidenceDateDebut));
            form.setCarteResidenceDateFin(LocalDate.parse(carteResidenceDateFin));

            if (form.getIdDemandeur() != null && !form.getIdDemandeur().isBlank()) {
                Optional<Demandeur> demandeurCheck = demandeurService.findById(form.getIdDemandeur());
                if (!demandeurCheck.isPresent()) {
                    form.setIdDemandeur(null);
                }
            }

            demandeurService.creerNouveauTitre(form);

            Optional<Demande> demandeOpt = demandeRepository.findById(form.getIdDemande());
            if (!demandeOpt.isPresent()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la création de la demande");
                return "redirect:/demandes";
            }

            Demande demande = demandeOpt.get();

            if (form.getVisaRefVisa() != null && !form.getVisaRefVisa().isBlank()) {
                visaService.creerVisa(
                        form.getVisaRefVisa(),
                        form.getVisaDateDebut(),
                        form.getVisaDateFin(),
                        demande);
            }

            if (form.getCarteResidenceRef() != null && !form.getCarteResidenceRef().isBlank()) {
                carteResidenceService.creerCarteResidence(
                        form.getCarteResidenceRef(),
                        form.getCarteResidenceDateDebut(),
                        form.getCarteResidenceDateFin(),
                        demande);
            }

            return "redirect:/demandes";
        } catch (ValidationException e) {
            redirectAttributes.addFlashAttribute("validationErrors", e.getErrors());
            redirectAttributes.addFlashAttribute("hasErrors", true);
            return "redirect:/demande/etape8";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur: " + e.getMessage());
            return "redirect:/demande/etape8";
        }
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

        String categoryLabel = form.getDemandCategory() != null
                ? ("duplicata".equals(form.getDemandCategory()) ? "Duplicata"
                        : "transfert-visa".equals(form.getDemandCategory()) ? "Transfert-de-Visa" : "")
                : "";
        model.addAttribute("demandCategory", form.getDemandCategory());
        model.addAttribute("demandCategoryLabel", categoryLabel);

        return "layout/main";
    }

    @PostMapping("/demande/confirmation")
    public String submitConfirmation(@ModelAttribute("demandeForm") DemandeForm form,
            @RequestParam(value = "demandCategory", required = false) String demandCategory) {
        if (demandCategory != null && !demandCategory.isBlank()) {
            form.setDemandCategory(demandCategory);
        }

        if (form.getDemandCategory() != null && !form.getDemandCategory().isBlank() && form.isNeedsVisaCarte()) {
            return "redirect:/demande/etape7";
        }

        return "redirect:/demande/terminer";
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

        return "redirect:/demandes/" + form.getIdDemande();
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

    private void addRequiredFieldMap(Model model, String... fieldNames) {
        Set<String> requiredFields = champsValidationService.getRequiredFieldNames();
        Map<String, Boolean> requiredFieldMap = new HashMap<>();

        for (String fieldName : fieldNames) {
            requiredFieldMap.put(fieldName, requiredFields.contains(fieldName));
        }

        model.addAttribute("requiredFieldMap", requiredFieldMap);
    }

}
