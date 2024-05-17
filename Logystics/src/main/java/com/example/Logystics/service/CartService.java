package com.example.Logystics.service;

import com.example.Logystics.domain.*;
import com.example.Logystics.repo.*;
import org.hibernate.Hibernate;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
public class CartService {
    private final RequestRepo requestRepo;
    private final ActiveRequestRepo activeRequestRepo;
    private final ClientProfileRepo clientProfileRepo;
    private final CardItemRepo cardItemRepo;

    public CartService(RequestRepo requestRepo, ActiveRequestRepo activeRequestRepo,
                       ClientProfileRepo clientProfileRepo,
                       CardItemRepo cardItemRepo) {
        this.requestRepo = requestRepo;
        this.activeRequestRepo = activeRequestRepo;
        this.clientProfileRepo = clientProfileRepo;
        this.cardItemRepo = cardItemRepo;
    }

    public Request getCart(Account account){
        List<ActiveRequest> activeRequests = activeRequestRepo.findByRequest_ClientProfile_Account_Id(account.getId());
        List<Request> requests = requestRepo.findByClientProfile_Account_Id(account.getId());

        if(requests == null || requests.isEmpty())
            return null;

        if(activeRequests == null || activeRequests.isEmpty())
            return requests.get(0);

        for(Request request : requests){

            boolean isFound = false;
            for(ActiveRequest activeRequest: activeRequests){
                if(Objects.equals(request.getId(), activeRequest.getRequest().getId())){
                    isFound = true;
                    break;
                }
            }

            if(!isFound)
                return request;
        }

        return null;
    }

    public void addToCart(Account account, Tech tech){
        Request request = getCart(account);

        if(request == null){
            ClientProfile clientProfile = clientProfileRepo.findByAccount_Id(account.getId());

            request = new Request();
            request.setCreationDate(new Date());
            request.setDescription("-");
            request.setClientProfile(clientProfile);

            requestRepo.save(request);
            request = getCart(account);
        }

        boolean isFound = false;
        if(request.getCardItems() != null){
            for(CardItem cardItem : request.getCardItems()){
                Hibernate.initialize(cardItem.getTech());
                if(cardItem.getTech().getId().equals(tech.getId())){
                    cardItem.setCount(cardItem.getCount() + 1);
                    isFound = true;
                    cardItemRepo.save(cardItem);
                    break;
                }
            }
        }

        if(!isFound){
            CardItem cardItem = new CardItem();
            cardItem.setCount(1);
            cardItem.setRequest(request);
            cardItem.setTech(tech);
            cardItemRepo.save(cardItem);
        }
    }

    public void removeFromCart(Account account, Tech tech){
        Request request = getCart(account);

        if(request == null)
            return;

        for(CardItem cardItem : request.getCardItems()){
            Hibernate.initialize(cardItem.getTech());
            if(cardItem.getTech().getId().equals(tech.getId())){
                cardItemRepo.deleteById(cardItem.getId());

                request = getCart(account);
                if(request.getCardItems().size() == 1)
                    requestRepo.deleteById(request.getId());
                return;
            }
        }
    }

    public void changeCount(Account account, Tech tech, int delta){
        if(delta > 0) {
            for(int i=0; i<delta; i++)
                addToCart(account, tech);
        }
        else if(delta < 0){
            Request request = getCart(account);
            if(request == null)
                return;

            for(CardItem cardItem : request.getCardItems()){
                Hibernate.initialize(cardItem.getTech());
                if(cardItem.getTech().getId().equals(tech.getId())){
                    cardItem.setCount(cardItem.getCount() + delta);

                    if(cardItem.getCount() > 0)
                        cardItemRepo.save(cardItem);
                    else
                        removeFromCart(account, tech);

                    break;
                }
            }
        }
    }
}
