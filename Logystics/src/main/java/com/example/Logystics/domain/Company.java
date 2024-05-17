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
@Table(name = "Company")
public class Company {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotBlank(message = "Название компании не может быть пустым")
    private String name;
    @Column(length = 1000)
    private String description;
    @NotBlank(message = "Телефон не может быть пустым")
    private String telephone;
    @NotBlank(message = "Почта не может быть пустой")
    private String email;
    private String address;
    @OneToMany (orphanRemoval = false, mappedBy = "company", fetch = FetchType.LAZY)
    private List<ClientProfile> clients;
}
