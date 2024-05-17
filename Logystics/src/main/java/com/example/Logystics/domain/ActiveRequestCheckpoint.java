package com.example.Logystics.domain;

import lombok.*;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "ActiveRequestCheckpoint")
public class ActiveRequestCheckpoint {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @ManyToOne(optional = false, cascade = CascadeType.REMOVE, fetch = FetchType.LAZY)
    @JoinColumn(name="active_request_id")
    private ActiveRequest request;
    @Column(length = 1000)
    @Length(max = 1000)
    private String description;
    private RequestStatus oldStatus;
    private RequestStatus newStatus;
    private Date date;

    public String getLocalDate(){
        SimpleDateFormat fmt = new SimpleDateFormat("dd.MM.yyyy");
        return fmt.format(date);
    }
}
