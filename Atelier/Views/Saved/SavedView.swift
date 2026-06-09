//
//  SavedView.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

struct SavedView: View {
    @Environment(SavedStore.self) private var savedStore

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        ZStack {
            Color.atelierBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                Rectangle()
                    .fill(Color.atelierBorder)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)

                if savedStore.items.isEmpty {
                    emptyState
                } else {
                    savedGrid
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Text("SAVED")
                .font(.system(size: 28, weight: .black))
                .tracking(4)
                .foregroundStyle(.white)

            if savedStore.itemCount > 0 {
                Text("\(savedStore.itemCount) \(savedStore.itemCount == 1 ? "ITEM" : "ITEMS")")
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

            Image(systemName: "heart")
                .font(.system(size: 52, weight: .ultraLight))
                .foregroundStyle(Color.atelierBorder)
                .padding(.bottom, 28)

            Text("NOTHING SAVED YET")
                .font(.system(size: 14, weight: .black))
                .tracking(4)
                .foregroundStyle(.white)
                .padding(.bottom, 12)

            Text("Save pieces you love for later")
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

    // MARK: - Grid

    private var savedGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(savedStore.items) { product in
                    ZStack(alignment: .topTrailing) {
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            savedCard(product)
                        }
                        .buttonStyle(.plain)

                        Button {
                            withAnimation(.easeOut(duration: 0.2)) {
                                savedStore.remove(id: product.id)
                            }
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(Color.atelierAccent)
                                .frame(width: 30, height: 30)
                                .background(Color.atelierBackground.opacity(0.75))
                        }
                        .padding(8)
                    }
                }
            }
            .animation(.easeOut(duration: 0.2), value: savedStore.itemCount)
            .padding(.bottom, 100)
        }
    }

    private func savedCard(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.94)

                AsyncImage(url: URL(string: product.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(16)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundStyle(.gray.opacity(0.4))
                    default:
                        ProgressView().tint(.gray)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.atelierSecondary)
                    .lineLimit(2)

                Text("$\(String(format: "%.2f", product.price))")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 68, alignment: .topLeading)
            .background(Color.atelierSurface)
        }
    }
}

#Preview {
    let store = SavedStore()
    store.toggle(Product(
        id: 1,
        title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        price: 109.95,
        description: "Your perfect pack.",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/81fAn-gc4FL._AC_UX679_.jpg"
    ))
    store.toggle(Product(
        id: 2,
        title: "Womens Casual Premium T-Shirt",
        price: 22.30,
        description: "Slim-fitting style.",
        category: "women's clothing",
        image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg"
    ))
    return NavigationStack { SavedView() }
        .environment(store)
        .environment(BagStore())
}
