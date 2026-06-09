//
//  SearchViewModel.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

@Observable
final class SearchViewModel {
    var products: [Product] = []
    var selectedCategory: ClothingCategory = .all
    var searchQuery = ""
    var isLoading = false

    var results: [Product] {
        let base: [Product]
        switch selectedCategory {
        case .all:    base = products
        case .mens:   base = products.filter { $0.isMens }
        case .womens: base = products.filter { $0.isWomens }
        }
        guard !searchQuery.isEmpty else { return base }
        return base.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await APIService.shared.fetchClothingProducts()
        } catch {}
    }
}
