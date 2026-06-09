//
//  AtelierApp.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

@main
struct AtelierApp: App {
    @State private var bagStore = BagStore()
    @State private var savedStore = SavedStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bagStore)
                .environment(savedStore)
                .preferredColorScheme(.dark)
        }
    }
}
