//
//  CategoryGenre.swift
//  Task List
//
//  Created by GamzeAkyuz on 21.10.2025.
//

import Foundation

enum CategoryGenre: Int, Codable, CaseIterable, Identifiable {

    var id: Int {
        rawValue
    }
    
    case personal = 1
    case work = 2
    case school = 3
    case shopping = 4
    case health = 5
    case other = 6
}

extension CategoryGenre {
    var name: String {
        switch self {
        case .personal:
            "Personal"
        case .work:
            "Work"
        case .school:
            "School"
        case .shopping:
            "Shopping"
        case .health:
            "Health"
        case .other:
            "Other"
        }
    }
}
