package com.example.Logystics.domain;

import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.util.Collection;
import java.util.Collections;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "Account")
public class Account implements UserDetails {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotBlank(message = "Логин не может быть пустым")
    private String username;
    @NotBlank(message = "Пароль не может быть пустым")
    private String password;
    @Enumerated(EnumType.STRING)
    private Role role;
    private boolean active = true;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(getRole());
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }
    @Override
    public boolean isEnabled() {
        return active;
    }
    public boolean isAdmin() {return role == Role.ADMIN;}
    public boolean isClient() {return role == Role.CLIENT;}
    public boolean isManager() {return role == Role.MANAGER;}
}