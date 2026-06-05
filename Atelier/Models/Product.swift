//
//  Product.swift
//  Atelier
//
//  Created by Thiago Pires on 05/06/26.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
}

extension Product {
    var isClothing: Bool {
        category == "men's clothing" || category == "women's clothing"
    }

    var isMens: Bool { category == "men's clothing" }
    var isWomens: Bool { category == "women's clothing" }
}
