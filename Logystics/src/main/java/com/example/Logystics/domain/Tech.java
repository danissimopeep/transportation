package com.example.Logystics.domain;

import lombok.*;
import org.hibernate.Hibernate;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "Tech")
public class Tech {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotBlank(message = "Название не может быть пустым")
    private String name;
    @Column(length = 1000)
    @Length(max = 1000)
    private String description;
    @Min(0)
    private Double cost;
    private boolean deleted;
    @ManyToOne(optional = true, cascade = CascadeType.DETACH, fetch = FetchType.LAZY)
    @JoinColumn(name="tech_type_id")
    private TechType techType;
    @OneToMany (orphanRemoval = false, mappedBy = "tech", fetch = FetchType.LAZY)
    private List<TechImage> techImages;
    @OneToMany (orphanRemoval = false, mappedBy = "tech", fetch = FetchType.LAZY)
    private List<CardItem> cardItems;

    public TechImage getFirstImage(){
        Hibernate.initialize(techImages);

        if(!techImages.isEmpty())
            return techImages.get(0);

        return null;
    }
}
