package com.visa.bo.models.visa;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "type_visa")
public class TypeVisa {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("type_visa", "id_type_visa", "TV", 6) {};

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

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
