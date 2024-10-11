//
//  FitPlateApp.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI
import SwiftData

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
        .modelContainer(for: User.self)
    }
}



