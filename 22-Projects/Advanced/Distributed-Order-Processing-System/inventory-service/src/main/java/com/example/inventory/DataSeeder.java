package com.example.inventory;

import com.example.inventory.model.Product;
import com.example.inventory.repo.ProductRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataSeeder implements CommandLineRunner {

    private final ProductRepository productRepository;

    public DataSeeder(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public void run(String... args) {
        productRepository.save(new Product("SKU-KEYBOARD", "Mechanical Keyboard", 5));
        productRepository.save(new Product("SKU-MOUSE", "Wireless Mouse", 0));
        productRepository.save(new Product("SKU-MONITOR", "27-inch Monitor", 2));
    }
}
