//
//  ContentView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

/**
 The `AnimatedTextView` displays the app's logo text "FitPlate" with an animated slide/fade in effect.
 */

struct AnimatedTextView: View {
    
    /// State variable to control the visibility and fade/slide animation of the "Plate" text.

    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 0) {
            // "Fit" portion of the logo
            Text("Fit")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 0.569, blue: 0.396))  // Orange

            // "Plate" portion of the logo with animation
            Text("Plate")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))  // Green
                .opacity(isVisible ? 1 : 0)  // Fade in effect
                .scaleEffect(isVisible ? 1 : 0.5)  // Scale in effect
                .onAppear {
                    // Animate when the view appears
                    withAnimation(.easeInOut(duration: 1.5)) {
                        isVisible = true
                    }
                }
        }
    }
}

/**
 The `ContentView` serves as the launch screen of the FitPlate app, displaying an animated logo, the app logo image, and a button to navigate to the sign-up view.
 */


struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                // Animated logo text
                AnimatedTextView()

                // App logo image
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)

                // "Get Started" button navigating to the sign-up view
                NavigationLink(destination: SignupView()) {
                    Text("Get Started")
                        .padding()
                        .frame(minWidth: 200)
                        .background(Color(red: 0.819, green: 0.302, blue: 0.408))  // Pink
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
