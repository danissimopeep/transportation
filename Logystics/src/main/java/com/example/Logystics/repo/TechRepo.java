package com.example.Logystics.repo;

import com.example.Logystics.domain.Tech;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface TechRepo extends CrudRepository<Tech, Long> {
    Tech findByName(String name);
    List<Tech> findByTechType_IdAndDeleted(Long id1, boolean isDeleted1);
    List<Tech> findByNameContainsAndTechType_IdAndDeletedOrTechType_NameContainsAndTechType_IdAndDeleted(String name, Long id1, boolean isDeleted1, String techName, Long id2, boolean isDeleted2);
}
