//
//  ProductViewModel.swift
//  AssignmentStuck
//
//  Created by Sambhav Singh on 06/03/25.
//

import SwiftUI

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var showingAddProduct: Bool = false
    @Published var message: String = ""
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { product in
                product.productName.localizedCaseInsensitiveContains(searchText) ||
                product.productType.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // Fetch products from the API
    @MainActor
    func fetchProducts() async {
        do {
            self.products = try await APIService.shared.getProducts()
        } catch {
            print("Error fetching products: \(error)")
        }
    }
    
    // Add product using the API service
    @MainActor
    func addProduct(_ product: Product, imageData: Data?) async -> Bool {
        do {
            let success = try await APIService.shared.addProduct(product, imageData: imageData)
            if success {
                await fetchProducts()
            }
            return success
        } catch {
            self.message = "Error adding product: \(error.localizedDescription)"
            return false
        }
    }
}
