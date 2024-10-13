//
//  FitPlateApp.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//


import SwiftUI
import SwiftData

/**
 The `FitPlateApp` is the main entry point of the FitPlate app.
 
 It sets up the initial app state and handling navigation between the launch screen and the main interface.
 */

@main
struct FitPlateApp: App {
    @State private var isLoggedIn = false  // manage login state for navigation

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                BottomNavBarView()  // show main interface after login
            } else {
                ContentView()  // show launch page initially
            }
        }
        .modelContainer(for: [User.self, SavedRoutine.self, Profile.self, FitnessGoal.self])
    }
}
    

