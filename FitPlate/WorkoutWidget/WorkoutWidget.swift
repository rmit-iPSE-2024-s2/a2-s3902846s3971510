import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), routines: [WorkoutItem(name: "Placeholder Routine", description: "A placeholder workout description")])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), routines: [WorkoutItem(name: "Snapshot Routine", description: "A snapshot workout description")])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let routines = fetchSavedWorkouts()  // Fetch saved routines, possibly from shared storage or your app's database.
        let entry = SimpleEntry(date: currentDate, routines: routines)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func fetchSavedWorkouts() -> [WorkoutItem] {
        // Mocked data; replace this with actual data fetching logic.
        
        return [
            WorkoutItem(name: "Morning Stretch", description: "Start your day with a stretching routine."),
            WorkoutItem(name: "Evening Run", description: "A quick run to end your day.")
        ]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let routines: [WorkoutItem]
}

struct WorkoutItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}

struct WorkoutWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ForEach(entry.routines) { routine in
                VStack(alignment: .leading) {
                    Text(routine.name)
                        .font(.headline)
                    Text(routine.description)
                        .font(.caption)
                }
            }
        }
    }
}

@main
struct WorkoutWidget: Widget {
    let kind: String = "WorkoutWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WorkoutWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Workout Routines")
        .description("Displays your saved workout routines.")
    }
}

