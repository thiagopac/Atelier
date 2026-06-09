//
//  ContentView.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(BagStore.self) private var bagStore
    @State private var selectedTab: AppTab = .home
    @State private var searchLoaded = false
    @State private var bagLoaded = false
    @State private var savedLoaded = false
    @State private var profileLoaded = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.atelierBackground.ignoresSafeArea()

            tabContent

            tabBar
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: selectedTab) { _, tab in
            if tab == .search && !searchLoaded { searchLoaded = true }
            if tab == .bag && !bagLoaded { bagLoaded = true }
            if tab == .saved && !savedLoaded { savedLoaded = true }
            if tab == .profile && !profileLoaded { profileLoaded = true }
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

            Group {
                if bagLoaded {
                    NavigationStack { BagView() }
                }
            }
            .opacity(selectedTab == .bag ? 1 : 0)
            .allowsHitTesting(selectedTab == .bag)

            Group {
                if savedLoaded {
                    NavigationStack { SavedView() }
                }
            }
            .opacity(selectedTab == .saved ? 1 : 0)
            .allowsHitTesting(selectedTab == .saved)

            Group {
                if profileLoaded {
                    NavigationStack { ProfileView() }
                }
            }
            .opacity(selectedTab == .profile ? 1 : 0)
            .allowsHitTesting(selectedTab == .profile)
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
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: selectedTab == tab ? tab.activeIcon : tab.inactiveIcon)
                                    .font(.system(size: 21))
                                    .foregroundStyle(selectedTab == tab ? .white : Color.atelierSecondary)

                                if tab == .bag && bagStore.itemCount > 0 {
                                    Text("\(min(bagStore.itemCount, 9))")
                                        .font(.system(size: 7, weight: .black))
                                        .foregroundStyle(Color.atelierBackground)
                                        .frame(width: 13, height: 13)
                                        .background(Color.white)
                                        .offset(x: 5, y: -3)
                                }
                            }

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
        .environment(BagStore())
        .environment(SavedStore())
}
