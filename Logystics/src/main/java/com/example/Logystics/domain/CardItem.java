package com.example.Logystics.domain;

import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "CardItem")
public class CardItem {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne(optional = false, cascade = CascadeType.DETACH, fetch = FetchType.LAZY)
    @JoinColumn(name="tech_id")
    private Tech tech;
    @ManyToOne(optional = true, cascade = CascadeType.DETACH, fetch = FetchType.LAZY)
    @JoinColumn(name="request_id")
    private Request request;
    private Integer count;
}
