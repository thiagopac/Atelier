//
//  SavedStore.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

@Observable
final class SavedStore {
    var items: [Product] = []

    var itemCount: Int { items.count }

    func toggle(_ product: Product) {
        if let idx = items.firstIndex(where: { $0.id == product.id }) {
            items.remove(at: idx)
        } else {
            items.insert(product, at: 0)
        }
    }

    func isSaved(_ product: Product) -> Bool {
        items.contains(where: { $0.id == product.id })
    }

    func remove(id: Int) {
        items.removeAll { $0.id == id }
    }
}
