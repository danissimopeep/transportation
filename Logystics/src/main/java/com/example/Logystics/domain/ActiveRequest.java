package com.example.Logystics.domain;

import lombok.*;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "ActiveRequest")
public class ActiveRequest {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @OneToOne(optional = false, cascade=CascadeType.DETACH, fetch = FetchType.EAGER)
    @JoinColumn (name="request_id")
    private Request request;
    @Column(length = 1000)
    @Length(max = 1000)
    private String description;
    private RequestStatus status;
    @ManyToOne(optional = true, cascade = CascadeType.DETACH, fetch = FetchType.LAZY)
    @JoinColumn(name="manager_id")
    private ManagerProfile managerProfile;
    @OneToMany (orphanRemoval = false, mappedBy = "request", fetch = FetchType.LAZY)
    private List<ActiveRequestCheckpoint> activeRequestCheckpoints;

    public String getStrStatus(){
        return status.getStrValue();
    }
}
