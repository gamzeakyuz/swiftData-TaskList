//
//  EmptyListView.swift
//  Task List
//
//  Created by GamzeAkyuz on 21.10.2025.
//

import SwiftUI

struct EmptyListView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                Spacer(minLength: geo.size.height * 0.05)
                
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.4)
                    .foregroundStyle(.pink)
                    .shadow(color: .white.opacity(0.3), radius: 6)
                    .padding(.bottom, 25)
                
                Text("Your Task List is Empty…")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Text("Start organizing your day and stay productive.\nTap the + button below to create your first task.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.pink, Color.purple, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.22)
                    .overlay(
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Tips", systemImage: "lightbulb.fill")
                                .font(.headline)
                                .foregroundColor(.pink)
                            Label("Long-press a task to schedule notifications", systemImage: "bell.badge.fill")
                            Label("Swipe right to mark as completed", systemImage: "checkmark.circle.fill")
                            Label("Swipe left to delete", systemImage: "trash.fill")
                        }
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                    )
                    .padding(.bottom, geo.size.height * 0.12)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                LinearGradient(
                    colors: [Color(red: 1.0, green: 0.7, blue: 0.75),
                             Color(red: 0.9, green: 0.4, blue: 0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    EmptyListView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    EmptyListView()
        .preferredColorScheme(.dark)
}
