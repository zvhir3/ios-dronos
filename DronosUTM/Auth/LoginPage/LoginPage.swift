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
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var keyboardOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                //                Color.white
                //                BackgroundVideoView(videoURL: Bundle.main.url(forResource: "video", withExtension: "mp4")!)
                if isLoggedIn {
                    Launchpad()
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.5), value: true)
                } else {
                    GeometryReader { geometry in
                        VStack {
                            
                            Spacer()
                            VStack {
                                Text("Hi there,")
                                    .font(
                                        Font.custom("Barlow", size: 32)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(red: 0.13, green: 0.58, blue: 0.67))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.top, 20)
                                
                                Text("Welcome back!")
                                    .font(
                                        Font.custom("Barlow", size: 32)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                                Text("Log in into your account to access all features.")
                                    .font(
                                        Font.custom("Barlow", size: 15)
                                            .weight(.medium)
                                    )
                                    .kerning(0.1)
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                                
                                //                                keyboardOffset == 0.0 ? VStack : ScrollView
                                VStack(alignment: .leading) {
                                    
                                    Text("Email")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    
                                    TextField("Email", text: $email)
                                        .textEditorStyle()
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text("Password")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                                    
                                    SecureField("Password", text: $password)
                                        .loginSecureFieldStyle()
                                        .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                                    
                                    HStack {
                                        Spacer() // This will push the NavigationLink to the right
                                        NavigationLink(destination: ForgotPasswordPage().navigationBarBackButtonHidden(true)) {
                                            Text("Forgot Password")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
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
                                            .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 58, alignment: .center)
                                            .background(.black.opacity(0.15))
                                            .background(Color(red: 0.13, green: 0.58, blue: 0.67))
                                            .cornerRadius(15)
                                            .foregroundColor(.white)
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    HStack(alignment: .center, spacing: 2) {
                                        Text("Don’t have an account?")
                                            .font(
                                                Font.custom("Barlow", size: 12)
                                                    .weight(.medium)
                                            )
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                                        Text("Register")
                                            .font(
                                                Font.custom("Barlow", size: 12)
                                                    .weight(.bold)
                                            )
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(red: 0.13, green: 0.58, blue: 0.67))
                                    }
                                    .padding(0)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    
                                }.alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text(title),
                                        message: Text(message),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                                //                                }
                                .padding()
                                .frame(height: 700)
                            }
                            .padding(.bottom, keyboardOffset)
                            .animation(.easeInOut, value: true)
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                            .background(Color(red: 0.13, green: 0.15, blue: 0.2).opacity(0.6))
                            .cornerRadius(28)
                            .frame(width: .infinity)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardOffset = keyboardFrame.height / 1.5
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardOffset = 0
            }
            //            .navigationBarItems(leading: EmptyView())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.white)
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
