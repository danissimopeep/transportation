package com.example.Logystics.controller;

import com.example.Logystics.domain.*;
import com.example.Logystics.repo.*;
import com.example.Logystics.service.KeyGenerationService;
import com.example.Logystics.service.MailService;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasAuthority('ADMIN')")
public class AdminController {

    @Value("${upload.path}")
    private String uploadPath;
    private final AccountRepo accountRepo;
    private final ClientProfileRepo clientProfileRepo;
    private final ManagerProfileRepo managerProfileRepo;
    private final MailService mailService;
    private final RegistrationKeyRepo registrationKeyRepo;
    private final KeyGenerationService keyGenerationService;
    private final TechTypeRepo techTypeRepo;
    private final TechRepo techRepo;
    private final TechImageRepo techImageRepo;
    private final ActiveRequestRepo activeRequestRepo;

    public AdminController(AccountRepo accountRepo, ClientProfileRepo clientProfileRepo, ManagerProfileRepo managerProfileRepo, MailService mailService, RegistrationKeyRepo registrationKeyRepo, KeyGenerationService keyGenerationService, TechTypeRepo techTypeRepo,
                           TechRepo techRepo,
                           TechImageRepo techImageRepo,
                           ActiveRequestRepo activeRequestRepo) {
        this.accountRepo = accountRepo;
        this.clientProfileRepo = clientProfileRepo;
        this.managerProfileRepo = managerProfileRepo;
        this.mailService = mailService;
        this.registrationKeyRepo = registrationKeyRepo;
        this.keyGenerationService = keyGenerationService;
        this.techTypeRepo = techTypeRepo;
        this.techRepo = techRepo;
        this.techImageRepo = techImageRepo;
        this.activeRequestRepo = activeRequestRepo;
    }

    @GetMapping("/clients")
    public String usersGet(@RequestParam(name = "search", required = false) String search,
                           Map<String, Object> model) {

        if(search == null)
            search = "";

        List<ClientProfile> clients =
                clientProfileRepo.findByAccount_UsernameContainsOrCredentialsContainsOrTelephoneContains(search,
                        search,
                        search);

        for(ClientProfile client: clients){
            Hibernate.initialize(client.getCompany());
        }

        if(!search.equals(""))
            model.put("search", search);

        if(clients.size() != 0)
            model.put("clients", clients);

        return "admin/clients";
    }

    @GetMapping("/managers")
    public String managersGet(@RequestParam(name = "search", required = false) String search,
                               Map<String, Object> model) {

        if(search == null)
            search = "";

        List<ManagerProfile> managers =
                managerProfileRepo.findByAccount_UsernameContainsOrCredentialsContainsOrTelephoneContains(search,
                        search,
                        search);

        for(ManagerProfile manager: managers){
            Hibernate.initialize(manager.getAccount());
        }

        if(!search.equals(""))
            model.put("search", search);

        if(managers.size() != 0)
            model.put("managers", managers);

        return "admin/managers";
    }
    @PostMapping("/{role}/newsletter")
    public String usersNewsletterPost(@PathVariable String role, @RequestParam String text, Map<String, Object> model) {
        Role r = Role.ADMIN;
        if(role.equals("clients")){
            r = Role.CLIENT;
        }
        else if(role.equals("managers")){
            r = Role.MANAGER;
        }

        List<Account> accounts = accountRepo.findByRoleAndActive(r, true);

        String title = "Сообщение от администрации.";

        for(Account account: accounts){
            mailService.send(title, text, account.getUsername());
        }

        switch (r){
            case CLIENT:{
                return "redirect:/admin/clients";
            }
            case MANAGER:{
                return "redirect:/admin/managers";
            }
        }
        return "redirect:/";
    }

    @PostMapping("/accounts/{id}")
    public String editAccountStatusPost(@PathVariable long id, Model model){
        Account account = accountRepo.findById(id).get();

        account.setActive(!account.isActive());
        accountRepo.save(account);

        if(account.getRole().equals(Role.CLIENT))
            return "redirect:/admin/clients";
        else if(account.getRole().equals(Role.MANAGER))
            return "redirect:/admin/managers";

        return "redirect:/";
    }

    @GetMapping("/message/{id}")
    public String sendMessageGet(@PathVariable long id, Model model){

        Account account = accountRepo.findById(id).get();
        model.addAttribute("account", account);

        return "admin/message";
    }

    @PostMapping("/message/{id}")
    public String sendMessagePost(@PathVariable long id,
                                  @RequestParam String username,
                                  @RequestParam String title,
                                  @RequestParam String text,
                                  Model model){

        Account account = accountRepo.findById(id).get();

        mailService.send(title, text, username);

        if(account.getRole().equals(Role.CLIENT))
            return "redirect:/admin/clients";
        else if(account.getRole().equals(Role.MANAGER))
            return "redirect:/admin/managers";

        return "redirect:/";
    }

    @GetMapping("/registration-keys")
    public String regKeysGet(@AuthenticationPrincipal Account account, @RequestParam(name = "username", required = false) String username,
                             Map<String, Object> model) {

        List<RegistrationKey> regKeys = null;
        if(username == null){
            regKeys = registrationKeyRepo.findByCreatorAndRole(account.getUsername(), Role.MANAGER);
        }
        else {
            regKeys = registrationKeyRepo.findByCreatorAndRoleAndUsernameContains(username, Role.MANAGER, username);
            model.put("searchUsername", username);
        }

        model.put("regKeys", regKeys);

        return "admin/registrationKeys";
    }

    @PostMapping("/registration-keys/regenerate/{id}")
    public String regenerateKeyPost(@AuthenticationPrincipal Account account, @PathVariable long id, Model model){
        RegistrationKey registrationKey = registrationKeyRepo.findById(id).get();

        String key = keyGenerationService.generateKey(registrationKey.getUsername(), account.getUsername(), Role.MANAGER);

        String title = "Обновленный реферальный код регистрации.";
        String text = "Ваш реферальный код для регистрации был обновлен. Для регистрации введите его в соответствующее поле.\n" +
                "Новый реферальный код: " + key + "\n";
        text += "Никому не сообщайте и не передавайте данный код во избежание кражи ваших личных данных!";

        mailService.send(title, text, registrationKey.getUsername());

        return "redirect:/admin/registration-keys";
    }
    @PostMapping("/registration-keys/delete/{id}")
    public String deleteKeyPost(@PathVariable long id, Model model){
        RegistrationKey registrationKey = registrationKeyRepo.findById(id).get();

        registrationKeyRepo.deleteById(registrationKey.getId());

        return "redirect:/admin/registration-keys";
    }
    @PostMapping("/registration-keys/generate")
    public String generateKeyPost(@AuthenticationPrincipal Account account, @RequestParam String username, Model model){
        String key = keyGenerationService.generateKey(username, account.getUsername(), Role.MANAGER);

        String title = "Реферальный код регистрации.";
        String text = "Вам выдан реферальный код для создания аккаунта. Для регистрации введите его в соответствующее поле.\n" +
                "Реферальный код: " + key+ "\n";
        text += "Никому не сообщайте и не передавайте данный код во избежание кражи ваших личных данных!";

        mailService.send(title, text, username);

        return "redirect:/admin/registration-keys";
    }
    @GetMapping("/tech-types")
    public String techTypesGet(Map<String, Object> model){
        List<TechType> techTypes = techTypeRepo.findByDeleted(false);
        model.put("techTypes", techTypes);

        return "/admin/techTypes";
    }

    @PostMapping("/tech-types/add")
    public String techTypeAddPost(@RequestParam String name, Map<String, Object> model){
        TechType techType = techTypeRepo.findByNameAndDeleted(name, false);

        if(techType == null){
            techType = new TechType();
            techType.setName(name);
            techTypeRepo.save(techType);

            return "redirect:/admin/tech-types";
        }

        Iterable<TechType> techTypes = techTypeRepo.findAll();
        model.put("techTypes", techTypes);

        model.put("errorText", "Данная категория уже существует!");
        model.put("name", name);

        return "/admin/techTypes";
    }
    @PostMapping("/tech-types/delete/{id}")
    public String techTypeAddPost(@PathVariable long id, Map<String, Object> model){
        techTypeRepo.deleteById(id);

        return "redirect:/admin/tech-types";
    }

    @GetMapping("/techs")
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

        return "/admin/techs";
    }

    @PostMapping("/tech/add")
    public String techAddPost(@RequestParam String name, @RequestParam long techTypeId, Map<String, Object> model){
        TechType techType = techTypeRepo.findById(techTypeId).get();

        Tech tech = new Tech();
        tech.setName(name);
        tech.setTechType(techType);
        tech.setDescription("");
        tech.setCost(0.0);
        tech.setDeleted(false);

        techRepo.save(tech);

        return "redirect:/admin/techs";
    }

    @PostMapping("/tech/delete/{id}")
    public String techDeletePost(@PathVariable long id, Map<String, Object> model){
        Tech tech = techRepo.findById(id).get();
        tech.setDeleted(true);
        techRepo.save(tech);

        return "redirect:/admin/techs";
    }

    @GetMapping("/tech/{id}")
    public String techGet(@PathVariable long id, Map<String, Object> model){
        Tech tech = techRepo.findById(id).get();

        Hibernate.initialize(tech.getTechImages());
        Hibernate.initialize(tech.getTechType());

        model.put("tech", tech);
        if(!tech.getDescription().isEmpty())
            model.put("description", tech.getDescription());
        if(!tech.getTechImages().isEmpty())
            model.put("images", tech.getTechImages());

        return "/admin/tech";
    }

    @GetMapping("/tech/edit/{id}")
    public String roomTypeEditGet(@PathVariable long id, Map<String, Object> model) {
        Tech tech = techRepo.findById(id).get();

        Hibernate.initialize(tech.getTechImages());
        Hibernate.initialize(tech.getTechType());

        model.put("tech", tech);

        return "admin/techEdit";
    }

    @PostMapping("/tech/edit/{id}")
    public String roomTypeEditPost(@PathVariable long id,
                                   @RequestParam String name,
                                   @RequestParam Double cost,
                                   @RequestParam String description,
                                   Map<String, Object> model) {

        Tech tech = techRepo.findById(id).get();
        tech.setName(name);
        tech.setCost(cost);
        tech.setDescription(description);
        techRepo.save(tech);

        return "redirect:/admin/tech/edit/" + id;
    }

    @PostMapping("/tech/image/add/{id}")
    public String roomTypeAddImagePost(@PathVariable long id,
                                       @RequestParam MultipartFile file,
                                       Map<String, Object> model) throws IOException {

        File uploadDir = new File(uploadPath);


        String uuidFile = UUID.randomUUID().toString();
        String path =  uuidFile + "." + file.getOriginalFilename();

        file.transferTo(new File(uploadPath + "/" + path));

        Tech tech = techRepo.findById(id).get();

        TechImage techImage = new TechImage();
        techImage.setTech(tech);
        techImage.setPath(path);

        techImageRepo.save(techImage);

        return "redirect:/admin/tech/edit/" + id;
    }

    @PostMapping("/tech/image/delete/{id}")
    public String roomTypeDeleteImagePost(@PathVariable long id, Map<String, Object> model) {

        TechImage image = techImageRepo.findById(id).get();
        Hibernate.initialize(image.getTech());
        File f = new File(uploadPath + "/" +image.getPath());
        f.delete();
        techImageRepo.deleteById(id);

        return "redirect:/admin/tech/edit/" + image.getTech().getId();
    }

    @GetMapping("/orders")
    public String ordersGet(Map<String, Object> model){
        Iterable<ActiveRequest> activeRequests = activeRequestRepo.findAll();
        List<ActiveRequest> filtered = new ArrayList<>();

        for(ActiveRequest activeRequest : activeRequests){
            if(!activeRequest.getStatus().equals(RequestStatus.CANCELLED) && !activeRequest.getStatus().equals(RequestStatus.DONE)){
                Hibernate.initialize(activeRequest.getRequest());
                Hibernate.initialize(activeRequest.getRequest().getCardItems());
                Hibernate.initialize(activeRequest.getRequest().getClientProfile());
                Hibernate.initialize(activeRequest.getRequest().getClientProfile().getCompany());
                Hibernate.initialize(activeRequest.getManagerProfile());
                filtered.add(activeRequest);
            }
        }

        if(!filtered.isEmpty())
            model.put("orders", filtered);

        List<ManagerProfile> managerProfiles = managerProfileRepo.findByAccount_Active(true);
        if(!managerProfiles.isEmpty())
            model.put("managers", managerProfiles);

        return "/admin/orders";
    }

    @PostMapping("/order/set-manager/{id}")
    public String editOrderPost(@PathVariable long id, @RequestParam long managerId, Model model){
        ActiveRequest request = activeRequestRepo.findById(id).get();
        ManagerProfile managerProfile = managerProfileRepo.findById(managerId).get();

        request.setManagerProfile(managerProfile);
        activeRequestRepo.save(request);

        return "redirect:/admin/orders";
    }

    @GetMapping("/history")
    public String historyGet(Map<String, Object> model){
        Iterable<ActiveRequest> activeRequests = activeRequestRepo.findAll();
        List<ActiveRequest> filtered = new ArrayList<>();

        for(ActiveRequest activeRequest : activeRequests){
            if(activeRequest.getStatus().equals(RequestStatus.CANCELLED) || activeRequest.getStatus().equals(RequestStatus.DONE)){
                Hibernate.initialize(activeRequest.getRequest());
                Hibernate.initialize(activeRequest.getRequest().getCardItems());
                Hibernate.initialize(activeRequest.getRequest().getClientProfile());
                Hibernate.initialize(activeRequest.getRequest().getClientProfile().getCompany());
                Hibernate.initialize(activeRequest.getManagerProfile());
                filtered.add(activeRequest);
            }
        }

        if(!filtered.isEmpty())
            model.put("orders", filtered);

        return "/admin/history";
    }

    @GetMapping("/order/{id}")
    public String orderGet(@PathVariable Long id, Map<String, Object> model){
        ActiveRequest activeRequest = activeRequestRepo.findById(id).get();

        Hibernate.initialize(activeRequest.getRequest());
        Hibernate.initialize(activeRequest.getRequest().getCardItems());
        Hibernate.initialize(activeRequest.getRequest().getClientProfile());
        Hibernate.initialize(activeRequest.getRequest().getClientProfile().getCompany());
        Hibernate.initialize(activeRequest.getManagerProfile());

        model.put("order", activeRequest);

        return "/admin/order";
    }

    @GetMapping("/history-order/{id}")
    public String historyOrderGet(@PathVariable Long id, Map<String, Object> model){
        ActiveRequest activeRequest = activeRequestRepo.findById(id).get();

        Hibernate.initialize(activeRequest.getRequest());
        Hibernate.initialize(activeRequest.getRequest().getCardItems());
        Hibernate.initialize(activeRequest.getRequest().getClientProfile());
        Hibernate.initialize(activeRequest.getRequest().getClientProfile().getCompany());
        Hibernate.initialize(activeRequest.getManagerProfile());

        model.put("order", activeRequest);

        return "/admin/historyOrder";
    }
}
