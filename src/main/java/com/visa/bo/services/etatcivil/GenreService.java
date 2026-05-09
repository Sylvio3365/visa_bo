package com.visa.bo.services.etatcivil;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.visa.bo.models.etatCivil.Genre;
import com.visa.bo.repositories.etatcivil.GenreRepository;

@Service
public class GenreService {

    @Autowired
    private GenreRepository genreRepository;

    public List<Genre> findAll() {
        return genreRepository.findAll();
    }

    public Genre findById(String id) {
        return genreRepository.findById(id).orElse(null);
    }
}
