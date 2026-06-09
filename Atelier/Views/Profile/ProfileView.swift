//
//  ProfileView.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(BagStore.self) private var bagStore
    @Environment(SavedStore.self) private var savedStore

    private struct MenuItem: Identifiable {
        let id = UUID()
        let icon: String
        let label: String
        var detail: String? = nil
    }

    var body: some View {
        ZStack {
            Color.atelierBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                Rectangle()
                    .fill(Color.atelierBorder)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        userCard
                        statsRow
                        menuSection(title: "MY ACCOUNT", items: [
                            MenuItem(icon: "shippingbox", label: "My Orders"),
                            MenuItem(icon: "creditcard", label: "Payment Methods"),
                            MenuItem(icon: "location", label: "Shipping Addresses"),
                        ])
                        menuSection(title: "PREFERENCES", items: [
                            MenuItem(icon: "ruler", label: "Size Guide"),
                            MenuItem(icon: "bell", label: "Notifications"),
                            MenuItem(icon: "globe", label: "Language", detail: "English"),
                        ])
                        menuSection(title: "SUPPORT", items: [
                            MenuItem(icon: "questionmark.circle", label: "Help Center"),
                            MenuItem(icon: "lock.shield", label: "Privacy Policy"),
                            MenuItem(icon: "info.circle", label: "About Atelier", detail: "v1.0"),
                        ])
                        signOutRow
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Header

    private var header: some View {
        Text("PROFILE")
            .font(.system(size: 28, weight: .black))
            .tracking(4)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 20)
    }

    // MARK: - User Card

    private var userCard: some View {
        HStack(spacing: 20) {
            ZStack {
                Color.atelierSurface
                Text("TP")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(Color.atelierAccent)
            }
            .frame(width: 72, height: 72)
            .overlay(Rectangle().stroke(Color.atelierBorder, lineWidth: 1))

            VStack(alignment: .leading, spacing: 0) {
                Text("THIAGO PIRES")
                    .font(.system(size: 17, weight: .black))
                    .tracking(2)
                    .foregroundStyle(.white)
                    .padding(.bottom, 6)

                Text("thiagopac@gmail.com")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(Color.atelierSecondary)
                    .padding(.bottom, 10)

                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.atelierAccent)
                        .frame(width: 18, height: 1)

                    Text("ATELIER MEMBER")
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(3)
                        .foregroundStyle(Color.atelierAccent)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        VStack(spacing: 0) {
            Rectangle().fill(Color.atelierBorder).frame(height: 1)

            HStack(spacing: 0) {
                statCell(value: "\(bagStore.itemCount)", label: "IN BAG")

                Rectangle().fill(Color.atelierBorder).frame(width: 1)

                statCell(value: "\(savedStore.itemCount)", label: "SAVED")

                Rectangle().fill(Color.atelierBorder).frame(width: 1)

                statCell(value: "0", label: "ORDERS")
            }
            .background(Color.atelierSurface)

            Rectangle().fill(Color.atelierBorder).frame(height: 1)
        }
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.system(size: 28, weight: .black))
                .foregroundStyle(.white)

            Text(label)
                .font(.system(size: 9, weight: .bold))
                .tracking(3)
                .foregroundStyle(Color.atelierSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
    }

    // MARK: - Menu Sections

    private func menuSection(title: String, items: [MenuItem]) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(4)
                .foregroundStyle(Color.atelierSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 14)

            Rectangle().fill(Color.atelierBorder).frame(height: 1)

            ForEach(items) { item in
                menuRow(item: item)
                Rectangle().fill(Color.atelierBorder).frame(height: 1)
            }
        }
    }

    private func menuRow(item: MenuItem) -> some View {
        Button {} label: {
            HStack(spacing: 16) {
                Image(systemName: item.icon)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.atelierSecondary)
                    .frame(width: 22, alignment: .center)

                Text(item.label)
                    .font(.system(size: 15))
                    .foregroundStyle(.white)

                Spacer()

                if let detail = item.detail {
                    Text(detail)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.atelierSecondary)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color.atelierBorder)
            }
            .padding(.horizontal, 24)
            .frame(height: 54)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Sign Out

    private var signOutRow: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 28)

            Rectangle().fill(Color.atelierBorder).frame(height: 1)

            Button {} label: {
                HStack(spacing: 16) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(red: 0.85, green: 0.4, blue: 0.4))
                        .frame(width: 22, alignment: .center)

                    Text("Sign Out")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(red: 0.85, green: 0.4, blue: 0.4))

                    Spacer()
                }
                .padding(.horizontal, 24)
                .frame(height: 54)
            }
            .buttonStyle(.plain)

            Rectangle().fill(Color.atelierBorder).frame(height: 1)
        }
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environment(BagStore())
        .environment(SavedStore())
}
