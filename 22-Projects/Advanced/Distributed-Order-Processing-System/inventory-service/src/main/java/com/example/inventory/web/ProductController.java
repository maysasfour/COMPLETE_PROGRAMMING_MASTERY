package com.example.inventory.web;

import com.example.inventory.dto.ProductResponse;
import com.example.inventory.dto.ReserveRequest;
import com.example.inventory.model.Product;
import com.example.inventory.repo.ProductRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
public class ProductController {

    private final ProductRepository productRepository;

    public ProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping("/products")
    public List<ProductResponse> listProducts() {
        return productRepository.findAll().stream().map(ProductResponse::from).toList();
    }

    @GetMapping("/products/{sku}")
    public ResponseEntity<ProductResponse> getProduct(@PathVariable String sku) {
        return productRepository.findById(sku)
                .map(product -> ResponseEntity.ok(ProductResponse.from(product)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/products/{sku}/reserve")
    @Transactional
    public ResponseEntity<?> reserve(@PathVariable String sku, @RequestBody ReserveRequest request) {
        Product product = productRepository.findById(sku).orElse(null);
        if (product == null) {
            return ResponseEntity.notFound().build();
        }
        if (!product.reserve(request.quantity())) {
            return ResponseEntity.status(409).body(Map.of(
                    "error", "Insufficient stock",
                    "requested", request.quantity(),
                    "available", product.getQuantityAvailable()
            ));
        }
        productRepository.save(product);
        return ResponseEntity.ok(ProductResponse.from(product));
    }

    @PostMapping("/products/{sku}/release")
    @Transactional
    public ResponseEntity<?> release(@PathVariable String sku, @RequestBody ReserveRequest request) {
        Product product = productRepository.findById(sku).orElse(null);
        if (product == null) {
            return ResponseEntity.notFound().build();
        }
        product.release(request.quantity());
        productRepository.save(product);
        return ResponseEntity.ok(ProductResponse.from(product));
    }
}
