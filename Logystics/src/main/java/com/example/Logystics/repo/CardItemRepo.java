package com.example.Logystics.repo;

import com.example.Logystics.domain.CardItem;
import org.springframework.data.repository.CrudRepository;

public interface CardItemRepo extends CrudRepository<CardItem, Long> {
}
