import SwiftUI

struct NavBarView: View {
    @Binding var selectedTab: Int  // Binding to control the selected tab

    var body: some View {
        TabView(selection: $selectedTab) {  // Bind the selection to the TabView
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)  // Assign a tag to each tab

            RecipeView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Recipes")
                }
                .tag(1)

            WorkoutView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Workouts")
                }
                .tag(2)

            FitnessGoalsView()
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0  // Default to Home tab

    var body: some View {
        NavigationView {
            VStack {
                AnimatedTextView()
                    .padding(.bottom, 50)
                
                Image("logo")
                    .resizable()
                    .padding(.bottom, 25)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                
                Button(action: {
                    selectedTab = 0  // Set to Home tab when button is pressed
                }) {
                    Text("Get Started")
                        .padding()
                        .frame(minWidth: 200)
                        .background(Color(red: 0.819, green: 0.302, blue: 0.408))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                MainTabView(selectedTab: $selectedTab)  // Pass the selected tab binding
            }
        }
    }
}

#Preview {
    ContentView()
}
