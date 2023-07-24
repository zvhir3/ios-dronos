import SwiftUI

struct VerifyOTPPage: View {
    //MARK -> PROPERTIES
    
    enum FocusPin {
        case pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix
    }
    
    let email: String
    
    @FocusState private var pinFocusState: FocusPin?
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""
    @State var pinFive: String = ""
    @State var pinSix: String = ""
    @State private var alertMessage = ""
    @State private var navigateToLaunchpad = false
    
    @State private var showAlert = false
    
    //MARK -> BODY
    var body: some View {
        VStack {
            Text("Verify your OTP")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Enter 6 digit code we text you on \(email)" )
                .font(.caption)
                .fontWeight(.thin)
                .padding(.top)
            
            HStack(spacing: 15) {
                TextField("", text: $pinOne)
                    .modifier(OtpModifer(pin: $pinOne))
                    .border(Color.gray, width: 1)
                    .onChange(of: pinOne) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinTwo
                        }
                    }
                    .focused($pinFocusState, equals: .pinOne)
                
                TextField("", text: $pinTwo)
                    .modifier(OtpModifer(pin: $pinTwo))
                    .border(Color.gray, width: 1)
                    .onChange(of: pinTwo) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinThree
                        } else {
                            if newVal.count == 0 {
                                pinFocusState = .pinOne
                            }
                        }
                    }
                    .focused($pinFocusState, equals: .pinTwo)
                
                TextField("", text: $pinThree)
                    .modifier(OtpModifer(pin: $pinThree))
                    .border(Color.gray, width: 1)
                    .onChange(of: pinThree) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinFour
                        } else {
                            if newVal.count == 0 {
                                pinFocusState = .pinTwo
                            }
                        }
                    }
                    .focused($pinFocusState, equals: .pinThree)
                
                TextField("", text: $pinFour)
                    .modifier(OtpModifer(pin: $pinFour))
                    .border(Color.gray, width: 1)
                    .onChange(of: pinFour) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinFive
                        } else {
                            if newVal.count == 0 {
                                pinFocusState = .pinThree
                            }
                        }
                    }
                    .focused($pinFocusState, equals: .pinFour)
                
                TextField("", text: $pinFive)
                    .modifier(OtpModifer(pin: $pinFive))
                    .border(Color.gray, width: 1)
                    .onChange(of: pinFive) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinSix
                        } else {
                            if newVal.count == 0 {
                                pinFocusState = .pinFour
                            }
                        }
                    }
                    .focused($pinFocusState, equals: .pinFive)
                
                TextField("", text: $pinSix)
                    .modifier(OtpModifer(pin: $pinSix))
                    .border(Color.gray, width: 1)
                    .onChange(of: pinSix) { newVal in
                        if newVal.count == 0 {
                            pinFocusState = .pinFive
                        }
                    }
                    .focused($pinFocusState, equals: .pinSix)
            }
            .padding(.vertical)
            
            // Explicitly set focus on the first pin field when the view appears
            .onAppear {
                pinFocusState = .pinOne
            }
            NavigationLink(destination: MapBox(), isActive: $navigateToLaunchpad) {
                EmptyView()
            }
            
            Button(action: {
                // Handle OTP verification here
                let otp = "\(pinOne)\(pinTwo)\(pinThree)\(pinFour)\(pinFive)\(pinSix)"
                print("Verifying OTP: \(otp)")
                
                // Post the OTP to the API
                guard let url = URL(string: "https://dev-api.dronos.ai/account/auth/verify-otp") else {
                    print("Invalid URL")
                    return
                }
                
                let bodyData: [String: Any] = [
                    "otp": Int(otp) ?? 0, // Convert OTP to an integer if needed
                    "email": "zahiruddin@aerodyne.group"
                ]
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyData) else {
                    print("Failed to serialize JSON data")
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("HTTP Response Status Code: \(httpResponse.statusCode)")
                        print("Error: \(httpResponse.description)")
                        if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                            print("Response Data: \(responseString)")
                            
                            // Parse the JSON response and extract the message field
                            if let json = try? JSONSerialization.jsonObject(with: responseData, options: []),
                               let jsonDict = json as? [String: Any],
                               let message = jsonDict["message"] as? String {
                                
                                DispatchQueue.main.async {
                                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                                        // HTTP status code is 200 or 201, show success message
                                        navigateToLaunchpad = true
                                    } else {
                                        // Show error message for other status codes
                                        alertMessage = message
                                        showAlert = true
                                        print(alertMessage)
                                    }
                                    
                                   
                                }
                            }
                        }
                    }
                }.resume()
                
            }, label: {
                Spacer()
                Text("Verify")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            })
            .padding(15)
            .background(Color.blue)
            .clipShape(Capsule())
            .padding()
            // Show the alert with the response message
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Verification Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            })
            
        }
    }
}
