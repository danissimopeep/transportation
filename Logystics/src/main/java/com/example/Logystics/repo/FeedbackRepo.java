package com.example.Logystics.repo;

import com.example.Logystics.domain.Feedback;
import org.springframework.data.repository.CrudRepository;

public interface FeedbackRepo extends CrudRepository<Feedback, Long> {
}
