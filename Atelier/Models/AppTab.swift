//
//  AppTab.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import Foundation

enum AppTab: CaseIterable {
    case home, search, bag, saved, profile

    var label: String {
        switch self {
        case .home:    return "HOME"
        case .search:  return "SEARCH"
        case .bag:     return "BAG"
        case .saved:   return "SAVED"
        case .profile: return "PROFILE"
        }
    }

    var activeIcon: String {
        switch self {
        case .home:    return "house.fill"
        case .search:  return "magnifyingglass"
        case .bag:     return "bag.fill"
        case .saved:   return "heart.fill"
        case .profile: return "person.fill"
        }
    }

    var inactiveIcon: String {
        switch self {
        case .home:    return "house"
        case .search:  return "magnifyingglass"
        case .bag:     return "bag"
        case .saved:   return "heart"
        case .profile: return "person"
        }
    }
}
