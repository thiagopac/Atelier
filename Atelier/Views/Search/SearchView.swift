//
//  SearchView.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @State private var searchQuery = ""
    @FocusState private var isSearchFocused: Bool

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        ZStack {
            Color.atelierBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                searchBar
                categoryPicker

                if viewModel.isLoading {
                    skeletonGrid
                } else {
                    resultsContent
                }
            }
        }
        .task {
            await viewModel.loadProducts()
        }
        .onChange(of: searchQuery) { _, val in
            viewModel.searchQuery = val
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Header

    private var header: some View {
        Text("SEARCH")
            .font(.system(size: 28, weight: .black))
            .tracking(4)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 20)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(searchQuery.isEmpty ? Color.atelierSecondary : .white)

            TextField(
                "",
                text: $searchQuery,
                prompt: Text("Search products...")
                    .foregroundStyle(Color.atelierSecondary)
            )
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .focused($isSearchFocused)

            if !searchQuery.isEmpty {
                Button {
                    searchQuery = ""
                    isSearchFocused = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.atelierSecondary)
                        .frame(width: 22, height: 22)
                        .background(Color.atelierElevated)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.atelierSurface)
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
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

    // MARK: - Results

    private var resultsContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                sectionHeader
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 16)

                if viewModel.results.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(viewModel.results) { product in
                            NavigationLink {
                                ProductDetailView(product: product)
                            } label: {
                                GridProductCardView(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .onTapGesture {
            isSearchFocused = false
        }
    }

    private var sectionHeader: some View {
        HStack(spacing: 6) {
            Text(searchQuery.isEmpty ? "ALL ITEMS" : "RESULTS")
                .font(.system(size: 12, weight: .black))
                .tracking(4)
                .foregroundStyle(.white)

            Text("(\(viewModel.results.count))")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.atelierSecondary)

            Spacer()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 32))
                .foregroundStyle(Color.atelierBorder)

            Text("No results for \"\(searchQuery)\"")
                .font(.system(size: 13))
                .foregroundStyle(Color.atelierSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    // MARK: - Skeleton

    private var skeletonGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(0..<8, id: \.self) { _ in
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.atelierSurface)
                            .aspectRatio(1, contentMode: .fit)

                        Rectangle()
                            .fill(Color.atelierSurface)
                            .frame(height: 68)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
