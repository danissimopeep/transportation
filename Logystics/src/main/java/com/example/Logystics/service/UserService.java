package com.example.Logystics.service;

import com.example.Logystics.repo.AccountRepo;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserService implements UserDetailsService {
    private final AccountRepo accountRepo;
    public UserService(AccountRepo accountRepo) {
        this.accountRepo = accountRepo;
    }
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return accountRepo.findByUsername(username);
    }
}