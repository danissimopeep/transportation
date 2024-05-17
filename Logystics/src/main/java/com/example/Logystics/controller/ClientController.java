package com.example.Logystics.controller;

import com.example.Logystics.domain.*;
import com.example.Logystics.repo.*;
import com.example.Logystics.service.CartService;
import org.hibernate.Hibernate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/client")
@PreAuthorize("hasAuthority('CLIENT')")
public class ClientController {
    private final TechTypeRepo techTypeRepo;
    private final TechRepo techRepo;
    private final ClientProfileRepo clientProfileRepo;
    private final CompanyRepo companyRepo;
    private final CartService cartService;
    private final RequestRepo requestRepo;
    private final ActiveRequestRepo activeRequestRepo;

    public ClientController(TechTypeRepo techTypeRepo, TechRepo techRepo,
                            ClientProfileRepo clientProfileRepo,
                            CompanyRepo companyRepo, CartService cartService,
                            RequestRepo requestRepo,
                            ActiveRequestRepo activeRequestRepo) {
        this.techTypeRepo = techTypeRepo;
        this.techRepo = techRepo;
        this.clientProfileRepo = clientProfileRepo;
        this.companyRepo = companyRepo;
        this.cartService = cartService;
        this.requestRepo = requestRepo;
        this.activeRequestRepo = activeRequestRepo;
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

        return "/client/techs";
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

        return "/client/tech";
    }

    @GetMapping("/company")
    public String companyGet(@AuthenticationPrincipal Account account, Map<String, Object> model) {
        ClientProfile profile = clientProfileRepo.findByAccount_Id(account.getId());
        Hibernate.initialize(profile.getCompany());

        model.put("account", account);
        model.put("profile", profile);
        model.put("company", profile.getCompany());

        return "client/company";
    }

    @GetMapping("/company/edit")
    public String companyEditGet(@AuthenticationPrincipal Account account, Map<String, Object> model) {
        ClientProfile profile = clientProfileRepo.findByAccount_Id(account.getId());
        Hibernate.initialize(profile.getCompany());

        model.put("name", profile.getCompany().getName());

        if(!profile.getCompany().getDescription().isEmpty())
            model.put("description", profile.getCompany().getDescription());
        if(!profile.getCompany().getEmail().isEmpty())
            model.put("email", profile.getCompany().getEmail());
        if(!profile.getCompany().getAddress().isEmpty())
            model.put("address", profile.getCompany().getAddress());
        if(!profile.getCompany().getTelephone().isEmpty())
            model.put("telephone", profile.getCompany().getTelephone());

        return "client/companyEdit";
    }

    @PostMapping("/company/edit")
    public String companyEditPost(@AuthenticationPrincipal Account account,
                                  @RequestParam String name,
                                  @RequestParam String description,
                                  @RequestParam String email,
                                  @RequestParam String telephone,
                                  @RequestParam String address,
                                  Map<String, Object> model) {

        ClientProfile profile = clientProfileRepo.findByAccount_Id(account.getId());
        Hibernate.initialize(profile.getCompany());
        Company company = profile.getCompany();

        company.setName(name);
        company.setDescription(description);
        company.setEmail(email);
        company.setAddress(address);
        company.setTelephone(telephone);
        companyRepo.save(company);

        return "redirect:/client/company/edit";
    }

    @GetMapping("/profile")
    public String profileEditGet(@AuthenticationPrincipal Account account, Map<String, Object> model){
        ClientProfile profile = clientProfileRepo.findByAccount_Id(account.getId());

        model.put("profile", profile);

        return "/client/profile";
    }

    @PostMapping("/profile")
    public String profileEditPost(@AuthenticationPrincipal Account account, @RequestParam String credentials, @RequestParam String telephone, Map<String, Object> model){
        ClientProfile profile = clientProfileRepo.findByAccount_Id(account.getId());

        profile.setCredentials(credentials);
        profile.setTelephone(telephone);

        clientProfileRepo.save(profile);

        return "redirect:/client/profile";
    }

    @GetMapping("/tech/add-to-cart/{id}")
    public String techAddToCartGet(@PathVariable long id, @AuthenticationPrincipal Account account, Map<String, Object> model){
        Tech tech = techRepo.findById(id).get();

        cartService.addToCart(account, tech);

        return "redirect:/client/tech/" + id;
    }

    @GetMapping("/cart")
    public String cartGet(@AuthenticationPrincipal Account account, Map<String, Object> model){
        Request request = cartService.getCart(account);

        if(request != null){
            Hibernate.initialize(request.getCardItems());
            for(CardItem cardItem : request.getCardItems()){
                Hibernate.initialize(cardItem.getTech());
                Hibernate.initialize(cardItem.getTech().getTechImages());
                Hibernate.initialize(cardItem.getTech().getTechType());
            }
            request.getCardItems().sort((n1, n2) -> n1.getTech().getName().compareTo(n2.getTech().getName()));
            model.put("request", request);
            model.put("cartItems", request.getCardItems());
        }

        return "/client/cart";
    }

    @GetMapping("/cart/increase/{id}")
    public String techCartIncreaseGet(@PathVariable long id, @AuthenticationPrincipal Account account, Map<String, Object> model){
        Tech tech = techRepo.findById(id).get();

        cartService.changeCount(account, tech, 1);

        return "redirect:/client/cart";
    }

    @GetMapping("/cart/decrease/{id}")
    public String techCartDecreaseGet(@PathVariable long id, @AuthenticationPrincipal Account account, Map<String, Object> model){
        Tech tech = techRepo.findById(id).get();

        cartService.changeCount(account, tech, -1);

        return "redirect:/client/cart";
    }

    @GetMapping("/cart/delete-item/{id}")
    public String techCartDeleteGet(@PathVariable long id, @AuthenticationPrincipal Account account, Map<String, Object> model){
        Tech tech = techRepo.findById(id).get();

        cartService.removeFromCart(account, tech);

        return "redirect:/client/cart";
    }

    @PostMapping("/add-order")
    public String orderPost(@AuthenticationPrincipal Account account, @RequestParam String description, Map<String, Object> model){
        Request request = cartService.getCart(account);

        request.setCreationDate(new Date());
        request.setDescription(description);
        requestRepo.save(request);

        ActiveRequest activeRequest = new ActiveRequest();
        activeRequest.setRequest(request);
        activeRequest.setDescription("");
        activeRequest.setStatus(RequestStatus.ACTIVE);
        activeRequestRepo.save(activeRequest);

        return "redirect:/client/cart";
    }

    @GetMapping("/orders")
    public String ordersGet(@AuthenticationPrincipal Account account, Map<String, Object> model){
        List<ActiveRequest> activeRequests = activeRequestRepo.findByRequest_ClientProfile_Account_Id(account.getId());
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

        return "/client/orders";
    }

    @GetMapping("/history")
    public String historyGet(@AuthenticationPrincipal Account account, Map<String, Object> model){
        List<ActiveRequest> activeRequests = activeRequestRepo.findByRequest_ClientProfile_Account_Id(account.getId());
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

        return "/client/history";
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

        return "/client/order";
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

        return "/client/historyOrder";
    }
}
