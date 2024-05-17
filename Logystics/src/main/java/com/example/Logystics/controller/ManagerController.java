package com.example.Logystics.controller;

import com.example.Logystics.domain.*;
import com.example.Logystics.repo.*;
import org.hibernate.Hibernate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager")
@PreAuthorize("hasAuthority('MANAGER')")
public class ManagerController {
    private final ActiveRequestRepo activeRequestRepo;
    private final ActiveRequestCheckpointRepo activeRequestCheckpointRepo;

    public ManagerController(ActiveRequestRepo activeRequestRepo,
                             ActiveRequestCheckpointRepo activeRequestCheckpointRepo) {
        this.activeRequestRepo = activeRequestRepo;
        this.activeRequestCheckpointRepo = activeRequestCheckpointRepo;
    }

    @GetMapping("/orders")
    public String ordersGet(@AuthenticationPrincipal Account account, Map<String, Object> model){
        List<ActiveRequest> activeRequests = activeRequestRepo.findByManagerProfile_Account_Id(account.getId());
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

        return "/manager/orders";
    }

    @GetMapping("/history")
    public String historyGet(@AuthenticationPrincipal Account account, Map<String, Object> model){
        List<ActiveRequest> activeRequests = activeRequestRepo.findByManagerProfile_Account_Id(account.getId());
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

        return "/manager/history";
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

        return "/manager/order";
    }

    @PostMapping("/order/{id}")
    public String orderPost(@PathVariable Long id, @RequestParam Integer status, @RequestParam String text, Map<String, Object> model){
        ActiveRequest activeRequest = activeRequestRepo.findById(id).get();

        RequestStatus oldStatus = activeRequest.getStatus();
        RequestStatus newStatus = RequestStatus.getStatusFromInt(status);
        if(!oldStatus.equals(status)){
            ActiveRequestCheckpoint activeRequestCheckpoint = new ActiveRequestCheckpoint();
            activeRequestCheckpoint.setRequest(activeRequest);
            activeRequestCheckpoint.setDescription(text);
            activeRequestCheckpoint.setOldStatus(oldStatus);
            activeRequestCheckpoint.setNewStatus(newStatus);
            activeRequestCheckpoint.setDate(new Date());

            activeRequestCheckpointRepo.save(activeRequestCheckpoint);
        }

        activeRequest.setStatus(newStatus);
        activeRequest.setDescription(text);
        activeRequestRepo.save(activeRequest);

        return "redirect:/manager/order/" + id;
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

        return "/manager/historyOrder";
    }
}
