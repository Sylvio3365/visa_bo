package com.visa.bo.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;



public class Util{
    public static LocalDate parseDate(String value) throws Exception {
    if (value == null || value.isBlank()) {
        throw new Exception("La date est obligatoire");
    }

    try {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return LocalDate.parse(value.trim(), formatter);
    } catch (DateTimeParseException e) {
        throw new Exception("Format de date invalide. Format attendu : yyyy-MM-dd");
    }
}
}