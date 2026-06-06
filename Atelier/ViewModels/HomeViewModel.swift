//
//  HomeViewModel.swift
//  Atelier
//
//  Created by Thiago Pires on 06/06/26.
//

import SwiftUI

enum ClothingCategory: String, CaseIterable {
    case all    = "ALL"
    case mens   = "MEN"
    case womens = "WOMEN"
}

@Observable
final class HomeViewModel {
    var products: [Product] = []
    var selectedCategory: ClothingCategory = .all
    var isLoading = false
    var error: String?

    var filteredProducts: [Product] {
        switch selectedCategory {
        case .all:    return products
        case .mens:   return products.filter { $0.isMens }
        case .womens: return products.filter { $0.isWomens }
        }
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await APIService.shared.fetchClothingProducts()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
