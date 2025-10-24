//
//  NewTaskListView.swift
//  Task List
//
//  Created by GamzeAkyuz on 23.10.2025.
//

import SwiftUI
import SwiftData

struct NewTaskListView: View {
    
    // MARK: Properties
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var selectedCategoryGenre: CategoryGenre = .personal
    @State private var selectedPriorityGenre: PriorityGenre = .low
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    
    @State private var formOpenedDate = Date()
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: Functions
    private func addNewTask() {
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else { return }
        
        let newTask = Task(id: UUID(),
                           title: trimmedTitle,
                           isCompleted: false,
                           dueDate: hasDueDate ? dueDate : nil,
                           priority: selectedPriorityGenre,
                           category: selectedCategoryGenre
        )
        modelContext.insert(newTask)
        
        do {
            try modelContext.save()
            print("Task saved successfully.")
        } catch {
            print("Failed to save new task: \(error.localizedDescription)")
        }
        
    }
    
    
    var body: some View {
        Form {
            // MARK: Header & Title Section
            Section {
                Text("What to Task")
                    .font(.largeTitle.weight(.black))
                    .foregroundStyle(.pink.gradient)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
                
                TextField("Task Title", text: $title)
                    .textFieldStyle(.plain)
                    .font(.largeTitle.weight(.medium))
            }
            .listRowSeparator(.hidden)
            
            // MARK: Settings Section
            Section {
                HStack {
                    Toggle("Due Date", isOn: $hasDueDate.animation())
                    
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, in: formOpenedDate... ,displayedComponents: [.date])
                            .labelsHidden()
                            .datePickerStyle(.automatic)
                    }
                }
                
                Picker("Category", selection: $selectedCategoryGenre) {
                    ForEach(CategoryGenre.allCases) { cGenre in
                        Text(cGenre.name)
                            .tag(cGenre)
                    }
                }
                
                Picker("Priority", selection: $selectedPriorityGenre) {
                    ForEach(PriorityGenre.allCases) { pGenre in
                        Text(pGenre.name)
                            .tag(pGenre)
                    }
                }
            }
            
            // MARK: Action Buttons Section
            Section {
                Button {
                    if isFormValid {
                        print("Valid Input: \(title)")
                        addNewTask()
                        dismiss()
                    } else {
                        print("Input is invalid")
                    }
                } label: {
                    Text("Save")
                        .font(.title2.weight(.regular))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .controlSize(.extraLarge)
                .buttonBorderShape(.roundedRectangle)
                .disabled(!isFormValid)
                .padding(.vertical, 8)
                
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.pink)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}


#Preview {
    NewTaskListView()
        .modelContainer(for: Task.self, inMemory: true) // Preview için context eklemek iyi bir pratik
}
