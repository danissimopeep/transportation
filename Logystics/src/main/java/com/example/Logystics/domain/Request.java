package com.example.Logystics.domain;

import lombok.*;
import org.hibernate.Hibernate;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "Request")
public class Request {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @ManyToOne(optional = true, cascade = CascadeType.DETACH, fetch = FetchType.LAZY)
    @JoinColumn(name="client_id")
    private ClientProfile clientProfile;
    @OneToMany (orphanRemoval = true, mappedBy = "request", fetch = FetchType.EAGER)
    private List<CardItem> cardItems;
    private Date creationDate;
    @Column(length = 1000)
    @Length(max = 1000)
    private String description;

    public Double getTotalCost(){
        Double total = 0.;
        for(CardItem cardItem: cardItems){
            Hibernate.initialize(cardItem.getTech());
            total += cardItem.getTech().getCost() * cardItem.getCount();
        }

        return total;
    }

    public String getLocalCreationDate(){
        SimpleDateFormat fmt = new SimpleDateFormat("dd.MM.yyyy");
        return fmt.format(creationDate);
    }
}
