import SwiftUI
import SwiftData

/**
 The `LoginView` provides a user interface for existing users to log in with their email and password.
 
 The view validates the entered credentials by checking them against saved user data. If the credentials are correct, the user is navigated to the HomeView
 */

struct LoginView: View {

    /// Login validation input data
    @State private var email = ""
    @State private var password = ""
    
    /// Tracks whether the user has successfully logged in, used for triggering navigation.
    @State private var loggedIn = false
    
    /// Tracks whether an error message should be shown.
    @State private var showError = false
    
    /// The error message to display when validation fails or login is unsuccessful.
    @State private var errorMessage = ""
    
    /// Provides access to the SwiftData model context for managing users.
    @Environment(\.modelContext) var modelContext
    
    /// Fetches all `User` entities from the model, sorted by email.
    @Query(sort: [SortDescriptor(\User.email)]) private var users: [User]

    var body: some View {
        VStack(spacing: 20) {
            // Login title
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Email input field
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .keyboardType(.emailAddress)

            // Password input field
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            // Login button
            Button(action: {
                loginUser()  // Attempt to log in the user
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
            // Navigation to main app view after successful login
            .navigationDestination(isPresented: $loggedIn) {
                BottomNavBarView()
            }

            Spacer()

            // Display error message if there is a login issue
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }

    /**
     Attempts to log in the user by validating the entered email and password in the relevant input fields.
     If the credentials match an existing user, the user is logged in, and the main app view is presented.
     
     If the email or password fields are empty, an error message is displayed.
     An error message is shown for invalid credentials.
     */
    
    
    private func loginUser() {
        // Validate that email and password are not empty
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email or password cannot be empty."  // Set error message for empty fields
            showError = true  // Show error message
            return
        }

        // Check if the entered credentials match any existing user
        if users.first(where: { $0.email == email && $0.password == password }) != nil {
            // Credentials are valid: proceed with login
            loggedIn = true
            showError = false
        } else {
            // Credentials do not match: show error
            errorMessage = "Invalid email or password."  // Set error message for invalid credentials
            showError = true  // Show error message
        }
    }
}

#Preview {
    LoginView()
        .modelContainer(for: User.self)
}
