import SwiftUI

/**
 The `SignupView` provides a user interface for new users to sign up by entering their email and password.
 
 The view performs basic validation to ensure the password and confirmation match, and that the email and password are not empty. Upon successful sign-up, the user is navigated to the login page.
 */

struct SignupView: View {
    
    /// User Sign Up data to be stored.
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    /// Tracks whether the user has successfully signed up, used for triggering navigation.
    @State private var signedUp = false
    
    /// Provides access to the SwiftData model context for managing users.
    @Environment(\.modelContext) var modelContext
    
    /// Tracks whether an error message should be shown.
    @State private var showError = false
    
    /// The error message to display when validation fails.
    @State private var errorMessage = ""
    
    /// Placeholder for any verification message (not currently used).
    @State private var verificationMessage = ""
    
    /**
     The `NavigationDestination` enum defines the destinations for navigation within the app.
     
     - `login`: Represents the destination to navigate to the login screen.
     */
    enum NavigationDestination {
        case login
    }

    /// The navigation path tracking the user's navigation within the app.
    @State private var path: [NavigationDestination] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                // Sign Up title
                Text("Sign Up")
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

                // Confirm password input field
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                // Sign Up button
                Button(action: {
                    signUpUser()  // Attempt to sign up the user
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.404, green: 0.773, blue: 0.702))  // Green color
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)

                Spacer()

                // Navigation link to login view if already a member
                Button(action: {
                    path.append(.login)  // Navigate to LoginView
                }) {
                    Text("Already a member? Login")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .alert(isPresented: $showError) {  // Error alert
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            // Handle navigation using `navigationDestination`
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .login:
                    LoginView()
                }
            }
        }
    }

    /**
     Validates the input fields and attempts to sign up the user.
     
     If the password and confirm password fields do not match, or if any required fields are empty, it sets an error message and displays an alert.
     
     If validation passes, a new `User` is created and saved to the model context. The user is then navigated to the login screen upon successful sign-up.
     */
    
    private func signUpUser() {
        // Validate that the passwords match
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."  // Set error message if passwords do not match
            showError = true  // Show error alert
            return
        }
        
        // Validate that the email and password are not empty
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email or password cannot be empty."  // Set error message for empty fields
            showError = true  // Show error alert
            return
        }

        // Create a new User object and save it to the model context
        let newUser = User(email: email, password: password)
        modelContext.insert(newUser)

        // Mark as signed up and navigate to the LoginView
        signedUp = true
        path.append(.login)
    }
}

#Preview {
    SignupView()
}
