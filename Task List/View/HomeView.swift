//
//  ContentView.swift
//  Task List
//
//  Created by GamzeAkyuz on 21.10.2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    // MARK: Properties
    @Environment(\.modelContext) var modelContext
    @Query private var tasks: [Task]
    
    @State private var isSheetPresent: Bool = false
    @State private var selectedSort: SortOption = .name
    
    @State private var sortedTaskList: [Task] = []
    
    
    // MARK: Functions
    
    func sortedTasks(_ tasks: [Task], by sortOption: SortOption) -> [Task] {
        switch sortOption {
        case .name:
            return tasks.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .precedence:
            return tasks.sorted { $0.priority.rawValue > $1.priority.rawValue }
        case .dueDate:
            return tasks.sorted { lhs, rhs in
                switch (lhs.dueDate, rhs.dueDate) {
                case let (d1?, d2?):
                    return d1 < d2
                case (nil, nil):
                    return false
                case (nil, _?):
                    return false
                case (_?, nil):
                    return true
                }
            }
        }
    }
    private func updateSortedList() {
        sortedTaskList = sortedTasks(tasks, by: selectedSort)
    }
    private func deleteTask(_ task: Task) {
        withAnimation {
            NotificationManager.cancelNotification(for: task)
            modelContext.delete(task)
            
            do {
                try modelContext.save()
                print("Task deleted: \(task.title)")
            } catch {
                print("Failed to delete task: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: BODY
    var body: some View {
        NavigationStack {
            List {
                Section(header: HeaderView(selectedSort: $selectedSort)) {
                    
                    ForEach(sortedTaskList, id: \.id) { task in
                        
                        Group {
                            TaskRow(task: task)
                        }
                        .contextMenu {
                            contextMenuContent(for: task)
                        }
                        .swipeActions(edge: .trailing) {
                            deleteSwipeAction(for: task)
                        }
                        
                        .swipeActions(edge: .leading) {
                            completeSwipeAction(for: task)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .overlay {
                Group {
                    if tasks.isEmpty {
                        EmptyListView()
                            .transition(.opacity)
                    }
                }
            }
            .onAppear {
                NotificationManager.requestPermission()
                print("Notification permission requested.")
                updateSortedList()
            }
            .onChange(of: tasks) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    updateSortedList()
                }
            }
            .onChange(of: selectedSort) {
                updateSortedList()
            }
            .safeAreaInset(edge: .bottom, alignment: .center) {
                HStack {
                    Spacer()
                    Button {
                        isSheetPresent.toggle()
                        print("New task sheet opened.")
                    } label: {
                        ButtonImageView(symbolName: "plus.circle.fill")
                    }
                    .accessibilityLabel("New Task")
                    .sensoryFeedback(.success, trigger: isSheetPresent)
                }
                .padding(.trailing, 24)
                .padding(.bottom, 12)
            }
            .sheet(isPresented: $isSheetPresent) {
                NewTaskListView()
                    .presentationDetents([.medium, .large])
            }
            
        }
    }
    
    // MARK: - Row helpers
    private func toggleCompleted(for task: Task) {
        task.isCompleted.toggle()
        if task.isCompleted {
            NotificationManager.cancelNotification(for: task)
            print("Marked as completed: \(task.title)")
        } else {
            print("Marked as not completed: \(task.title)")
        }
        do {
            try modelContext.save()
        } catch {
            print("Failed to update task status: \(error.localizedDescription)")
        }
    }
    
    private func scheduleNotification(for task: Task) {
        NotificationManager.scheduleNotification(for: task)
        print("Notification schedule request sent for: \(task.title)")
    }
    
    private func cancelNotification(for task: Task) {
        NotificationManager.cancelNotification(for: task)
        print("Notification cancellation request sent for: \(task.title)")
    }
    
    // MARK: - Extracted UI pieces to help the type-checker
    
    @ViewBuilder
    private func contextMenuContent(for task: Task) -> some View {
        if let _ = task.dueDate {
                if !task.isCompleted {
                    Button {
                        if task.notificationScheduled {
                            cancelNotification(for: task)
                            task.notificationScheduled = false
                            print("Notification cancelled for: \(task.title)")
                        } else {
                            // Bildirim aktif değilse planla
                            scheduleNotification(for: task)
                            task.notificationScheduled = true
                            print("Notification scheduled for: \(task.title)")
                        }
                        
                        do {
                            try modelContext.save()
                            print("Notification status saved: \(task.notificationScheduled ? "ON" : "OFF")")
                        } catch {
                            print("Failed to save notification status: \(error.localizedDescription)")
                        }
                        
                    } label: {
                        Label(
                            task.notificationScheduled ? "Cancel Notification" : "Schedule Notification",
                            systemImage: task.notificationScheduled ? "bell.slash" : "bell.badge"
                        )
                    }
                    .tint(task.notificationScheduled ? .red : .green)
                    
                } else {
                    Button(role: .destructive) {
                        cancelNotification(for: task)
                        task.notificationScheduled = false
                        print("🔕 Cancelled notification for completed task: \(task.title)")
                        
                        do {
                            try modelContext.save()
                            print("Notification state reset for completed task")
                        } catch {
                            print("Failed to save after cancel: \(error.localizedDescription)")
                        }
                    } label: {
                        Label("Cancel Notification", systemImage: "bell.slash")
                    }
                }
            } else {
                Button(action: {}) {
                    Label("Add Due Date to Set Notification", systemImage: "bell.slash")
                }
                .disabled(true)
            }
    }
    
    @ViewBuilder
    private func deleteSwipeAction(for task: Task) -> some View {
        Button(role: .destructive) {
            deleteTask(task)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    @ViewBuilder
    private func completeSwipeAction(for task: Task) -> some View {
        let title = task.isCompleted ? "Undo" : "Done"
        let systemImage = task.isCompleted ? "x.circle" : "checkmark.circle"
        Button(title, systemImage: systemImage) {
            toggleCompleted(for: task)
        }
        .tint(task.isCompleted ? .blue : .green)
    }
}

// MARK: - Subviews

struct HeaderView: View {
    
    @Binding var selectedSort: SortOption
    
    var body: some View {
        VStack {
            Text("Task")
                .font(.largeTitle.weight(.black))
                .foregroundStyle(.red.gradient)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
            
            HStack {
                Label("Task List", systemImage: "text.line.magnify")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Menu {
                    Picker("Sort By", selection: $selectedSort.animation(.easeInOut)) {
                        ForEach(SortOption.allCases) { sortOption in
                            Label(sortOption.rawValue, systemImage: sortOption.systemImage)
                                .tag(sortOption)
                        }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                        .font(.title2)
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.pink)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.pink.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

struct TaskRow: View {
    let task: Task
    
    // MARK: - Private Helpers
    
    private static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private func formattedDate(for date: Date) -> String {
        return Self.mediumDateFormatter.string(from: date)
    }

    private func colorForDate(_ date: Date) -> Color {
        let now = Date()
        if Calendar.current.isDateInToday(date) {
            return .orange
        } else if date < now {
            return .red
        } else {
            return .green
        }
    }
    
    private func colorPriority(for priority: PriorityGenre) -> Color {
        switch priority {
        case .low:
            return .yellow
        case .medium:
            return .green
        case .high:
            return .orange
        case .urgent:
            return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(task.title)
                .font(.title.weight(.light))
                .padding(.vertical, 2)
                .foregroundStyle(task.isCompleted ? Color.accentColor : Color.primary)
                .strikethrough(task.isCompleted)
                .italic(task.isCompleted)
            
            if let due = task.dueDate {
                Text(formattedDate(for: due))
                    .font(.footnote)
                    .foregroundColor(colorForDate(due))
            }
            
            HStack(alignment: .top) {
                Text(task.category.name)
                    .font(.footnote.weight(.medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().stroke(lineWidth: 1))
                    .foregroundStyle(.tertiary)
                
                Text(task.priority.name)
                    .font(.footnote.weight(.medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(colorPriority(for: task.priority).opacity(0.1))
                            .stroke(colorPriority(for: task.priority), lineWidth: 2)
                    )
                    .foregroundStyle(colorPriority(for: task.priority))
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 4)
    }
}

#Preview("Sample Data") {
    HomeView()
        .modelContainer(Task.preview)
}

#Preview("Empty List") {
    HomeView()
        .modelContainer(for: Task.self, inMemory: true)
}

#Preview("Dark View") {
    HomeView()
        .modelContainer(Task.preview)
        .preferredColorScheme(.dark)
}
