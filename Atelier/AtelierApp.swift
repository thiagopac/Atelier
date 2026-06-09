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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bagStore)
                .preferredColorScheme(.dark)
        }
    }
}
