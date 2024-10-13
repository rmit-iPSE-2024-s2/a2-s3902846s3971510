//
//  FitnessGoalView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI
import SwiftData

struct FitnessGoalView: View {
    @State private var showAddGoal = false  // to show daily goal add menu
    @Environment(\.modelContext) var modelContext
    @Query var fitnessGoals: [FitnessGoal]  // Query for fitness goals
    @State private var activeGoals: [String] = [] // track the active goals locally for the UI
    @State private var availableGoals: [String] = []  // track available goals locally
    @State private var completedGoals: [String: Bool] = [:]  // track completion status per goal

    var defaultAvailableGoals = ["Daily Workout Completed", "10,000 Steps", "Hydrated with 2L Water", "8 Hours Sleep"]

    var body: some View {
        
        let fitnessGoal = fitnessGoals.first ?? FitnessGoal(activeGoals: [], completedGoals: [:], availableGoals: [])

        VStack(alignment: .leading, spacing: 20) {
            // Fitness Goals title
            Text("Fitness Goals")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.819, green: 0.302, blue: 0.408))
                .padding(.top)

            // show message if no active goals are present
            if activeGoals.isEmpty {
                Text("You currently have no Fitness Goals added")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding(.top)
            } else {
                // list the active goals
                List {
                    ForEach(activeGoals, id: \.self) { goal in
                        DailyGoalTracker(goal: goal, isCompleted: completedGoals[goal] ?? false) {
                            toggleGoalCompletion(goal: goal, fitnessGoal: fitnessGoal)  // Toggle goal completion state
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                removeGoal(goal, fitnessGoal: fitnessGoal)  // to show removal option on swipe of the goal
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }

            Spacer()

            // only show + button if there are available goals to add
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
                    // show the add goal form
                    .sheet(isPresented: $showAddGoal) {
                        AddGoalSheet(availableGoals: $availableGoals, activeGoals: $activeGoals, fitnessGoal: fitnessGoal, completedGoals: $completedGoals)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .onAppear {
            loadFitnessGoals(fitnessGoal: fitnessGoal)  // load saved goals on appear
        }
    }

    // load active goals and available goals from the fitness goal model
    private func loadFitnessGoals(fitnessGoal: FitnessGoal) {
        activeGoals = fitnessGoal.activeGoals
        completedGoals = fitnessGoal.completedGoals

        // initialise available goals with defaults if no saved available goals, excluding active ones
        availableGoals = fitnessGoal.availableGoals.isEmpty ? defaultAvailableGoals.filter { !activeGoals.contains($0) } : fitnessGoal.availableGoals
    }

    // Toggle the checkmark of a goal and save it in SwiftData
    private func toggleGoalCompletion(goal: String, fitnessGoal: FitnessGoal) {
        completedGoals[goal]?.toggle()
        fitnessGoal.completedGoals = completedGoals
        try? modelContext.save()  // Save changes
    }

    // Remove a goal from active goals and SwiftData, add it back to availableGoals for user to select and also save in SwiftData
    
    private func removeGoal(_ goal: String, fitnessGoal: FitnessGoal) {
        activeGoals.removeAll { $0 == goal }
        fitnessGoal.activeGoals.removeAll { $0 == goal }
        availableGoals.append(goal)
        completedGoals[goal] = false
        fitnessGoal.completedGoals = completedGoals  // save the updated completedGoals
        fitnessGoal.availableGoals = availableGoals  // save the updated availableGoals
        try? modelContext.save()  // Save changes in SwiftData
    }
}

// addgoal form/sheet logic
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
                        // Add the goal to active goals, then remove it from available goals in the sheet.
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
                dismiss()  // Done button
            })
        }
    }

    // save changes in SwiftData
    private func saveActiveGoals(fitnessGoal: FitnessGoal) {
        fitnessGoal.activeGoals = activeGoals
        fitnessGoal.completedGoals = completedGoals  // save completion status for each goal
        fitnessGoal.availableGoals = availableGoals  // save updated available goals
        try? modelContext.save()
    }
}

struct DailyGoalTracker: View {
    var goal: String
    var isCompleted: Bool
    var markCompleted: () -> Void  // Callback to toggle completion

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // display goals text
                Text(goal)
                    .font(.body)
                    .foregroundColor(.black)

                Spacer()

                // check button to mark goal as completed
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
