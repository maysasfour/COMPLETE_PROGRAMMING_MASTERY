package com.example.inventory.security;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Service-to-service auth for an internal-only API: only a caller that knows the
 * shared secret (order-service) may reserve/release stock. Deliberately a plain
 * header check rather than full Spring Security -- this endpoint is never meant
 * to be reached by an end user's browser, only by another trusted backend service.
 */
@Component
public class InternalApiKeyFilter implements Filter {

    @Value("${internal.api-key}")
    private String expectedKey;

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // product catalog reads stay public; only mutating reserve/release calls are gated
        if (request.getMethod().equals("GET")) {
            chain.doFilter(req, res);
            return;
        }

        String providedKey = request.getHeader("X-Internal-Api-Key");
        if (expectedKey.equals(providedKey)) {
            chain.doFilter(req, res);
        } else {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\":\"missing or invalid X-Internal-Api-Key\"}");
        }
    }
}
