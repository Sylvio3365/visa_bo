package com.visa.bo.controllers.visa;

import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.visa.bo.models.visa.TypeVisa;
import com.visa.bo.repositories.visa.TypeVisaRepository;

@RestController
@RequestMapping("/api/type-visas")
public class TypeVisaController {
    private final TypeVisaRepository typeVisaRepository;

    public TypeVisaController(TypeVisaRepository typeVisaRepository) {
        this.typeVisaRepository = typeVisaRepository;
    }

    @GetMapping
    public List<TypeVisa> list() {
        return typeVisaRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<TypeVisa> getById(@PathVariable("id") String id) {
        Optional<TypeVisa> typeVisa = typeVisaRepository.findById(id);
        return typeVisa.map(ResponseEntity::ok)
            .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }

    @PostMapping
    public ResponseEntity<TypeVisa> create(@RequestBody TypeVisa typeVisa) {
        if (typeVisa.getIdTypeVisa() == null || typeVisa.getIdTypeVisa().isBlank()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
        if (typeVisaRepository.existsById(typeVisa.getIdTypeVisa())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        TypeVisa saved = typeVisaRepository.save(typeVisa);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<TypeVisa> update(
        @PathVariable("id") String id,
        @RequestBody TypeVisa typeVisa
    ) {
        if (!typeVisaRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        typeVisa.setIdTypeVisa(id);
        TypeVisa saved = typeVisaRepository.save(typeVisa);
        return ResponseEntity.ok(saved);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") String id) {
        if (!typeVisaRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        typeVisaRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
