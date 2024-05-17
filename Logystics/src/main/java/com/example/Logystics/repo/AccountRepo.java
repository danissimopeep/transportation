package com.example.Logystics.repo;

import com.example.Logystics.domain.Account;
import com.example.Logystics.domain.Role;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface AccountRepo extends CrudRepository<Account, Long> {
    Account findByUsername(String username);

    Iterable<Account> findByRole(Role role);

    List<Account> findByRoleAndActive(Role role, boolean isActive);
}
