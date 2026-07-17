package com.example.library.security;

import com.example.library.model.Member;
import com.example.library.repo.MemberRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;
    private final MemberRepository memberRepository;

    public AuthController(JwtService jwtService, PasswordEncoder passwordEncoder, MemberRepository memberRepository) {
        this.jwtService = jwtService;
        this.passwordEncoder = passwordEncoder;
        this.memberRepository = memberRepository;
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody LoginRequest request) {
        Member member = memberRepository.findByUsername(request.username()).orElse(null);
        if (member == null || !passwordEncoder.matches(request.password(), member.getPasswordHash())) {
            return ResponseEntity.status(401).build();
        }
        String token = jwtService.generateToken(member.getUsername(), List.of(member.getRole().name()));
        return ResponseEntity.ok(Map.of("token", token));
    }
}
