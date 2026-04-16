package com.visa.bo.controllers.visa;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.visa.bo.models.visa.TypeVisa;
import com.visa.bo.repositories.visa.TypeVisaRepository;

@Controller
public class TypeVisaViewController {
    private final TypeVisaRepository typeVisaRepository;

    public TypeVisaViewController(TypeVisaRepository typeVisaRepository) {
        this.typeVisaRepository = typeVisaRepository;
    }

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/type-visa")
    public String typeVisaList(Model model) {
        List<TypeVisa> types = typeVisaRepository.findAll();
        model.addAttribute("types", types);
        return "type-visa";
    }
}
