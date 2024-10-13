import SwiftUI
import SwiftData

/**
 The `WorkoutView` provides an interface for users to explore and save workout routines.
 It has two tabs: "Explore" for browsing predefined workout routines, and "My Routines" for viewing user-saved routines. The view integrates with SwiftData to manage saved routines.
 */
struct WorkoutView: View {
    
    /// Tracks the selected tab: "Explore" or "My Routines".
    @State private var selectedTab = "Explore"
    
    /// A set of saved routine names, used to track which routines have been saved by the user.
    @State private var savedRoutineNames: Set<String> = []
    
    /// A query to fetch saved workout routines using SwiftData, sorted by the name.
    @Query(sort: \SavedRoutine.name, order: .forward) var savedRoutines: [SavedRoutine]
    
    /// Provides access to the SwiftData context for saving new routines.
    @Environment(\.modelContext) var modelContext

    /// A list of hardcoded workout routines to display in the "Explore" tab.
    /// These routines are constant and are not integrated with SwiftData.
    let exploreRoutines = [
        WorkoutRoutine(name: "Pull Day Routine",
                       imageName: "strength1",
                       time: "90 mins",
                       description: "Push the limits with pull day exercises."),
        WorkoutRoutine(name: "Push Day Routine",
                       imageName: "strength2",
                       time: "90 mins",
                       description: "Push the limits with push day exercises."),
        WorkoutRoutine(name: "7 Minute Daily Workout",
                       imageName: "fullbody1",
                       time: "7 mins",
                       description: "7 mins a day keeps the doctor away."),
        WorkoutRoutine(name: "Fullbody Mat Routine",
                       imageName: "fullbody2",
                       time: "20 mins",
                       description: "Grab your yoga mat and complete this low intensity full body workout."),
        WorkoutRoutine(name: "Strength Dumbbell Workout",
                       imageName: "dumbbell1",
                       time: "20 mins",
                       description: "Train your core strength with this dumbbell-only workout."),
        WorkoutRoutine(name: "Lower Body Workout",
                       imageName: "dumbbell2",
                       time: "15 mins",
                       description: "Minimal equipment lower body workout."),
        WorkoutRoutine(name: "Everyday Stretch Routine",
                       imageName: "stretch1",
                       time: "7 mins",
                       description: "Low intensity, quick, and perfect to incorporate into your everyday life."),
        WorkoutRoutine(name: "Flexibility Stretch Routine",
                       imageName: "stretch2",
                       time: "10 mins",
                       description: "Perfect for those trying to increase their flexibility."),
        WorkoutRoutine(name: "Skipping Warm Up Routine",
                       imageName: "cardio1",
                       time: "10 mins",
                       description: "Warm up before your workout with this skipping routine."),
        WorkoutRoutine(name: "Outdoor Cardio Routine",
                       imageName: "cardio2",
                       time: "30 mins",
                       description: "Perfect for outdoors.")
    ]

    var body: some View {
        VStack {
            // Header
            Text("Workouts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 0.569, blue: 0.396))  // Orange color for header
                .padding(.top)
            
            // Tab switcher between "Explore" and "My Routines"
            HStack {
                Button(action: {
                    selectedTab = "Explore"
                }) {
                    Text("Explore")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == "Explore" ? Color(red: 1.0, green: 0.569, blue: 0.396) : Color.white)  // Orange color for selected tab
                        .foregroundColor(selectedTab == "Explore" ? Color.white : Color.black)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    selectedTab = "My Routines"
                }) {
                    Text("My Routines")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == "My Routines" ? Color(red: 1.0, green: 0.569, blue: 0.396) : Color.white)  // Orange color for selected tab
                        .foregroundColor(selectedTab == "My Routines" ? Color.white : Color.black)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            // Display content based on the selected tab
            if selectedTab == "Explore" {
                // Explore tab: display predefined routines
                ScrollView {
                    ForEach(exploreRoutines) { routine in
                        RoutineCardView(routine: routine, isSaved: savedRoutineNames.contains(routine.name), onSave: {
                            saveRoutine(routine)
                        })
                    }
                }
                .padding()
            } else {
                // My Routines tab: display saved routines from SwiftData
                if savedRoutines.isEmpty {
                    Text("You have no saved routines. Save a workout routine from our Explore page and it will appear here.")
                        .font(.headline)
                        .padding()
                } else {
                    ScrollView {
                        ForEach(savedRoutines) { routine in
                            SavedRoutineCardView(savedRoutine: routine)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            updateSavedRoutineNames()
        }
    }

    /**
     Saves the selected workout routine into the SwiftData database if it's not already saved.
     
     - Parameter routine: The `WorkoutRoutine` to save.
     */
    
    private func saveRoutine(_ routine: WorkoutRoutine) {
        // Only save if the routine is not already saved
        guard !savedRoutineNames.contains(routine.name) else { return }
        
        let newSavedRoutine = SavedRoutine(
            name: routine.name,
            imageName: routine.imageName,
            time: routine.time,
            workoutDescription: routine.description
        )
        modelContext.insert(newSavedRoutine)  // Insert the new saved routine into SwiftData
        
        savedRoutineNames.insert(routine.name)  // Add the routine to the saved list
    }
    
    /**
     Updates the list of saved routine names from the saved routines fetched via SwiftData.
     */
    private func updateSavedRoutineNames() {
        savedRoutineNames = Set(savedRoutines.map { $0.name })
    }
}

/**
 A view that displays a workout routine in the "Explore" tab.
 
 The user can view workout details and save the routine to "My Routines".
 */
struct RoutineCardView: View {
    /// The workout routine being displayed.
    let routine: WorkoutRoutine
    
    /// A boolean value that indicates whether the routine is already saved.
    let isSaved: Bool
    
    /// A closure to handle saving the routine when the user taps the "Save to My Routines" button.
    let onSave: () -> Void
    
    /// Tracks whether the detail modal is being shown.
    @State private var showDetails = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(routine.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
                .onTapGesture(count: 2) {
                    showDetails = true  /// Show workout details in a modal on double-tap
                }
                .sheet(isPresented: $showDetails) {
                    WorkoutDetailModal(routine: routine)
                }

            Text(routine.name)
                .font(.headline)

            HStack {
                Image(systemName: "clock")
                Text(routine.time)
            }

            Text(routine.description)
                .font(.subheadline)
                .lineLimit(2)

            Button(action: onSave) {
                Text(isSaved ? "Saved" : "Save to My Routines")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isSaved ? Color.gray : Color(red: 0.404, green: 0.773, blue: 0.702))  // Green for default, gray if already saved
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isSaved)  /// Disables the save button if already saved

            Divider()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

/**
 A modal view that displays detailed information about a selected workout routine.
 */
struct WorkoutDetailModal: View {
    /// The workout routine being displayed in detail.
    var routine: WorkoutRoutine

    var body: some View {
        VStack {
            Image(routine.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300, maxHeight: 300)
            
            Text(routine.name)
                .font(.title)
                .padding()
            
            Text(routine.time)
                .font(.headline)
                .padding([.leading, .trailing, .bottom])
            
            Text(routine.detailedDescription)
                .padding()
                .multilineTextAlignment(.center)
            
            Button("Close") {
                // Placeholder action for closing the modal
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

/**
 A view for displaying a saved workout routine in the "My Routines" tab.
 */
struct SavedRoutineCardView: View {
    /// The saved workout routine being displayed.
    let savedRoutine: SavedRoutine

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(savedRoutine.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()

            Text(savedRoutine.name)
                .font(.headline)

            HStack {
                Image(systemName: "clock")
                Text(savedRoutine.time)
            }

            Text(savedRoutine.workoutDescription)
                .font(.subheadline)
                .lineLimit(2)

            Divider()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

/**
 A helper model representing a workout routine in the "Explore" tab. This model is not stored in SwiftData.
 */

struct WorkoutRoutine: Identifiable {
    /// The unique identifier for the workout routine.
    let id = UUID()
    
    /// The name of the workout routine.
    let name: String
    
    /// The image name associated with the workout routine.
    let imageName: String
    
    /// The time duration for the workout routine.
    let time: String
    
    /// A brief description of the workout routine.
    let description: String
    
    /// A detailed description of the workout routine, used in the detail modal.
    let detailedDescription: String

    /**
     Initializes a new `WorkoutRoutine` instance.
     
     - Parameters:
       - name: The name of the workout.
       - imageName: The name of the workout image file.
       - time: The duration of the workout.
       - description: A brief description of the workout.
       - detailedDescription: A detailed description for the modal view. Defaults to an empty string.
     */
    init(name: String, imageName: String, time: String, description: String, detailedDescription: String = "") {
        self.name = name
        self.imageName = imageName
        self.time = time
        self.description = description
        self.detailedDescription = detailedDescription
    }
}
