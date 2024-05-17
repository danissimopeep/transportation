package com.example.Logystics.repo;

import com.example.Logystics.domain.Request;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface RequestRepo extends CrudRepository<Request, Long> {
    List<Request> findByClientProfile_Account_Id(Long id);
}
