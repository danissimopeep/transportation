package com.example.Logystics.service;

import com.example.Logystics.domain.RegistrationKey;
import com.example.Logystics.domain.Role;
import com.example.Logystics.repo.RegistrationKeyRepo;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Random;

@Service
public class KeyGenerationService {
    private final RegistrationKeyRepo registrationKeyRepo;
    public KeyGenerationService(RegistrationKeyRepo registrationKeyRepo) {
        this.registrationKeyRepo = registrationKeyRepo;
    }

    private String getKey(){
        Random random = new Random((new Date().getTime()));
        String str = "";
        for(int i=0; i<16; ++i){
            str += (char)(Math.abs(random.nextInt()%26) + (random.nextInt()%2==0?  + 'a' : 'A'));

        }

        return str;
    }

    public String regenerateKey(long id){
        RegistrationKey key = registrationKeyRepo.findById(id).get();
        String k = getKey();
        key.setKey(k);
        registrationKeyRepo.save(key);

        return k;
    }

    public String generateKey(String username, String creator, Role role){
        String key = getKey();
        List<RegistrationKey> registrationKeys = registrationKeyRepo.findByUsernameAndCreator(username, creator);

        boolean isFound = false;
        for(RegistrationKey registrationKey : registrationKeys){
            if(registrationKey.getRole().equals(role)){
                isFound = true;
                registrationKey.setKey(key);
                registrationKeyRepo.save(registrationKey);
                break;
            }
        }

        if(!isFound){
            RegistrationKey newKey = new RegistrationKey();
            newKey.setKey(key);
            newKey.setUsername(username);
            newKey.setCreator(creator);
            newKey.setRole(role);
            registrationKeyRepo.save(newKey);
        }

        return key;
    }

    public String matchKey(String key, String username, Role role){
        RegistrationKey registrationKey = registrationKeyRepo.findByKey(key);

        if(registrationKey != null && registrationKey.getUsername().equals(username) && registrationKey.getRole().equals(role)){
            registrationKeyRepo.deleteById(registrationKey.getId());
            return registrationKey.getCreator();
        }

        return null;
    }
}
