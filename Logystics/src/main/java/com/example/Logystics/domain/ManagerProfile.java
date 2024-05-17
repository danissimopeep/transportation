package com.example.Logystics.domain;

import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "ManagerProfile")
public class ManagerProfile {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotBlank(message = "ФИО не может быть пустым")
    private String credentials;
    @NotBlank(message = "Телефон не может быть пустым")
    private String telephone;
    @OneToOne(optional = false, cascade=CascadeType.DETACH, fetch = FetchType.LAZY)
    @JoinColumn (name="account_id")
    private Account account;
    @OneToMany (orphanRemoval = false, mappedBy = "managerProfile", fetch = FetchType.LAZY)
    private List<ActiveRequest> activeRequests;
}
