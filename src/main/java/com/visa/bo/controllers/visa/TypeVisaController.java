package com.visa.bo.controllers.visa;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.visa.bo.models.visa.TypeVisa;
import com.visa.bo.repositories.visa.TypeVisaRepository;

@Controller
public class TypeVisaController {
    private final TypeVisaRepository typeVisaRepository;

    public TypeVisaController(TypeVisaRepository typeVisaRepository) {
        this.typeVisaRepository = typeVisaRepository;
    }

    @GetMapping("/")
    public String index() {
        return "redirect:/type-visa";
    }

    @GetMapping("/type-visa")
    public String typeVisaList(Model model) {
        List<TypeVisa> types = typeVisaRepository.findAll();
        model.addAttribute("types", types);
        model.addAttribute("activePage", "type-visa");
        model.addAttribute("pageTitle", "Liste des types de visa");
        model.addAttribute("headerTitle", "Visa Backoffice");
        model.addAttribute("headerSubtitle", "Gestion des demandes");
        model.addAttribute("showBack", true);
        model.addAttribute("backHref", "/");
        model.addAttribute("backLabel", "Retour a l'accueil");
        model.addAttribute("footerRight", "Types de visa");
        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/type-visa-content.jsp");
        return "layout/main";
    }

    @GetMapping("/type-visa/ajout")
    public String typeVisaForm(Model model) {
        populateTypeVisaFormLayout(model, "Ajout type visa");
        return "layout/main";
    }

    @PostMapping("/type-visa/ajout")
    public String typeVisaCreate(
        @RequestParam("idTypeVisa") String idTypeVisa,
        @RequestParam("libelle") String libelle,
        Model model
    ) {
        String trimmedId = idTypeVisa == null ? "" : idTypeVisa.trim();
        String trimmedLibelle = libelle == null ? "" : libelle.trim();

        if (trimmedLibelle.isBlank()) {
            model.addAttribute("error", "Libelle est obligatoire.");
            model.addAttribute("idTypeVisa", trimmedId);
            model.addAttribute("libelle", trimmedLibelle);
            populateTypeVisaFormLayout(model, "Ajout type visa");
            return "layout/main";
        }

        String finalId = trimmedId;
        if (finalId.isBlank()) {
            finalId = TypeVisa.nextId();
        } else if (typeVisaRepository.existsById(finalId)) {
            model.addAttribute("error", "Cet identifiant existe deja.");
            model.addAttribute("idTypeVisa", finalId);
            model.addAttribute("libelle", trimmedLibelle);
            populateTypeVisaFormLayout(model, "Ajout type visa");
            return "layout/main";
        }

        TypeVisa typeVisa = new TypeVisa();
        typeVisa.setIdTypeVisa(finalId);
        typeVisa.setLibelle(trimmedLibelle);
        typeVisaRepository.save(typeVisa);
        return "redirect:/type-visa";
    }

    private void populateTypeVisaFormLayout(Model model, String pageTitle) {
        model.addAttribute("activePage", "type-visa-add");
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("headerTitle", "Visa Backoffice");
        model.addAttribute("headerSubtitle", "Gestion des demandes");
        model.addAttribute("showBack", true);
        model.addAttribute("backHref", "/type-visa");
        model.addAttribute("backLabel", "Retour a la liste");
        model.addAttribute("footerRight", "Ajout type visa");
        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/type-visa-form.jsp");
    }
}
