package com.example.Logystics.repo;

import com.example.Logystics.domain.ManagerProfile;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ManagerProfileRepo extends CrudRepository<ManagerProfile, Long> {
    ManagerProfile findByAccount_Id(Long accountId);
    List<ManagerProfile> findByAccount_Active(boolean isActive);
    List<ManagerProfile> findByAccount_UsernameContainsOrCredentialsContainsOrTelephoneContains(String username, String credentials, String telephone);
}
