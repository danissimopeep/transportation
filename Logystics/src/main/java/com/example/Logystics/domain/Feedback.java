package com.example.Logystics.domain;

import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.text.SimpleDateFormat;
import java.util.Date;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "Feedback")
public class Feedback {
    @Id
    @Setter(AccessLevel.PROTECTED)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @ManyToOne(optional = true, cascade = CascadeType.DETACH, fetch = FetchType.LAZY)
    @JoinColumn(name="creator_id")
    private ClientProfile creator;
    private Date creationDate;
    @NotBlank(message = "Заголовок не может быть пустым")
    private String title;
    @NotBlank(message = "Текст не может быть пустым")
    private String text;

    public String getLocalCreationDate(){
        SimpleDateFormat fmt = new SimpleDateFormat("dd.MM.yyyy");
        return fmt.format(creationDate);
    }
}
