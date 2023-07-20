import SwiftUI

struct LoginData {
    let email: String
    let password: String
}

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showAlert: Bool = false
    @State private var keyboardOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black // Set the background color to black
                if isLoggedIn {
                    MapBox()
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.5))
                } else {
                    VStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        
                        Text("Dronos UTM") // Add a title
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email")
                                .font(.headline)
                            TextField("Email", text: $email)
                                .padding()
                                .foregroundColor(Color(UIColor.fromHex(0x00F0FF)))
                                .font(.body)
                                .background(Color(UIColor.fromHex(0x8EF9F9, opacity: 0.2)))
                                .cornerRadius(10)
                                .frame(height: 49)
                                .border(Color.clear, width: 0)
                            
                            Spacer()
                                .frame(height: 10)
                            
                            Text("Password")
                                .font(.headline)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .foregroundColor(Color(UIColor.fromHex(0x00F0FF)))
                                .font(.body)
                                .background(Color(UIColor.fromHex(0x8EF9F9, opacity: 0.2)))
                                .cornerRadius(10)
                                .frame(height: 49)
                                .border(Color.clear, width: 0)
                            
                            Spacer()
                                .frame(height: 20)
                            
                            Button(action: {
                                let data = LoginData(email: email, password: password)
                                APIService.login(data) { result in
                                    if result {
                                        showAlert = result
                                        
                                    }
                                }
                            }) {
                                Text("Login")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(UIColor.fromHex(0x8EF9F9, opacity: 0.2)))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(UIColor.fromHex(0x8EF9F9)), lineWidth: 2)
                                    )
                                    .buttonStyle(PlainButtonStyle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }.alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Status"),
                                message: Text("Login successful"),
                                dismissButton: .default(Text("OK")) {
                                    isLoggedIn = true
                                }
                            )
                        }
                        .padding()
                    }
                    .padding(.bottom, keyboardOffset) // Adjust the bottom padding based on the keyboard offset
                    .animation(.easeInOut) // Apply animation to the view when it adjusts to the keyboard
                    
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardOffset = keyboardFrame.height / 2.5 // Update the keyboard offset to adjust the view's layout
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardOffset = 0 // Reset the keyboard offset when the keyboard is dismissed
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle to support earlier iOS versions
        .accentColor(.white) // Set the accent color for navigation elements
    }
}
