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
    @State private var invalidEmail: Bool = false
    @State private var isInvalidPass: Bool = false
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var keyboardOffset: CGFloat = 0
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isSecureFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLoggedIn {
                    Launchpad()
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.5), value: true)
                } else {
                    VStack {
                        Spacer()
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Hi there,")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(red: 0.13, green: 0.58, blue: 0.67))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                                Text("Welcome back!")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.bottom, 10)
                                
                                Text("Log in into your account to access all features.")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.bottom, 15)
                                
                                Text("Email")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                
                                TextField("Email", text: $email)
                                    .textEditorStyle()
                                    .focused($isTextFieldFocused)
                                    .overlay(
                                        invalidEmail ? AnyView(
                                            RoundedRectangle(cornerRadius: 15)
                                        .inset(by: 0.5)
                                        .stroke(Color(red: 189 / 255, green: 9 / 255, blue: 9 / 255), lineWidth: 0.5)
                                        ) :
                                        isTextFieldFocused ?
                                            AnyView(
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .inset(by: 0.5)
                                                        .stroke(Color(red: 0, green: 0.94, blue: 1), lineWidth: 1)
                                                    HStack {
                                                        Image("email-active") // SF Symbol for a magnifying glass
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal, 20) // Position the icon
                                                        Spacer()
                                                    }
                                                }
                                            ) : AnyView(
                                                HStack {
                                                    Image("emailIcon") // SF Symbol for a magnifying glass
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 20) // Position the icon
                                                    Spacer()
                                                }
                                            )
                                    )
                                
                                //                                    Spacer()
                                //                                        .frame(height: 10)
                                
                                Text("Password")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                                
                                SecureField("Password", text: $password)
                                    .secureFieldStyle()
                                    .focused($isSecureFieldFocused)
                                    .overlay(
                                        isInvalidPass ? AnyView(
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                .inset(by: 0.5)
                                                .stroke(Color(red: 189 / 255, green: 9 / 255, blue: 9 / 255), lineWidth: 0.5)
                                                HStack{
                                                    Image("pass-err") // SF Symbol for a magnifying glass
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 20) // Position the icon
                                                    Spacer()
                                                    Image("visibility_off") // SF Symbol for a magnifying glass
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 20) // Position the icon
                                                }
                                            }
                                        ) :
                                        isSecureFieldFocused ?
                                        AnyView(
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .inset(by: 0.5)
                                                    .stroke(Color(red: 0, green: 0.94, blue: 1), lineWidth: 1)
                                                HStack{
                                                    Image("pass-active") // SF Symbol for a magnifying glass
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 20) // Position the icon
                                                    Spacer()
                                                    Image("visibility_off") // SF Symbol for a magnifying glass
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 20) // Position the icon
                                                }
                                            }
                                        ) : AnyView(
                                            HStack{
                                                Image("passwordIcon") // SF Symbol for a magnifying glass
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 20) // Position the icon
                                                Spacer()
                                                Image("visibility_off") // SF Symbol for a magnifying glass
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 20) // Position the icon
                                            }
                                            )
                                    )
                                
                                
                                
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
                                
                                Button(action: {
//                                    if email.isEmpty || password.isEmpty {
//                                        showAlert = true
//                                        title = "Validation Error"
//                                        message = "Email or password cannot be empty."
//                                    }
                                    if !isValidEmail(email) {
                                        showAlert = true
                                        invalidEmail = true
                                        title = "Validation Error"
                                        message = "Email must be the right format"
                                    }
                                    
                                    if !isValidPassword(password) {
                                        showAlert = true
                                        isInvalidPass = true
                                        title = "Validation Error"
                                        message = "Password must contain at least one uppercase, one digit, one symbol, and be at least 8 characters long."
                                    }
                                    
                                    if isValidEmail(email) && isValidPassword(password) {
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
                            .frame(height: keyboardOffset == 0.0 ? 600 : 500)
                        }
                        .padding(.bottom, keyboardOffset)
                        .animation(.easeInOut, value: true)
                        .padding(.horizontal, 32)
                        //                            .padding(.top, 8)
                        .background(Color(red: 0.13, green: 0.15, blue: 0.2).opacity(0.6))
                        .cornerRadius(28)
                        .frame(width: .infinity)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardOffset = keyboardFrame.height / 4
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

//struct LoginPage_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginPage()
//    }
//}

func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let pred = NSPredicate(format:"SELF MATCHES %@", regex)
    return pred.evaluate(with: email)
}

func isValidPassword(_ password: String) -> Bool {
    // Password requirements: at least one uppercase,
    // one symbol, at least 8 characters total
    let regex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}"
    let pred = NSPredicate(format:"SELF MATCHES %@", regex)
    return pred.evaluate(with: password)
}
