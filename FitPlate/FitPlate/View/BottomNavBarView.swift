//
//  BottomNavBarView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

struct BottomNavBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            RecipeView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Recipes")
                }

            WorkoutView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Workouts")
                }

            FitnessGoalView()
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        // tab icon highlight color
        .accentColor(Color(red: 0.404, green: 0.773, blue: 0.702))
    }
}

#Preview {
    BottomNavBarView()
}
