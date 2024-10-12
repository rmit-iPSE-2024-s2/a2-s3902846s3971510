//
//  FitnessGoalView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI
import SwiftData

struct FitnessGoalView: View {
    @State private var availableGoals = ["Daily Workout Completed", 
                                         "10,000 Steps",
                                         "Hydrated with 2L Water",
                                         "8 Hours Sleep",
                                         "Weight Tracker"]
    @State private var activeGoals: [String] = []
    @State private var showAddGoal = false  // to show daily goal add menu
    @State private var currentWeight: String = ""  // current weight input
    @State private var isWeightEditable = true   // state for whether current weight input is editable
    @State private var completedGoals: [String] = []  // to track completed goals
    @State private var recentlyAddedGoal: String? = nil // to track added goals
    @State private var weightProgress: Double = 0.0  // to track weight progress
    @Environment(\.modelContext) var modelContext
    @Query var profiles: [Profile]

    var body: some View {
        let profile = profiles.first

        VStack(alignment: .leading, spacing: 20) {
            Text("Fitness Goals")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.819, green: 0.302, blue: 0.408))
                .padding(.top)

            if activeGoals.isEmpty {
                Text("You currently have no Fitness Goals added")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding(.top)
            } else {
                ForEach(activeGoals, id: \.self) { goal in
                    if goal == "Weight Tracker" {
                        weightTrackerSection(profile: profile)
                    } else {
                        DailyGoalTracker(goal: goal, isCompleted: completedGoals.contains(goal)) {
                            completedGoals.append(goal)  // mark goal as completed
                        }
                    }
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button(action: {
                    showAddGoal = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))
                }
                .sheet(isPresented: $showAddGoal) {
                    AddGoalSheet(availableGoals: $availableGoals, activeGoals: $activeGoals, recentlyAddedGoal: $recentlyAddedGoal)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }

    @ViewBuilder
    private func weightTrackerSection(profile: Profile?) -> some View {
        if let profile = profile {
            let goalWeight = profile.goalWeight
            let isGainingWeight = profile.goal == "Gain Weight"

            VStack(alignment: .leading) {
                HStack {
                    Text("Current Weight: \(currentWeight.isEmpty ? "Not Entered" : currentWeight) kg")
                    
                    if !isWeightEditable {
                        Button(action: {
                            isWeightEditable = true  // to make the current weight input editable again
                        }) {
                            Image(systemName: "pencil") // edit icon
                                .foregroundColor(.blue)
                        }
                    }
                }

                if !currentWeight.isEmpty, let current = Int(currentWeight) {
                    let remainingWeight = isGainingWeight ? goalWeight - current : current - goalWeight
                    let message = isGainingWeight ? "Gain \(remainingWeight) kg to reach your goal weight!" : "Lose \(remainingWeight) kg to reach your goal weight!"

                    if remainingWeight > 0 {
                        Text(message)
                    }

                    // Progress Bar
                    HStack {
                        Text("\(currentWeight) kg")
                        ProgressView(value: weightProgress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(height: 10)
                        Text("\(goalWeight) kg")
                    }
                }

                if isWeightEditable {
                    TextField("Enter current weight", text: $currentWeight, onCommit: {
                        validateAndSetWeight(goalWeight: goalWeight, isGainingWeight: isGainingWeight)
                    })
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.top)
        } else {
            Text("Profile data not found")
        }
    }

    private func validateAndSetWeight(goalWeight: Int, isGainingWeight: Bool) {
        if let current = Int(currentWeight), validateWeight(currentWeight: current, goalWeight: goalWeight, isGainingWeight: isGainingWeight) {
            updateWeightProgress(currentWeight: current, goalWeight: goalWeight, isGainingWeight: isGainingWeight)
            isWeightEditable = false  // make weight input uneditable after validation
        }
    }

    private func updateWeightProgress(currentWeight: Int, goalWeight: Int, isGainingWeight: Bool) {
        let progress = isGainingWeight ? Double(currentWeight) / Double(goalWeight) : Double(goalWeight) / Double(currentWeight)
        weightProgress = min(progress, 1.0)
    }

    // validation for current weight on weight tracker
    private func validateWeight(currentWeight: Int, goalWeight: Int, isGainingWeight: Bool) -> Bool {
        if isGainingWeight {
            return currentWeight <= goalWeight  // cannot exceed goal weight when gaining weight is the goal in profile
        } else {
            return currentWeight >= goalWeight  // cannot be lower than goal weight when losing weight is the goal in profile
        }
    }
}

struct AddGoalSheet: View {
    @Binding var availableGoals: [String]
    @Binding var activeGoals: [String]
    @Binding var recentlyAddedGoal: String?
    @Environment(\.dismiss) var dismiss  // Dismiss environment action

    var body: some View {
        NavigationView {
            List {
                ForEach(availableGoals, id: \.self) { goal in
                    Button(action: {
                        if !activeGoals.contains(goal) {
                            activeGoals.append(goal)
                            availableGoals.removeAll { $0 == goal }
                            recentlyAddedGoal = goal
                            dismiss()
                        }
                    }) {
                        Text(goal)
                    }
                }
            }
            .navigationTitle("Add Daily Goal")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()  // DONE BUTTON to close the Add Tracker menu
            })
        }
    }
}

struct DailyGoalTracker: View {
    var goal: String
    var isCompleted: Bool
    var markCompleted: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(goal)
                    .font(.body)
                    .foregroundColor(.black)

                Spacer()

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
