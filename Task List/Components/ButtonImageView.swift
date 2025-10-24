//
//  ButtonImageView.swift
//  Task List
//
//  Created by GamzeAkyuz on 21.10.2025.
//

import SwiftUI

struct ButtonImageView: View {
    let symbolName: String
    
    var body: some View {
        Image(systemName: symbolName)
            .font(.system(size: 70, weight: .bold))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color.white,
                        Color.white.opacity(0.85)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .white.opacity(0.4), radius: 6, x: 0, y: 3)

    }
}

#Preview {
    ButtonImageView(symbolName: "plus.circle.fill")
}
