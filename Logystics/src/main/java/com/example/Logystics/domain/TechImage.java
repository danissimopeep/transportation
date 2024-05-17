package com.example.Logystics.domain;

import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "TechImage")
public class TechImage {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String path;

    @ManyToOne(optional = false, cascade = CascadeType.DETACH, fetch = FetchType.LAZY)
    @JoinColumn(name="tech_id")
    private Tech tech;
}
