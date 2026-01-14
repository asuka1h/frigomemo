//
//  FoodItem.swift
//  Frigomemo
//
//  Created by Yihan Wang on 11/8/23.
//

import Foundation
import SwiftUI

enum FoodCategory: String, CaseIterable, Codable {
    case vegetable = "Vegetable"
    case meat = "Meat"
    case dairy = "Dairy"
    case fruit = "Fruit"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .vegetable: return "🥬"
        case .meat: return "🥩"
        case .dairy: return "🥛"
        case .fruit: return "🍎"
        case .other: return "📦"
        }
    }
}

struct FoodItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: FoodCategory
    var expirationDate: Date
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, category: FoodCategory, expirationDate: Date, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.expirationDate = expirationDate
        self.createdAt = createdAt
    }
    
    var daysUntilExpiration: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
    }
    
    var expirationStatus: ExpirationStatus {
        let days = daysUntilExpiration
        if days < 0 {
            return .expired
        } else if days <= 2 {
            return .expiringSoon
        } else {
            return .fresh
        }
    }
}

enum ExpirationStatus {
    case expired
    case expiringSoon
    case fresh
    
    var color: Color {
        switch self {
        case .expired: return .red
        case .expiringSoon: return .orange
        case .fresh: return .green
        }
    }
    
    var description: String {
        switch self {
        case .expired: return "Expired"
        case .expiringSoon: return "Expiring Soon"
        case .fresh: return "Fresh"
        }
    }
}
