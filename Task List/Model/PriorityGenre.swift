//
//  PriorityGenre.swift
//  Task List
//
//  Created by GamzeAkyuz on 21.10.2025.
//

import Foundation

enum PriorityGenre: Int, Codable, CaseIterable, Identifiable {
    
    var id: Int {
        rawValue
    }
    
    case low = 1
    case medium = 2
    case high = 3
    case urgent = 4
}

extension PriorityGenre {
    var name: String {
        switch self {
        case .low:
            "Low"
        case .medium:
            "Medium"
        case .high:
            "High"
        case .urgent:
            "Urgent"
        }
    }
}
