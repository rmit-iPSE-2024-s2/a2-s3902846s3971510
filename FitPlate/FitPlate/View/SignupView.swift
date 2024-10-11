import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var signedUp = true  // to track if sign-up is successful
    @Environment(\.modelContext) var modelContext
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var verificationMessage = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Email
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
            
            // Password
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            // Confirm Password
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            // Sign Up Button
            Button(action: {
                signedUp = true
                signUpUser()
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
            .navigationDestination(isPresented: $signedUp) {
                UsersView(sortOrder:[SortDescriptor(\User.email)]   )  // nav to login after signup
            }
            
            Spacer()
            
            // nav to login view if already a member
            NavigationLink(destination: LoginView()) {
                Text("Already a member? Login")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    private func signUpUser() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showError = true
            return
        }
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email or password cannot be empty."
            showError = true
            return
        }
        
        let newUser = User(email: email, password: password)
        
        modelContext.insert(newUser)
        
    }
}



#Preview {
    SignupView()
}

