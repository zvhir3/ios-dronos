import SwiftUI

struct ResetPasswordPage: View {
    // MARK -> PROPERTIES
    
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var navigateToLogin: Bool = false
    let email: String
    
    // MARK -> BODY
    var body: some View {
        NavigationView {
            VStack {
                Text("Reset Password")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    TextField("New Password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Confirm New Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical)
                
                Button(action: {
                    APIService.resetPassword(email: email, password: newPassword){ result in
                        if (result == true) {
                            print("Password Reset Successful")
                            navigateToLogin = true
                        }else{
                            print("Password Reset Failed")
                            showAlert = true
                        }
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
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Reset password failed"),
                        message: Text("Something is wrong with your input"),
                        dismissButton: .default(Text("Retry"))
                    )
                }
                NavigationLink(destination: LoginPage(), isActive: $navigateToLogin)
                {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
