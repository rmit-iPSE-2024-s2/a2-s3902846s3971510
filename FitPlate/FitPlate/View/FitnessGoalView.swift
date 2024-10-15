//
//  FitnessGoalView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI
import SwiftData

/**
 The `FitnessGoalView` allows users to manage and track their daily fitness goals.
 
 Users can add goals, mark them as completed, and remove them from the active goals list. Goals are saved in SwiftData to ensure persistence across app sessions.
 */

struct FitnessGoalView: View {
    /// Tracks whether the "Add Goal" sheet is presented.
    @State private var showAddGoal = false
    
    /// Provides access to the SwiftData model context for saving fitness goals.
    @Environment(\.modelContext) var modelContext
    
    /// Query to fetch fitness goals from the SwiftData model.
    @Query var fitnessGoals: [FitnessGoal]
    
    /// Tracks the list of active goals locally for the UI.
    @State private var activeGoals: [String] = []
    
    /// Tracks the list of available goals locally for the UI.
    @State private var availableGoals: [String] = []
    
    /// Tracks the completion status of each goal using a dictionary to be saved
    @State private var completedGoals: [String: Bool] = [:]

    /// A list of default available goals.
    var defaultAvailableGoals = ["Daily Workout Completed", "10,000 Steps", "Hydrated with 2L Water", "8 Hours Sleep"]

    var body: some View {
        // Get the first fitness goal or create a new instance if none are found
        let fitnessGoal = fitnessGoals.first ?? FitnessGoal(activeGoals: [], completedGoals: [:], availableGoals: [])

        VStack(alignment: .leading, spacing: 20) {
            // Title for the Fitness Goals view
            Text("Fitness Goals")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.819, green: 0.302, blue: 0.408))
                .padding(.top)

            // Display message if no active goals are present
            if activeGoals.isEmpty {
                Text("You currently have no Fitness Goals added")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding(.top)
            } else {
                // List of active goals with options to complete or delete
                List {
                    ForEach(activeGoals, id: \.self) { goal in
                        DailyGoalTracker(goal: goal, isCompleted: completedGoals[goal] ?? false) {
                            toggleGoalCompletion(goal: goal, fitnessGoal: fitnessGoal)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                removeGoal(goal, fitnessGoal: fitnessGoal)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }

            Spacer()

            // Add goal button, shown only if available goals exist
            if !availableGoals.isEmpty {
                HStack {
                    Spacer()
                    Button(action: {
                        showAddGoal = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))
                    }
                    // Display the add goal form in a sheet
                    .sheet(isPresented: $showAddGoal) {
                        AddGoalSheet(availableGoals: $availableGoals, activeGoals: $activeGoals, fitnessGoal: fitnessGoal, completedGoals: $completedGoals)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .onAppear {
            loadFitnessGoals(fitnessGoal: fitnessGoal)
        }
    }

    /**
     Loads the active and available goals from the fitness goal model.
     
     - Parameter fitnessGoal: The fitness goal instance containing the saved goals.
     */
    
    private func loadFitnessGoals(fitnessGoal: FitnessGoal) {
        activeGoals = fitnessGoal.activeGoals
        completedGoals = fitnessGoal.completedGoals
        
        // If available goals are empty, initialise with defaults, excluding active goals
        availableGoals = fitnessGoal.availableGoals.isEmpty ? defaultAvailableGoals.filter { !activeGoals.contains($0) } : fitnessGoal.availableGoals
    }

    /**
     Toggles the completion state (checked or unchecked) of a goal and saves the updated state in SwiftData.
     
     - Parameters:
        - goal: The goal whose completion state is being toggled.
        - fitnessGoal: The fitness goal instance to update in SwiftData.
     */
    
    private func toggleGoalCompletion(goal: String, fitnessGoal: FitnessGoal) {
        completedGoals[goal]?.toggle()
        fitnessGoal.completedGoals = completedGoals
        try? modelContext.save()
    }

    /**
     Removes a goal from the active goals list and adds it back to the available goals. The updated state is saved in SwiftData.
     
     - Parameters:
        - goal: The goal to be removed from the active goals list.
        - fitnessGoal: The fitness goal instance to update in SwiftData.
     */
    
    private func removeGoal(_ goal: String, fitnessGoal: FitnessGoal) {
        activeGoals.removeAll { $0 == goal }
        fitnessGoal.activeGoals.removeAll { $0 == goal }
        availableGoals.append(goal)
        completedGoals[goal] = false
        fitnessGoal.completedGoals = completedGoals
        fitnessGoal.availableGoals = availableGoals
        try? modelContext.save()
    }
}

/**
 The `AddGoalSheet` presents a list of available goals that can be added to the active goals list.
 
 When a goal is added, it is removed from the available goals list and the updated state is saved in SwiftData.
 */
struct AddGoalSheet: View {
    @Binding var availableGoals: [String]
    @Binding var activeGoals: [String]
    var fitnessGoal: FitnessGoal
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Binding var completedGoals: [String: Bool]

    var body: some View {
        NavigationView {
            List {
                // List of available goals to add
                ForEach(availableGoals, id: \.self) { goal in
                    Button(action: {
                        // Add the goal to active goals and remove it from available goals
                        if !activeGoals.contains(goal) {
                            activeGoals.append(goal)
                            availableGoals.removeAll { $0 == goal }
                            completedGoals[goal] = false
                            saveActiveGoals(fitnessGoal: fitnessGoal)
                        }
                    }) {
                        Text(goal)
                    }
                }
            }
            .navigationTitle("Add Daily Goal")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }

    /**
     Saves the updated active goals, completed goals, and available goals to SwiftData.
     
     - Parameter fitnessGoal: The fitness goal instance to update in SwiftData.
     */
    
    private func saveActiveGoals(fitnessGoal: FitnessGoal) {
        fitnessGoal.activeGoals = activeGoals
        fitnessGoal.completedGoals = completedGoals
        fitnessGoal.availableGoals = availableGoals
        try? modelContext.save()
    }
}

/**
 The `DailyGoalTracker` is a reusable view that displays tracked individual goal and its completion state.
 
 It provides a green checkmark button to toggle the goal's completion status.
 
 */

struct DailyGoalTracker: View {
    /// The name of the goal being tracked.
    var goal: String
    
    /// Indicates whether the goal has been completed.
    var isCompleted: Bool
    
    /// A closure that is triggered when the goal is marked as completed or incomplete.
    
    var markCompleted: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Display the goal text
                Text(goal)
                    .font(.body)
                    .foregroundColor(.black)

                Spacer()

                // Button to toggle goal completion state
                Button(action: markCompleted) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(isCompleted ? .green : .gray)
                }
            }
        }
        .padding(.top)
    }
}

#Preview {
    FitnessGoalView()
}
