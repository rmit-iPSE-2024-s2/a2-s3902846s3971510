//
//  BottomNavBarView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

/**
 The `BottomNavBarView` provides the navigation bar for the FitPlate app that is active at the bottom of every view , allowing users to switch between different sections of the app.
 
 This view uses a `TabView` to organize and navigate between all key sections once the user has logged in: Home, Recipes, Workouts, Fitness Goals, and Profile.
 
 Each section is represented by an icon and label.
 */
struct BottomNavBarView: View {
    var body: some View {
        TabView {
            // Home tab
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            // Recipes tab
            RecipeView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Recipes")
                }

            // Workouts tab
            WorkoutView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Workouts")
                }

            // Fitness Goals tab
            FitnessGoalView()
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }

            // Profile tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        // Set the accent color for the tab icons when selected
        .accentColor(Color(red: 0.404, green: 0.773, blue: 0.702))
    }
}

#Preview {
    BottomNavBarView()
}
