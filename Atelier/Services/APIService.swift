//
//  APIService.swift
//  Atelier
//
//  Created by Thiago Pires on 05/06/26.
//

import Foundation

final class APIService {
    static let shared = APIService()
    private let baseURL = "https://fakestoreapi.com"

    private init() {}

    func fetchClothingProducts() async throws -> [Product] {
        guard let url = URL(string: "\(baseURL)/products") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let products = try JSONDecoder().decode([Product].self, from: data)
        return products.filter { $0.isClothing }
    }
}
