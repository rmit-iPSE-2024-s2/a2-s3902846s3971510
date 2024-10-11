//
//  FitPlateApp.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

@main
struct FitPlateApp: App {
    @State private var hasStarted = false  // to track whether the user has pressed get started

    var body: some Scene {
        WindowGroup {
            if hasStarted {
                BottomNavBarView()
            } else {
                ContentView(hasStarted: $hasStarted) 
            }
        }
    }
}
