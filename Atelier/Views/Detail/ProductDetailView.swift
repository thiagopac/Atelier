//
//  ProductDetailView.swift
//  Atelier
//
//  Created by Thiago Pires on 08/06/26.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @Environment(BagStore.self) private var bagStore
    @State private var justAdded = false

    var body: some View {
        ZStack {
            Color.atelierBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        imageSection
                        infoSection
                    }
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    bottomCTA.padding(.bottom, 60)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(Circle().fill(Color.atelierSurface))
                    .overlay(Circle().strokeBorder(Color.atelierBorder, lineWidth: 1))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    // MARK: - Image Section

    private var imageSection: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.94)

            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(40)
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundStyle(.gray.opacity(0.4))
                default:
                    ProgressView()
                        .tint(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 440)
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(product.category.uppercased())
                .font(.system(size: 10, weight: .semibold))
                .tracking(4)
                .foregroundStyle(Color.atelierAccent)
                .padding(.top, 28)
                .padding(.bottom, 12)

            Text(product.title)
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(.white)
                .lineSpacing(2)
                .padding(.bottom, 16)

            Text("$\(String(format: "%.2f", product.price))")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .padding(.bottom, 28)

            Rectangle()
                .fill(Color.atelierBorder)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .padding(.bottom, 28)

            Text("DESCRIPTION")
                .font(.system(size: 10, weight: .bold))
                .tracking(4)
                .foregroundStyle(Color.atelierSecondary)
                .padding(.bottom, 14)

            Text(product.description)
                .font(.system(size: 14, weight: .light))
                .foregroundStyle(Color.atelierSecondary)
                .lineSpacing(6)
                .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }

    // MARK: - Bottom CTA

    private var bottomCTA: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.atelierBorder)
                .frame(height: 1)

            HStack(spacing: 0) {
                Button {
                    bagStore.add(product)
                    justAdded = true
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(1.5))
                        justAdded = false
                    }
                } label: {
                    Text(justAdded ? "ADDED TO BAG ✓" : "ADD TO BAG")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(3)
                        .foregroundStyle(justAdded ? Color.atelierBackground : Color.atelierBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(justAdded ? Color.atelierAccent : Color.white)
                        .animation(.easeInOut(duration: 0.25), value: justAdded)
                }

                Rectangle()
                    .fill(Color.atelierBorder)
                    .frame(width: 1, height: 52)

                Button {} label: {
                    Image(systemName: "heart")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 52)
                        .background(Color.atelierSurface)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.atelierBackground)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product(
            id: 3,
            title: "Mens Cotton Jacket",
            price: 55.99,
            description: "great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors.",
            category: "men's clothing",
            image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg"
        ))
    }
    .environment(BagStore())
}
