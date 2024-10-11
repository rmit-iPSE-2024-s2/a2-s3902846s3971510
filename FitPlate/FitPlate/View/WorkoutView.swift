import SwiftUI
import SwiftData

struct WorkoutView: View {
    @State private var selectedTab = "Explore"  // tab switcher
    @State private var savedRoutineNames: Set<String> = []  // Track saved routines by name
    
    // to fetch saved workout routines using swift data
    @Query(sort: \SavedRoutine.name, order: .forward) var savedRoutines: [SavedRoutine]
    @Environment(\.modelContext) var modelContext  // Access SwiftData context for saving new routines

    // hardcoded routines - didn't choose to use integrate swiftdata with these values as these would be constant.
    let exploreRoutines = [
        WorkoutRoutine(name: "Pull Day Routine", imageName: "strength1", time: "90 mins", description: "Push the limits with pull day exercises."),
        WorkoutRoutine(name: "Push Day Routine", imageName: "strength2", time: "90 mins", description: "Push the limits with push day exercises."),
        WorkoutRoutine(name: "Intense Glute Workout", imageName: "strength3", time: "90 mins", description: "Train your glutes with this high intensity lower body workout."),
        WorkoutRoutine(name: "7 Minute Daily Workout", imageName: "fullbody1", time: "7 mins", description: "7 mins a day keeps the doctor away."),
        WorkoutRoutine(name: "Fullbody Mat Routine", imageName: "fullbody2", time: "20 mins", description: "Grab your yoga mat and complete this low intensity full body workout.")
    ]
    
    var body: some View {
        VStack {
            // Header
            Text("Workouts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 0.569, blue: 0.396))  // Orange color for header
                .padding(.top)
            
            // tab switcher between 'Explore' and 'My Routines'
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

            if selectedTab == "Explore" {
                // display hardcoded routines in the 'Explore' tab
                ScrollView {
                    ForEach(exploreRoutines) { routine in
                        RoutineCardView(routine: routine, isSaved: savedRoutineNames.contains(routine.name), onSave: {
                            saveRoutine(routine)
                        })
                    }
                }
                .padding()
            } else {
                // display saved routines in 'My Routines' tab
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
            // update the saved routines list when the view appears
            updateSavedRoutineNames()
        }
    }
    
    // function to save a routine
    private func saveRoutine(_ routine: WorkoutRoutine) {
        // to only save if the routine is not already saved
        guard !savedRoutineNames.contains(routine.name) else { return }
        
        let newSavedRoutine = SavedRoutine(
            name: routine.name,
            imageName: routine.imageName,
            time: routine.time,
            workoutDescription: routine.description
        )
        modelContext.insert(newSavedRoutine)  // insert the saved routine into SwiftData
        
        savedRoutineNames.insert(routine.name)  // adding routine to the saved list
    }
    
    // function to update the list of saved routine names from SwiftData
    private func updateSavedRoutineNames() {
        savedRoutineNames = Set(savedRoutines.map { $0.name })
    }
}

// view for displaying a workout in 'Explore' tab
struct RoutineCardView: View {
    let routine: WorkoutRoutine
    let isSaved: Bool  // check if the routine is saved
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(routine.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()

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
                    .background(isSaved ? Color.gray : Color(red: 0.404, green: 0.773, blue: 0.702))  // green default, gray for already saved
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isSaved)  // disable save button if already saved

            Divider()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// view for displaying a saved workout in 'My Routines' tab
struct SavedRoutineCardView: View {
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

// helper model to use in the Explore tab, however doesn't need swiftData
struct WorkoutRoutine: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let time: String
    let description: String
}



