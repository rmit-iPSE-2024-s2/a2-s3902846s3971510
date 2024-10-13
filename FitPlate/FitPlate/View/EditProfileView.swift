import SwiftUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.modelContext) var modelContext  // cccess SwiftData context
    @Environment(\.dismiss) var dismiss  // to close edit profile view after saving
    var profile: Profile?

    @State private var username: String = ""
    @State private var goal: String = ""
    @State private var goalWeight: Int = 40
    @State private var calories: Int = 2000
    @State private var stepGoal: Int = 10000

    @State private var showingAlert = false  // state to trigger alert for successful update
    let goalOptions = ["Lose weight", "Gain weight", "Maintain weight"]

    var body: some View {
        Form {
            Section(header: Text("Username")) {
                TextField("Enter username", text: $username)
    
            }

            Section(header: Text("Goal")) {
                Picker("Select goal", selection: $goal) {
                    ForEach(goalOptions, id: \.self) {
                        Text($0)
                    }
                }
            }

            Section(header: Text("Goal Weight")) {
                Stepper("\(goalWeight) kg", value: $goalWeight, in: 30...150)
            }

            Section(header: Text("Calories")) {
                Stepper("\(calories) kcal", value: $calories, in: 1200...3000, step: 100)
            }

            Section(header: Text("Step Goal")) {
                Stepper("\(stepGoal) steps", value: $stepGoal, in: 1000...20000, step: 1000)
            }

            Button(action: saveProfile) {
                Text("Save Profile")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.404, green: 0.773, blue: 0.702))  // Green
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Profile Updated Successfully!"),
                    dismissButton: .default(Text("OK")) {
                        dismiss()  // closing edit profile form once update successful
                    }
                )
            }
        }
        .onAppear {
            // load the existing profile data into the form when the view appears
            if let profile = profile {
                username = profile.username
                goal = profile.goal
                goalWeight = profile.goalWeight
                calories = profile.calories
                stepGoal = profile.stepGoal
            }
        }
    }

    private func saveProfile() {
        // check if there's an existing profile, update it, otherwise create a new one
        if let profile = profile {
            // Update the existing profile with new values
            profile.username = username
            profile.goal = goal
            profile.goalWeight = goalWeight
            profile.calories = calories
            profile.stepGoal = stepGoal
        } else {
            // Create a new profile and insert it into SwiftData
            let newProfile = Profile(
                username: username,
                goal: goal,
                goalWeight: goalWeight,
                calories: calories,
                stepGoal: stepGoal
            )
            modelContext.insert(newProfile)
        }

        // Explicitly save the changes to the context to persist the data
        try? modelContext.save()

        // Show success alert
        showingAlert = true
    }
}
