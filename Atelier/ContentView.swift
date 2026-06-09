//
//  ContentView.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var searchLoaded = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.atelierBackground.ignoresSafeArea()

            tabContent

            tabBar
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: selectedTab) { _, tab in
            if tab == .search && !searchLoaded { searchLoaded = true }
        }
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var tabContent: some View {
        ZStack {
            NavigationStack { HomeView() }
                .opacity(selectedTab == .home ? 1 : 0)
                .allowsHitTesting(selectedTab == .home)

            Group {
                if searchLoaded {
                    NavigationStack { SearchView() }
                }
            }
            .opacity(selectedTab == .search ? 1 : 0)
            .allowsHitTesting(selectedTab == .search)
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
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: selectedTab == tab ? tab.activeIcon : tab.inactiveIcon)
                                .font(.system(size: 21))
                                .foregroundStyle(selectedTab == tab ? .white : Color.atelierSecondary)

                            Text(tab.label)
                                .font(.system(size: 8, weight: .bold))
                                .tracking(1.5)
                                .foregroundStyle(selectedTab == tab ? .white : Color.atelierSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 12)
        }
        .background(Color.atelierBackground)
    }
}

#Preview {
    ContentView()
}
