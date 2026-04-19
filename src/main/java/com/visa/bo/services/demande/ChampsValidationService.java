package com.visa.bo.services.demande;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.visa.bo.dto.demande.DemandeForm;
import com.visa.bo.models.demande.Champs;
import com.visa.bo.repositories.demande.ChampsRepository;

@Service
public class ChampsValidationService {

    @Autowired
    private ChampsRepository champsRepository;

    public List<String> validateRequiredFields(DemandeForm form) {
        List<String> errors = new ArrayList<>();
        BeanWrapper wrapper = new BeanWrapperImpl(form);

        for (Champs champ : champsRepository.findAll()) {
            if (!Integer.valueOf(1).equals(champ.getEstObligatoire())) {
                continue;
            }

            String propertyName = snakeToCamel(champ.getLibelle());
            if (!wrapper.isReadableProperty(propertyName)) {
                continue;
            }

            Object value = wrapper.getPropertyValue(propertyName);
            if (isEmpty(value)) {
                errors.add("Le champ '" + prettyLabel(champ.getLibelle()) + "' est obligatoire.");
            }
        }
        return errors;
    }

    private boolean isEmpty(Object value) {
        if (value == null) {
            return true;
        }
        if (value instanceof String) {
            return ((String) value).trim().isEmpty();
        }
        return false;
    }

    private String snakeToCamel(String input) {
        if (input == null || input.isBlank()) {
            return input;
        }

        StringBuilder sb = new StringBuilder();
        boolean upperNext = false;
        for (char c : input.toCharArray()) {
            if (c == '_') {
                upperNext = true;
                continue;
            }
            sb.append(upperNext ? Character.toUpperCase(c) : c);
            upperNext = false;
        }
        return sb.toString();
    }

    private String prettyLabel(String input) {
        if (input == null || input.isBlank()) {
            return "Champ";
        }

        String spaced = input.replace('_', ' ');
        return Character.toUpperCase(spaced.charAt(0)) + spaced.substring(1);
    }
}
