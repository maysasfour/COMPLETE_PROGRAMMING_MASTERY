package com.example.taskapi;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Extending JpaRepository provides save/findById/findAll/deleteById/count/etc.
 * with NO implementation code written at all -- Spring Data generates a real,
 * working implementation of this interface at startup.
 *
 * findByDoneFalse() is a DERIVED QUERY: Spring Data parses the METHOD NAME itself
 * ("findBy" + "Done" + "False") and generates the corresponding SQL automatically
 * (SELECT * FROM task WHERE done = false) -- no query string written anywhere.
 */
public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByDoneFalse();
}
