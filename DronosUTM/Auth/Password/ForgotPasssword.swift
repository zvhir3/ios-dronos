import SwiftUI

struct ForgotPasswordPage: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var alertButton: String = ""
    @State private var otpSent: Bool = false
    
    var body: some View {
        VStack {
            Text("Forgot Password")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            TextField("Registered Email", text: $email)
                .padding()
                .foregroundColor(Color(UIColor.systemTeal))
                .font(.body)
                .background(Color(UIColor.systemTeal).opacity(0.2))
                .cornerRadius(10)
                .frame(height: 49)
                .border(Color.clear, width: 0)
                .padding(.horizontal)
            
            Button(action: {
                // Call the API to request a password reset
                resetPassword()
            }) {
                Text("Reset Password")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemTeal).opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.systemTeal), lineWidth: 2)
                    )
                    .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(alertButton)) {
                        if alertTitle == "OTP successfully sent!" {
                            otpSent = true
                        }else{
                            otpSent = false
                        }
                    }
                )
            }
            NavigationLink(
                destination: VerifyOTPPage(email: email), // Replace NextPage with the actual destination view
                isActive: $otpSent,
                label: { EmptyView() }
            )
            .hidden()
            Spacer()
        }
    }
    
    private func resetPassword() {
        // Create the request URL
        let baseUrl = "https://dev-api.dronos.ai/account" // Replace with your actual base URL
        let endpoint = "/auth/forgot-password"
        let urlString = baseUrl + endpoint
        
        // Create the request body
        let requestBody: [String: String] = ["email": email]
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error creating request body: \(error)")
            return
        }
        
        // Send the API request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 201 {
                    alertTitle = "OTP successfully sent!"
                    alertMessage = "Check your email and proceed to the next step."
                    alertButton = "Proceed"
                } else {
                    alertTitle = "Hmm are you sure?"
                    alertMessage = "Seems that the email is invalid."
                    alertButton = "Retry"
                }
                showAlert = true
            }
        }.resume()
    }
}
