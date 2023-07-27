import SwiftUI

struct LoginData {
    let email: String
    let password: String
}

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = true
    @State private var showAlert: Bool = false
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var keyboardOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                if isLoggedIn {
                    Launchpad()
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.5), value: true)
                } else {
                    VStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        
                        Text("Dronos UTM")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextEditor(text: $email)
                                .textEditorStyle()
                            
                            Spacer()
                                .frame(height: 10)
                            
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(.white)
                            
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
                                    if (result == true) {
                                        isLoggedIn = true
                                    }else{
                                        showAlert = true
                                        title = "Login Failed"
                                        message = "Please make sure your email and password is correct"
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
                            NavigationLink(destination: ForgotPasswordPage()) {
                                Text("Forgot Password")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                        }.alert(isPresented: $showAlert) {
                            Alert(
                                title: Text(title),
                                message: Text(message),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        .padding()
                    }
                    .padding(.bottom, keyboardOffset)
                    .animation(.easeInOut, value: true)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardOffset = keyboardFrame.height / 2.5
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardOffset = 0
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.white)
    }
}
