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
        // STRENGTH
        WorkoutRoutine(name: "Pull Day Routine", 
                       imageName: "strength1",
                       time: "90 mins",
                       description: "Push the limits with pull day exercises."),
       
        WorkoutRoutine(name: "Push Day Routine",
                       imageName: "strength2",
                       time: "90 mins",
                       description: "Push the limits with push day exercises."),
        
        // FULL BODY
        WorkoutRoutine(name: "7 Minute Daily Workout", 
                       imageName: "fullbody1", 
                       time: "7 mins",
                       description: "7 mins a day keeps the doctor away."),
        WorkoutRoutine(name: "Fullbody Mat Routine", 
                       imageName: "fullbody2",
                       time: "20 mins",
                       description: "Grab your yoga mat and complete this low intensity full body workout."),

        // DUMBBELL
        WorkoutRoutine(name: "Strength Dumbbell Workout", 
                       imageName: "dumbbell1",
                       time: "20 mins",
                       description: "Train your core strength with this dumbbell-only workout."),
        WorkoutRoutine(name: "Lower Body Workout", 
                       imageName: "dumbbell2",
                       time: "15 mins",
                       description: "Minimal equipment lower body workout."),

        // STRETCHING
        WorkoutRoutine(name: "Everyday Stretch Routine", 
                       imageName: "stretch1", 
                       time: "7 mins",
                       description: "Low intensity, quick, and perfect to incorporate into your everyday life."),
        WorkoutRoutine(name: "Flexibility Stretch Routine", 
                       imageName: "stretch2",
                       time: "10 mins",
                       description: "Perfect for those trying to increase their flexibility."),
    
        // CARDIO
        WorkoutRoutine(name: "Skipping Warm Up Routine", 
                       imageName: "cardio1",
                       time: "10 mins",
                       description: "Warm up before your workout with this skipping routine."),
        WorkoutRoutine(name: "Outdoor Cardio Routine", 
                       imageName: "cardio2",
                       time: "30 mins",
                       description: "Perfect for outdoors."),
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
//    let routine: WorkoutRoutine
//    let isSaved: Bool  // check if the routine is saved
//    let onSave: () -> Void
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Image(routine.imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(height: 150)
//                .clipped()
//
//            Text(routine.name)
//                .font(.headline)
//
//            HStack {
//                Image(systemName: "clock")
//                Text(routine.time)
//            }
//
//            Text(routine.description)
//                .font(.subheadline)
//                .lineLimit(2)
//
//            Button(action: onSave) {
//                Text(isSaved ? "Saved" : "Save to My Routines")
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(isSaved ? Color.gray : Color(red: 0.404, green: 0.773, blue: 0.702))  // green default, gray for already saved
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            .disabled(isSaved)  // disable save button if already saved
//
//            Divider()
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(8)
//    }
        let routine: WorkoutRoutine
        let isSaved: Bool  // check if the routine is saved
        let onSave: () -> Void
        @State private var showDetails = false  // State for modal visibility

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Image(routine.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .onTapGesture(count: 2) {
                        self.showDetails = true  // Toggle the state to show the modal on double tap
                    }
                    .sheet(isPresented: $showDetails) {
                        WorkoutDetailModal(routine: routine)  // Modal view with more details
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
                        .background(isSaved ? Color.gray : Color(red: 0.404, green: 0.773, blue: 0.702))  // Green default, gray for already saved
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isSaved)  // Disable save button if already saved

                Divider()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
}

struct WorkoutDetailModal: View {
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
                // Intentionally left blank for UI structure; handle closing in practice
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
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
    let detailedDescription: String  // Additional property for the modal

        init(name: String, imageName: String, time: String, description: String, detailedDescription: String = "") {
            self.name = name
            self.imageName = imageName
            self.time = time
            self.description = description
            self.detailedDescription = detailedDescription  // Default empty if not provided
        }
    
}




