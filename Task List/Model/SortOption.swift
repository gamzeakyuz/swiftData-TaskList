//
//  SortOption.swift
//  Task List
//
//  Created by GamzeAkyuz on 21.10.2025.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {

    case name = "by Name"
    case precedence = "by Priority"
    case dueDate = "by Date"
    
    var id: Self { self }
    
    var systemImage: String {
        switch self {
        case .name:
            return "characters.lowercase"
        case .precedence:
            return "list.triangle"
        case .dueDate:
            return "calendar.day.timeline.right"
        }
    }
}
