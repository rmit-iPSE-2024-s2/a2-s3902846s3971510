//
//  ContentView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

struct AnimatedTextView: View {
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Fit")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 0.569, blue: 0.396)) // orange

            Text("Plate")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702)) // green
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.5)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        isVisible = true
                    }
                }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                AnimatedTextView()

                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)

                NavigationLink(destination: SignupView()) {
                    Text("Get Started")
                        .padding()
                        .frame(minWidth: 200)
                        .background(Color(red: 0.819, green: 0.302, blue: 0.408)) // pink
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("")
        }
    }
}

#Preview {
    ContentView()
}
