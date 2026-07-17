package com.example.orderservice.security;

import com.example.orderservice.model.Customer;
import com.example.orderservice.repo.CustomerRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;
    private final CustomerRepository customerRepository;

    public AuthController(JwtService jwtService, PasswordEncoder passwordEncoder, CustomerRepository customerRepository) {
        this.jwtService = jwtService;
        this.passwordEncoder = passwordEncoder;
        this.customerRepository = customerRepository;
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody LoginRequest request) {
        Customer customer = customerRepository.findByUsername(request.username()).orElse(null);
        if (customer == null || !passwordEncoder.matches(request.password(), customer.getPasswordHash())) {
            return ResponseEntity.status(401).build();
        }
        String token = jwtService.generateToken(customer.getUsername());
        return ResponseEntity.ok(Map.of("token", token));
    }
}
