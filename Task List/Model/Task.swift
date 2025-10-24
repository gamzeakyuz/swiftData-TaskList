//
//  Task.swift
//  Task List
//
//  Created by GamzeAkyuz on 21.10.2025.
//

import Foundation
import SwiftData

@Model
class Task {
    
    @Attribute(.unique) var id: UUID
    
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var priority: PriorityGenre
    var category: CategoryGenre
    var notificationScheduled: Bool = true

    init(id: UUID,title: String, isCompleted: Bool = false, dueDate: Date? = nil, priority: PriorityGenre, category: CategoryGenre) {
        self.id = UUID()
        
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
        self.category = category
        
    }
}
extension Task {
    
    @MainActor
    static var preview: ModelContainer {
        
        let container: ModelContainer
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try ModelContainer(for: Task.self, configurations: config)
        } catch {
            fatalError("Preview Model Container oluşturulamadı: \(error)")
        }
        
        let context = container.mainContext
        
        context.insert(Task(
            id: UUID(),
            title: "Math Homework",
            isCompleted: false,
            dueDate: Date(),
            priority: .medium,
            category: .school
        ))
        
        context.insert(Task(
            id: UUID(),
            title: "Exercise",
            isCompleted: false,
            dueDate: Date(),
            priority: .high,
            category: .health
        ))
        
        return container
    }
}
