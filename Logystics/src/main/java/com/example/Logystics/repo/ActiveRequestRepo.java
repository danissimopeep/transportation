package com.example.Logystics.repo;

import com.example.Logystics.domain.ActiveRequest;
import com.example.Logystics.domain.RequestStatus;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ActiveRequestRepo extends CrudRepository<ActiveRequest, Long> {
    List<ActiveRequest> findByRequest_ClientProfile_Account_Id(Long id);
    List<ActiveRequest> findByManagerProfile_Account_Id(Long id);
    List<ActiveRequest> findByStatus(RequestStatus status);
    List<ActiveRequest> findByStatusIsNot(RequestStatus status);
}
