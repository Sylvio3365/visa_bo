package com.visa.bo.models.etatCivil;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import com.visa.bo.models.ClassMapTable;

@Entity
@Table(name = "genre")
public class Genre {
    private static final ClassMapTable ID_GENERATOR = new ClassMapTable("genre", "id_genre", "GEN", 2) {
    };

    public static String nextId() {
        return ID_GENERATOR.generateId();
    }

    @Id
    @Column(name = "id_genre", length = 50)
    private String idGenre;

    @Column(name = "libelle", nullable = false, length = 50)
    private String libelle;

    public Genre() {}

    public Genre(String idGenre) {
        this.idGenre = idGenre;
    }

    public String getIdGenre() {
        return idGenre;
    }

    public void setIdGenre(String idGenre) {
        this.idGenre = idGenre;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
