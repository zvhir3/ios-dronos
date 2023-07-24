import SwiftUI

struct ResetPasswordView: View {
    //MARK -> PROPERTIES
    
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    //MARK -> BODY
    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                // New Password Text Field
                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Confirm Password Text Field
                SecureField("Confirm New Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding(.vertical)
            
            // Reset Password Button
            Button(action: {
                // Add your logic here to handle password reset
                // For example, check if newPassword and confirmPassword match
                if newPassword == confirmPassword {
                    // Passwords match, proceed with the reset
                    print("Password Reset Successful")
                } else {
                    // Passwords do not match, show an error message
                    print("Password Mismatch")
                }
            }, label: {
                Spacer()
                Text("Reset Password")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            })
            .padding(15)
            .background(Color.blue)
            .clipShape(Capsule())
            .padding()
        }
    }
}
