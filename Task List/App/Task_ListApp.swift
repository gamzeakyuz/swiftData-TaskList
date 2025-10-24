//
//  Task_ListApp.swift
//  Task List
//
//  Created by GamzeAkyuz on 21.10.2025.
//

import SwiftUI
import SwiftData

@main
struct Task_ListApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: Task.self)
        }
    }
}
