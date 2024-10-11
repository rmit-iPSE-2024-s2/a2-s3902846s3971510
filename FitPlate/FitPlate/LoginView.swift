import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loggedIn = false  // to track if login is successful
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
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
            
            // Login Button
            Button(action: {
                loggedIn = true
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
                BottomNavBarView()
                
            }
        }
    }
}
