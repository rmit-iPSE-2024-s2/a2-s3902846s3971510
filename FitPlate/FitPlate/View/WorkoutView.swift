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
                       description: "Push the limits with pull day exercises.",
                       detailedDesc: "A Pull Day Routine targets and strengthens the back, biceps, and rear deltoids, enhancing upper body muscle balance and improving posture."),
        WorkoutRoutine(name: "Push Day Routine",
                       imageName: "strength2",
                       time: "90 mins",
                       description: "Push the limits with push day exercises.",
                       detailedDesc: "Is a comprehensive 90-minute workout designed to push the limits with exercises that target the chest, shoulders, and triceps, enhancing upper body strength and endurance."),
        WorkoutRoutine(name: "7 Minute Daily Workout",
                       imageName: "fullbody1",
                       time: "7 mins",
                       description: "7 mins a day keeps the doctor away.",
                       detailedDesc: "The 7 Minute Daily Workout efficiently boosts cardiovascular fitness and muscle strength across the entire body, all within a quick, daily time commitment of just 7 minutes."),
        WorkoutRoutine(name: "Fullbody Mat Routine",
                       imageName: "fullbody2",
                       time: "20 mins",
                       description: "Grab your yoga mat and complete this low intensity full body workout.",
                       detailedDesc: "Is a 20-minute, low-intensity workout that utilizes a yoga mat to engage the entire body, making it perfect for those seeking a gentle yet effective exercise session."),
        WorkoutRoutine(name: "Strength Dumbbell Workout",
                       imageName: "dumbbell1",
                       time: "20 mins",
                       description: "Train your core strength with this dumbbell-only workout.",
                       detailedDesc: "The Strength Dumbbell Workout focuses on enhancing core strength through a targeted 20-minute routine that utilizes only dumbbells, making it ideal for efficient and effective strength training."),
        WorkoutRoutine(name: "Lower Body Workout",
                       imageName: "dumbbell2",
                       time: "15 mins",
                       description: "Minimal equipment lower body workout.",
                       detailedDesc: "It is a 15-minute routine designed to strengthen the lower body using minimal equipment, making it convenient and accessible for quick, effective training."),
        WorkoutRoutine(name: "Everyday Stretch Routine",
                       imageName: "stretch1",
                       time: "7 mins",
                       description: "Low intensity, quick, and perfect to incorporate into your everyday life.",
                       detailedDesc: "Offers a low-intensity, 7-minute stretching sequence that is easy to incorporate into daily life, promoting flexibility and reducing the risk of injuries."),
        WorkoutRoutine(name: "Flexibility Stretch Routine",
                       imageName: "stretch2",
                       time: "10 mins",
                       description: "Perfect for those trying to increase their flexibility.",
                       detailedDesc: "It is a 10-minute program specifically designed for individuals aiming to enhance their flexibility, providing targeted stretches that can help improve overall range of motion."),
        WorkoutRoutine(name: "Skipping Warm Up Routine",
                       imageName: "cardio1",
                       time: "10 mins",
                       description: "Warm up before your workout with this skipping routine.",
                       detailedDesc: "It is a dynamic 10-minute session that utilizes skipping to effectively warm up the body, preparing it for more intense workouts and reducing the risk of injury."),
        WorkoutRoutine(name: "Outdoor Cardio Routine",
                       imageName: "cardio2",
                       time: "30 mins",
                       description: "Perfect for outdoors.",
                       detailedDesc: "It is a 30-minute exercise program ideal for outdoor settings, designed to boost cardiovascular health and increase energy levels through dynamic movement.")
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
            
            Text(routine.detailedDesc)
                .padding()
                .multilineTextAlignment(.center)
            
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
    let detailedDesc: String

    /**
     Initialises a new `WorkoutRoutine` instance.
     
     - Parameters:
       - name: The name of the workout.
       - imageName: The name of the workout image file.
       - time: The duration of the workout.
       - description: A brief description of the workout.
       - detailedDesc: A detailed description for the modal view. Defaults to an empty string.
     */
    init(name: String, imageName: String, time: String, description: String, detailedDesc: String = "") {
        self.name = name
        self.imageName = imageName
        self.time = time
        self.description = description
        self.detailedDesc = detailedDesc
    }
}

#Preview {
    WorkoutView()
}
