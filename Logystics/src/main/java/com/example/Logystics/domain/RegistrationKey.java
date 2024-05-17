package com.example.Logystics.domain;

import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "RegistrationKey")
public class RegistrationKey {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotBlank(message = "Ключ не может быть пустым")
    private String key;
    @NotBlank(message = "Имя пользователя не может быть пустым")
    private String username;
    @NotBlank(message = "Имя создателя не может быть пустым")
    private String creator;
    @Enumerated(EnumType.STRING)
    private Role role;
}
