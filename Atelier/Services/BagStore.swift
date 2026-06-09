//
//  BagStore.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

@Observable
final class BagStore {
    var items: [BagItem] = []

    var total: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func add(_ product: Product) {
        if let idx = items.firstIndex(where: { $0.id == product.id }) {
            items[idx].quantity += 1
        } else {
            items.append(BagItem(id: product.id, product: product, quantity: 1))
        }
    }

    func remove(id: Int) {
        items.removeAll { $0.id == id }
    }

    func increment(id: Int) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items[idx].quantity += 1
    }

    func decrement(id: Int) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        if items[idx].quantity > 1 {
            items[idx].quantity -= 1
        } else {
            items.remove(at: idx)
        }
    }
}
