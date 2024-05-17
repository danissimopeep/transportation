package com.example.Logystics.repo;

import com.example.Logystics.domain.Company;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface CompanyRepo  extends CrudRepository<Company, Long> {
    List<Company> findByName(String name);
}
