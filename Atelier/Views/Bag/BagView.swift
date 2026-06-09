//
//  BagView.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

struct BagView: View {
    @Environment(BagStore.self) private var bagStore

    var body: some View {
        ZStack {
            Color.atelierBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                Rectangle()
                    .fill(Color.atelierBorder)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)

                if bagStore.items.isEmpty {
                    emptyState
                } else {
                    ScrollView(showsIndicators: false) {
                        itemList
                    }
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        checkoutBar.padding(.bottom, 60)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Text("BAG")
                .font(.system(size: 28, weight: .black))
                .tracking(4)
                .foregroundStyle(.white)

            if bagStore.itemCount > 0 {
                Text("\(bagStore.itemCount) \(bagStore.itemCount == 1 ? "ITEM" : "ITEMS")")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(3)
                    .foregroundStyle(Color.atelierSecondary)
                    .padding(.bottom, 3)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()

            Image(systemName: "bag")
                .font(.system(size: 52, weight: .ultraLight))
                .foregroundStyle(Color.atelierBorder)
                .padding(.bottom, 28)

            Text("YOUR BAG IS EMPTY")
                .font(.system(size: 14, weight: .black))
                .tracking(4)
                .foregroundStyle(.white)
                .padding(.bottom, 12)

            Text("Discover pieces for your wardrobe")
                .font(.system(size: 13, weight: .light))
                .foregroundStyle(Color.atelierSecondary)
                .padding(.bottom, 36)

            Button {} label: {
                Text("EXPLORE COLLECTION  →")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .overlay {
                        Rectangle().stroke(.white, lineWidth: 1)
                    }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 94)
    }

    // MARK: - Item List

    private var itemList: some View {
        VStack(spacing: 0) {
            ForEach(bagStore.items) { item in
                itemRow(item)
                Rectangle()
                    .fill(Color.atelierBorder)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
            }
        }
    }

    private func itemRow(_ item: BagItem) -> some View {
        HStack(alignment: .top, spacing: 0) {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.94)

                AsyncImage(url: URL(string: item.product.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(12)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundStyle(.gray.opacity(0.4))
                    default:
                        ProgressView().tint(.gray)
                    }
                }
            }
            .frame(width: 110)
            .frame(maxHeight: .infinity)

            VStack(alignment: .leading, spacing: 0) {
                Text(item.product.category.uppercased())
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(3)
                    .foregroundStyle(Color.atelierAccent)
                    .padding(.bottom, 8)

                Text(item.product.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(3)
                    .lineSpacing(2)
                    .padding(.bottom, 12)

                Text("$\(String(format: "%.2f", item.product.price))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)

                Spacer(minLength: 16)

                HStack(spacing: 0) {
                    quantityControl(item: item)
                    Spacer()
                    removeButton(item: item)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 140)
    }

    private func quantityControl(item: BagItem) -> some View {
        HStack(spacing: 0) {
            Button { bagStore.decrement(id: item.id) } label: {
                Text("−")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.atelierElevated)
            }

            Rectangle()
                .fill(Color.atelierBorder)
                .frame(width: 1, height: 36)

            Text("\(item.quantity)")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 42, height: 36)
                .background(Color.atelierSurface)

            Rectangle()
                .fill(Color.atelierBorder)
                .frame(width: 1, height: 36)

            Button { bagStore.increment(id: item.id) } label: {
                Text("+")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.atelierElevated)
            }
        }
        .overlay {
            Rectangle().stroke(Color.atelierBorder, lineWidth: 1)
        }
    }

    private func removeButton(item: BagItem) -> some View {
        Button { bagStore.remove(id: item.id) } label: {
            Image(systemName: "xmark")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color.atelierSecondary)
                .frame(width: 32, height: 32)
                .background(Color.atelierElevated)
                .overlay {
                    Rectangle().stroke(Color.atelierBorder, lineWidth: 1)
                }
        }
    }

    // MARK: - Checkout Bar

    private var checkoutBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.atelierBorder)
                .frame(height: 1)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SUBTOTAL")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(3)
                        .foregroundStyle(Color.atelierSecondary)

                    Text("\(bagStore.itemCount) \(bagStore.itemCount == 1 ? "item" : "items")")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.atelierSecondary.opacity(0.6))
                }

                Spacer()

                Text("$\(String(format: "%.2f", bagStore.total))")
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)

            Rectangle()
                .fill(Color.atelierBorder)
                .frame(height: 1)

            Button {} label: {
                Text("PROCEED TO CHECKOUT")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(Color.atelierBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
        }
        .background(Color.atelierBackground)
    }
}

#Preview {
    let store = BagStore()
    store.add(Product(
        id: 1,
        title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        price: 109.95,
        description: "Your perfect pack for everyday use and walks in the forest.",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/81fAn-gc4FL._AC_UX679_.jpg"
    ))
    store.add(Product(
        id: 2,
        title: "Womens Casual Premium T-Shirt",
        price: 22.30,
        description: "Slim-fitting style, contrast raglan long sleeve.",
        category: "women's clothing",
        image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg"
    ))
    return NavigationStack { BagView() }
        .environment(store)
}
