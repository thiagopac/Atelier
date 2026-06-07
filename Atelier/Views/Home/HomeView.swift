//
//  HomeView.swift
//  Atelier
//
//  Created by Thiago Pires on 07/06/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            Color.atelierBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroSection
                        categoryPicker
                        featuredSection
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                tabBar
            }
        }
        .task {
            await viewModel.loadProducts()
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        HStack {
            Button {
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 19))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text("ATELIER")
                .font(.system(size: 17, weight: .black))
                .tracking(8)
                .foregroundStyle(.white)

            Spacer()

            Button {
            } label: {
                Image(systemName: "bag")
                    .font(.system(size: 19))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            Color.atelierSurface

            Text("ATELIER")
                .font(.system(size: 108, weight: .black))
                .tracking(12)
                .foregroundStyle(.white.opacity(0.04))
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(y: -80)

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.35),
                    .init(color: Color.atelierBackground, location: 0.88)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(Color.atelierAccent)
                    .frame(width: 36, height: 1)
                    .padding(.bottom, 18)

                Text("SS 2026")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(5)
                    .foregroundStyle(Color.atelierAccent)
                    .padding(.bottom, 14)

                Text("NEW\nCOLLECTION.")
                    .font(.system(size: 50, weight: .black))
                    .tracking(0.5)
                    .foregroundStyle(.white)
                    .lineSpacing(2)
                    .padding(.bottom, 16)

                Text("Curated fashion\nfor the modern wardrobe")
                    .font(.system(size: 13, weight: .light))
                    .foregroundStyle(Color.atelierSecondary)
                    .lineSpacing(4)
                    .padding(.bottom, 28)

                Button {
                } label: {
                    Text("EXPLORE NOW  →")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(3)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 13)
                        .overlay {
                            Rectangle()
                                .stroke(.white, lineWidth: 1)
                        }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 520)
    }

    // MARK: - Category Picker

    private var categoryPicker: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.atelierBorder)
                .frame(maxWidth: .infinity)
                .frame(height: 1)

            HStack(spacing: 0) {
                ForEach(ClothingCategory.allCases, id: \.self) { category in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedCategory = category
                        }
                    } label: {
                        VStack(spacing: 0) {
                            Text(category.rawValue)
                                .font(.system(size: 11, weight: .bold))
                                .tracking(3)
                                .foregroundStyle(
                                    viewModel.selectedCategory == category
                                        ? .white
                                        : Color.atelierSecondary
                                )
                                .padding(.top, 18)
                                .padding(.bottom, 14)

                            Rectangle()
                                .fill(
                                    viewModel.selectedCategory == category
                                        ? Color.white
                                        : Color.clear
                                )
                                .frame(height: 1)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            Rectangle()
                .fill(Color.atelierBorder)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }

    // MARK: - Featured Section

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("FEATURED")
                    .font(.system(size: 12, weight: .black))
                    .tracking(4)
                    .foregroundStyle(.white)

                Spacer()

                Button("See all →") {
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.atelierSecondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 18)

            if viewModel.isLoading {
                skeletonCards
            } else if viewModel.filteredProducts.isEmpty {
                Text("No items available")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.atelierSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                productScroll
            }
        }
        .padding(.bottom, 24)
    }

    private var productScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductCardView(product: product)
                }
            }
            .padding(.horizontal, 24)
        }
    }

    private var skeletonCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.atelierSurface)
                        .frame(width: 180, height: 260)
                }
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.atelierBorder)
                .frame(maxWidth: .infinity)
                .frame(height: 1)

            HStack(spacing: 0) {
                tabBarItem("house.fill", "HOME", active: true)
                tabBarItem("magnifyingglass", "SEARCH", active: false)
                tabBarItem("bag", "BAG", active: false)
                tabBarItem("heart", "SAVED", active: false)
                tabBarItem("person", "PROFILE", active: false)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 12)
        }
        .background(Color.atelierBackground)
    }

    private func tabBarItem(_ icon: String, _ label: String, active: Bool) -> some View {
        Button {
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 21))
                    .foregroundStyle(active ? .white : Color.atelierSecondary)

                Text(label)
                    .font(.system(size: 8, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(active ? .white : Color.atelierSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
}
