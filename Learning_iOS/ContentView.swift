//
//  ContentView.swift
//  Learning_iOS
//
//  Created by Иван Клочков on 05.02.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var counter = 0
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 20) {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
            Text("Привет, iOS 👋")
                .font(.largeTitle)
                .foregroundStyle(.blue)
            
            Text("Нажатий: \(counter)")
                .font(.title2)
            
            Button {
                withAnimation {
                    counter += 1
                } } label: {
                    Text("Нажми меня")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                }
                .buttonStyle(.plain)
                            .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    isPressed = pressing
                                }
                            }, perform: {})
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ContentView()
}
