//
//  FitnessGoalView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

struct FitnessGoalView: View {
    
    // state variables for daily goals to track
    @State private var completedDays: [String: Set<String>] = [
        "Workout Completion": [],
        "Steps Goal": [],
        "Water Intake": [],
        "Sleep Duration": []
    ]
    
    // days of week
    let daysOfWeek = ["M", "TU", "W", "TH", "F", "SA", "SU"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Fitness Goals")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.819, green: 0.302, blue: 0.408))
                .padding(.top)

            // PERSONAL GOALS
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Personal Goals")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702)) 

                VStack(alignment: .leading, spacing: 10) {
                    // Goal Weight Section
                    HStack {
                        Text("Goal Weight:")
                            .font(.body)
                            .foregroundColor(.black)
                        Spacer()
                        Text("Edit")
                            .font(.body)
                            .foregroundColor(Color.blue)
                    }
                    HStack {
                        Text("70 kg")
                        ProgressView(value: 0.2)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.404, green: 0.773, blue: 0.702)))
                            .scaleEffect(x: 1, y: 2)
                        Text("65 kg")
                    }
                    Text("You've lost 1 kg!")
                        .font(.body)
                        .foregroundColor(.black)

                    Spacer()
                    
                    // DAILY GOALS
                    Text("Daily Goals:")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))
                    
                    
                    DailyGoalView(goal: "Workout", actualGoal: "Daily Workout", completedDays: Binding(
                        get: { completedDays["Workout Completed"] ?? Set() },
                        set: { completedDays["Workout Completed"] = $0 }
                    ), daysOfWeek: daysOfWeek)
                    
                    DailyGoalView(goal: "Steps", actualGoal: "10,000", completedDays: Binding(
                        get: { completedDays["Steps Goal Met"] ?? Set() },
                        set: { completedDays["Steps Goal Met"] = $0 }
                    ), daysOfWeek: daysOfWeek)
                    
                    DailyGoalView(goal: "Water Intake", actualGoal: "2.5L", completedDays: Binding(
                        get: { completedDays["Water Intake"] ?? Set() },
                        set: { completedDays["Water Intake"] = $0 }
                    ), daysOfWeek: daysOfWeek)
                    
                    DailyGoalView(goal: "Sleep Duration", actualGoal: "8 Hours", completedDays: Binding(
                        get: { completedDays["Sleep Duration"] ?? Set() },
                        set: { completedDays["Sleep Duration"] = $0 }
                    ), daysOfWeek: daysOfWeek)
                }
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct DailyGoalView: View {
    var goal: String
    var actualGoal: String
    @Binding var completedDays: Set<String>
    let daysOfWeek: [String]
    
    var body: some View {
        let progress = Double(completedDays.count) / Double(daysOfWeek.count)
        
        VStack(alignment: .leading) {
            HStack {
                Text(goal)
                    .font(.body)
                    .foregroundColor(.black)
                Spacer()
                Text(actualGoal)
                    .font(.body)
                    .foregroundColor(.gray)
                Text("\(Int(progress * 100))%")
                    .font(.body)
                    .foregroundColor(.black)
            }
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.404, green: 0.773, blue: 0.702)))
                .scaleEffect(x: 1, y: 2)
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Button(action: {
                        if completedDays.contains(day) {
                            completedDays.remove(day)
                        } else {
                            completedDays.insert(day)
                        }
                    }) {
                        Text(day)
                            .frame(width: 30, height: 30)
                            .background(completedDays.contains(day) ? Color(red: 0.404, green: 0.773, blue: 0.702) : Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(.top)
    }
}

#Preview {
    FitnessGoalView()
}
