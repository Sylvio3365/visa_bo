package com.visa.bo.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "type_visa")
public class TypeVisa {
    @Id
    @Column(name = "id_type_visa", length = 50)
    private String idTypeVisa;

    @Column(name = "libelle", nullable = false, length = 150)
    private String libelle;

    public String getIdTypeVisa() {
        return idTypeVisa;
    }

    public void setIdTypeVisa(String idTypeVisa) {
        this.idTypeVisa = idTypeVisa;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
