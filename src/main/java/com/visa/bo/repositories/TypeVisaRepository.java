package com.visa.bo.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.visa.bo.models.visa.TypeVisa;

public interface TypeVisaRepository extends JpaRepository<TypeVisa, String> {
}
