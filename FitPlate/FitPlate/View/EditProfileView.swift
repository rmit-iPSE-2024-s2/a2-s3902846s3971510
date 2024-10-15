import SwiftUI
import SwiftData

/**
 The `EditProfileView` allows users to update their profile details, including username, fitness goals, goal weight, calories, and step goals.
 
 Users can either edit an existing profile or create a new one if they have not already. When Edit Profile is selected,  it provides  a form-based layout with text fields, steppers, and pickers for input.
 
 The profile information is stored using SwiftData, and the view provides feedback to the user when the profile is successfully updated.
 */

struct EditProfileView: View {
    
    /// Access to the SwiftData model context for saving and updating profiles.
    @Environment(\.modelContext) var modelContext
    
    /// Dismisses the view after saving the profile.
    @Environment(\.dismiss) var dismiss
    
    /// The profile object that is being edited. If `nil`, a new profile will be created.
    var profile: Profile?

    /// All profile inputs and profile data that will be displayed and stored.
    @State private var username: String = ""
    @State private var goal: String = ""
    @State private var goalWeight: Int = 40
    @State private var calories: Int = 2000
    @State private var stepGoal: Int = 10000

    @State private var showingAlert = false
    
    /// A list of fitness goal options for the user to choose from.
    let goalOptions = ["Lose weight", 
                       "Gain weight",
                       "Maintain weight"]

    var body: some View {
        Form {
            // Section for entering the username
            Section(header: Text("Username")) {
                TextField("Enter username", text: $username)
            }

            // Section for selecting the user's fitness goal
            Section(header: Text("Goal")) {
                Picker("Select goal", selection: $goal) {
                    ForEach(goalOptions, id: \.self) {
                        Text($0)
                    }
                }
            }

            // Section for setting the user's goal weight
            Section(header: Text("Goal Weight")) {
                Stepper("\(goalWeight) kg", value: $goalWeight, in: 30...150)
            }

            // Section for setting the user's daily calorie goal
            Section(header: Text("Calories")) {
                Stepper("\(calories) kcal", value: $calories, in: 1200...3000, step: 100)
            }

            // Section for setting the user's daily step goal
            Section(header: Text("Step Goal")) {
                Stepper("\(stepGoal) steps", value: $stepGoal, in: 1000...20000, step: 1000)
            }

            // Button for saving the profile details
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
                        dismiss()  // Close the edit profile view after successful save
                    }
                )
            }
        }
        .onAppear {
            // Load the existing profile data into the form when the view appears
            if let profile = profile {
                username = profile.username
                goal = profile.goal
                goalWeight = profile.goalWeight
                calories = profile.calories
                stepGoal = profile.stepGoal
            }
        }
    }

    /**
     Saves the profile details by either updating an existing profile or editing the blank profile when account is first created
     
     If the `profile` is not `nil`, the existing profile is updated with the new values entered by the user. If the `profile` is `nil`, a new profile is created and inserted into the SwiftData model.
     
     After saving, the success alert is shown to the user.
     */
    
    
    private func saveProfile() {
        // Check if there's an existing profile, update it; otherwise, create a new one
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

        // Explicitly save the changes to persist data
        try? modelContext.save()

        // Show success alert
        showingAlert = true
    }
}

#Preview {
    EditProfileView()
}
