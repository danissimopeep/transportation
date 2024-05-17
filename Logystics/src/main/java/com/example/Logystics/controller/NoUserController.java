package com.example.Logystics.controller;

import com.example.Logystics.domain.*;
import com.example.Logystics.repo.*;
import com.example.Logystics.service.KeyGenerationService;
import com.example.Logystics.service.MailService;
import org.hibernate.Hibernate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class NoUserController {

    private final AccountRepo accountRepo;
    private final KeyGenerationService keyGenerationService;
    private final MailService mailService;
    private final ClientProfileRepo clientProfileRepo;
    private final CompanyRepo companyRepo;
    private final ManagerProfileRepo managerProfileRepo;
    private final TechTypeRepo techTypeRepo;
    private final TechRepo techRepo;

    public NoUserController(AccountRepo accountRepo, KeyGenerationService keyGenerationService, MailService mailService, ClientProfileRepo clientProfileRepo,
                            CompanyRepo companyRepo,
                            ManagerProfileRepo managerProfileRepo, TechTypeRepo techTypeRepo, TechRepo techRepo) {
        this.accountRepo = accountRepo;
        this.keyGenerationService = keyGenerationService;
        this.mailService = mailService;
        this.clientProfileRepo = clientProfileRepo;
        this.companyRepo = companyRepo;
        this.managerProfileRepo = managerProfileRepo;
        this.techTypeRepo = techTypeRepo;
        this.techRepo = techRepo;
    }
    @GetMapping("/logout")
    public String logout(Model model){
        return "logout";
    }
    @GetMapping("/")
    public String index(Map<String, Object> model) {
        if(accountRepo.findByUsername("admin@admin.com") == null){
            Account account = new Account();
            account.setUsername("admin@admin.com");
            account.setPassword("admin");
            account.setRole(Role.ADMIN);
            account.setActive(true);

            accountRepo.save(account);
        }

        return "index";
    }
    @GetMapping("/registration-user")
    public String registrationUserGet(Map<String, Object> model) {
        return "registrationUser";
    }
    @PostMapping("/registration-user")
    public String registrationUserPost(@RequestParam String credentials,
                                       @RequestParam String username,
                                       @RequestParam String password,
                                       @RequestParam String repeatPassword,
                                       @RequestParam String telephone,
                                       Map<String, Object> model) {
        model.put("username", username);
        model.put("password", password);
        model.put("repeatPassword", repeatPassword);
        model.put("credentials", credentials);
        model.put("telephone", telephone);

        if (accountRepo.findByUsername(username) != null) {
            model.put("errorUsername", "Данный логин уже занят!");
            return "registrationUser";
        }

        String key = keyGenerationService.generateKey(username, "admin@admin.com", Role.CLIENT);
        String title = "Код подтверждения.";
        String text = "Ваш код подтверждения: " + key + "\n";
        text += "Никому не сообщайте и не передавайте данный код во избежание кражи ваших личных данных!";

        mailService.send(title, text, username);

        return "confirmation";
    }
    @PostMapping("/confirmation")
    public String confirmationPost(@RequestParam String credentials,
                                   @RequestParam String username,
                                   @RequestParam String password,
                                   @RequestParam String repeatPassword,
                                   @RequestParam String telephone,
                                   @RequestParam String key,
                                   Map<String, Object> model) {
        String creator = keyGenerationService.matchKey(key, username, Role.CLIENT);

        if(creator == null){
            model.put("username", username);
            model.put("password", password);
            model.put("repeatPassword", repeatPassword);
            model.put("credentials", credentials);
            model.put("telephone", telephone);
            model.put("error", "Неверный код подтверждения");
            model.put("key", key);

            return "confirmation";
        }

        Company company = new Company();
        String name = "Без названия " + username;
        company.setName(name);
        company.setDescription("");
        company.setTelephone(telephone);
        company.setEmail(username);
        company.setAddress("");

        companyRepo.save(company);
        company = companyRepo.findByName(name).get(0);


        Account account = new Account();
        account.setRole(Role.CLIENT);
        account.setUsername(username);
        account.setPassword(password);
        account.setActive(true);

        accountRepo.save(account);

        ClientProfile userProfile = new ClientProfile();
        userProfile.setAccount(accountRepo.findByUsername(username));
        userProfile.setCredentials(credentials);
        userProfile.setTelephone(telephone);
        userProfile.setCompany(company);

        clientProfileRepo.save(userProfile);

        return "redirect:/login";
    }
    @GetMapping("/registration-employee")
    public String registrationEmployeeGet(Map<String, Object> model) {
        return "registrationEmployee";
    }
    @PostMapping("/registration-employee")
    public String registrationEmployeePost(@RequestParam String credentials,
                                           @RequestParam String username,
                                           @RequestParam String password,
                                           @RequestParam String repeatPassword,
                                           @RequestParam String telephone,
                                           @RequestParam String key,
                                           Map<String, Object> model) {
        if (accountRepo.findByUsername(username) != null) {
            model.put("username", username);
            model.put("password", password);
            model.put("repeatPassword", repeatPassword);
            model.put("credentials", credentials);
            model.put("telephone", telephone);
            model.put("key", key);
            model.put("errorUsername", "Данный логин уже занят!");
            return "registrationEmployee";
        }

        String creator = keyGenerationService.matchKey(key, username, Role.MANAGER);
        if(creator != null){
            Account parent = accountRepo.findByUsername(creator);

            Account account = new Account();
            account.setUsername(username);
            account.setPassword(password);
            account.setActive(true);

            account.setRole(Role.MANAGER);
            accountRepo.save(account);

            ManagerProfile managerProfile = new ManagerProfile();
            managerProfile.setAccount(accountRepo.findByUsername(username));
            managerProfile.setCredentials(credentials);
            managerProfile.setTelephone(telephone);

            managerProfileRepo.save(managerProfile);

            return "redirect:/login";
        }

        model.put("username", username);
        model.put("password", password);
        model.put("repeatPassword", repeatPassword);
        model.put("credentials", credentials);
        model.put("telephone", telephone);
        model.put("key", key);
        model.put("errorKey", "Неверный реферальный код");

        return "registrationEmployee";
    }

    @GetMapping("/all/techs")
    public String techsGet(@RequestParam(name = "search", required = false) String search, Map<String, Object> model){
        Iterable<TechType> techTypes = techTypeRepo.findAll();
        List<TechType> filtered = new ArrayList<>();

        int count = 0;

        for(TechType type: techTypes){
            if(search == null){
                type.setTechs(techRepo.findByTechType_IdAndDeleted(type.getId(), false));
            }
            else{
                type.setTechs(techRepo.findByNameContainsAndTechType_IdAndDeletedOrTechType_NameContainsAndTechType_IdAndDeleted(search, type.getId(), false, search, type.getId(), false));
            }

            if(type.getTechs().size() != 0){
                for(Tech tech: type.getTechs()){
                    Hibernate.initialize(tech.getTechImages());
                    count++;
                }

                filtered.add(type);
            }
        }
        model.put("techTypes", filtered);
        model.put("allTechTypes", techTypes);
        model.put("count", count);

        if(search!= null)
            model.put("search", search);

        return "/common/techs";
    }

    @GetMapping("/all/tech/{id}")
    public String techGet(@PathVariable long id, Map<String, Object> model){
        Tech tech = techRepo.findById(id).get();

        Hibernate.initialize(tech.getTechImages());
        Hibernate.initialize(tech.getTechType());

        model.put("tech", tech);
        if(!tech.getDescription().isEmpty())
            model.put("description", tech.getDescription());
        if(!tech.getTechImages().isEmpty())
            model.put("images", tech.getTechImages());

        return "/common/tech";
    }

    @GetMapping("/all/about")
    public String aboutGet(Map<String, Object> model) {
        return "common/about";
    }
}
