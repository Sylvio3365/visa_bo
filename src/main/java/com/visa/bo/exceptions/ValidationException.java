package com.visa.bo.exceptions;

import java.util.List;

public class ValidationException extends RuntimeException {
    private List<String> errors;

    public ValidationException(List<String> errors) {
        super("Erreurs de validation: " + String.join(", ", errors));
        this.errors = errors;
    }

    public ValidationException(String message) {
        super(message);
        this.errors = List.of(message);
    }

    public List<String> getErrors() {
        return errors;
    }
}
