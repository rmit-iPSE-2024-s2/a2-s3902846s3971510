import SwiftUI
import SwiftData

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loggedIn = false  // to track if login is successful
    @State private var showError = false
    @State private var errorMessage = ""
    @Environment(\.modelContext) var modelContext  // Access model context for querying users
    // Use @Query to fetch all User entities
    @Query(sort: [SortDescriptor(\User.email)]) private var users: [User]

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Email TextField
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .keyboardType(.emailAddress)

            // Password SecureField
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            // Login Button
            Button(action: {
                loginUser()
            }) {
                Text("Login")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.404, green: 0.773, blue: 0.702))  // Green color
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 40)
            .navigationDestination(isPresented: $loggedIn) {
                BottomNavBarView()  // Navigate to the main app view on successful login
            }

            Spacer()

            // Error message text
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }

    // Function to log in the user
    private func loginUser() {
            guard !email.isEmpty, !password.isEmpty else {
                errorMessage = "Email or password cannot be empty."
                showError = true
                return
            }

            // Check if a user exists with the entered email and password
        if users.first(where: { $0.email == email && $0.password == password }) != nil {
                // Credentials match: proceed with login
                loggedIn = true
                showError = false
            } else {
                // No match found: show error
                errorMessage = "Invalid email or password."
                showError = true
            }
        }
}

#Preview {
    LoginView()
        .modelContainer(for: User.self)
}

