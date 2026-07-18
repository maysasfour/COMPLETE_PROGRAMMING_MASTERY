// solution-03.go - Exercise 03: slice/map sales report built with plain stdlib, plus a closure.
package main

import (
	"fmt"
	"sort"
)

type Sale struct {
	Product, Region string
	Amount          float64
}

// filterSales is the one reusable closure-taking helper the exercise asked for -- passing a
// func(Sale) bool as a value is what makes it generic over "which condition", not the type system.
func filterSales(sales []Sale, keep func(Sale) bool) []Sale {
	var out []Sale
	for _, s := range sales {
		if keep(s) {
			out = append(out, s)
		}
	}
	return out
}

func main() {
	sales := []Sale{
		{"Widget", "East", 120.50},
		{"Gadget", "West", 300.00},
		{"Widget", "West", 75.25},
		{"Gizmo", "East", 210.00},
		{"Gadget", "East", 150.75},
		{"Widget", "North", 90.00},
		{"Gizmo", "West", 60.40},
		{"Gadget", "North", 400.10},
		{"Widget", "East", 55.00},
		{"Gizmo", "North", 130.20},
	}

	// --- revenue per product, sorted descending ---
	revenueByProduct := make(map[string]float64)
	for _, s := range sales {
		revenueByProduct[s.Product] += s.Amount
	}
	products := make([]string, 0, len(revenueByProduct))
	for p := range revenueByProduct {
		products = append(products, p)
	}
	sort.Slice(products, func(i, j int) bool {
		return revenueByProduct[products[i]] > revenueByProduct[products[j]]
	})
	fmt.Println("--- revenue per product (descending) ---")
	for _, p := range products {
		fmt.Printf("  %-8s %.2f\n", p, revenueByProduct[p])
	}

	// --- single highest-value sale, tracked in one pass ---
	highest := sales[0]
	for _, s := range sales[1:] {
		if s.Amount > highest.Amount {
			highest = s
		}
	}
	fmt.Printf("\nhighest-value sale: %s in %s for %.2f\n", highest.Product, highest.Region, highest.Amount)

	// --- regions selling 2+ distinct products ---
	productsByRegion := make(map[string]map[string]bool)
	for _, s := range sales {
		if productsByRegion[s.Region] == nil {
			productsByRegion[s.Region] = make(map[string]bool)
		}
		productsByRegion[s.Region][s.Product] = true
	}
	fmt.Println("\n--- regions selling 2+ distinct products ---")
	for region, products := range productsByRegion {
		if len(products) >= 2 {
			fmt.Printf("  %s (%d distinct products)\n", region, len(products))
		}
	}

	// --- average sale amount, using the closure helper for a filtered subset too ---
	var total float64
	for _, s := range sales {
		total += s.Amount
	}
	fmt.Printf("\naverage sale amount: %.2f\n", total/float64(len(sales)))

	eastSales := filterSales(sales, func(s Sale) bool { return s.Region == "East" })
	fmt.Printf("east-region sale count (via filterSales closure): %d\n", len(eastSales))
}
