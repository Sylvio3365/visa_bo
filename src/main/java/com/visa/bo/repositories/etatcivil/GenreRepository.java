package com.visa.bo.repositories.etatcivil;

import org.springframework.data.jpa.repository.JpaRepository;
import com.visa.bo.models.etatCivil.Genre;

public interface GenreRepository extends JpaRepository<Genre, String> {
}
