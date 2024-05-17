package com.example.Logystics.domain;

import lombok.*;
import org.hibernate.Hibernate;

import javax.persistence.*;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "TechType")
public class TechType {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String name;
    @OneToMany (orphanRemoval = false, mappedBy = "techType", fetch = FetchType.LAZY)
    private List<Tech> techs;

    private boolean deleted = false;
    public Integer getCountOfTechs(){
        Hibernate.initialize(techs);
        Integer count = 0;
        for(Tech tech: techs){
            if(!tech.isDeleted())
                count++;
        }
        return techs.size();
    }
}
