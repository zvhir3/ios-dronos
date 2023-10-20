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
    @FocusState private var isTextFieldEmailFocused: Bool
    @FocusState private var isTextFieldPasswordFocused: Bool
    @FocusState private var isSecureFieldFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLoggedIn {
                    BottomNavigation()
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.5), value: true)
                } else {
                    Image(uiImage: UIImage(named: "earth")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(1)
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
                                
                                VStack(spacing: 15) {
                                    TextField("Email", text: $email)
                                        .textEditorStyle()
                                        .textInputAutocapitalization(.never)
                                        .focused($isTextFieldEmailFocused)
                                        .overlay(
                                            invalidEmail ? AnyView(
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .inset(by: 0.5)
                                                        .stroke(Color(red: 189 / 255, green: 9 / 255, blue: 9 / 255), lineWidth: 0.5)
                                                    HStack {
                                                        Image("email-err") // SF Symbol for a magnifying glass
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal, 20) // Position the icon
                                                        Spacer()
                                                    }
                                                }
                                            ) :
                                                isTextFieldEmailFocused ?
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
                                    
                                    if(isPasswordVisible) {
                                        SecureField("Password", text: $password)
                                            .secureFieldStyle()
                                            .focused($isSecureFieldFocused)
                                            .overlay(
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .inset(by: 0.5)
                                                        .stroke(isInvalidPass ? Color(red: 189 / 255, green: 9 / 255, blue: 9 / 255) : (isSecureFieldFocused ? Color(red: 0, green: 0.94, blue: 1) : Color.clear), lineWidth: isInvalidPass || isSecureFieldFocused ? 1 : 0.5)
                                                    
                                                    HStack {
                                                        Image("passwordIcon") // SF Symbol for a magnifying glass
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal, 20) // Position the icon
                                                        
                                                        Spacer()
                                                        
                                                        Button(action: {
                                                            isPasswordVisible.toggle()
                                                        }) {
                                                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                                                .foregroundColor(.white)
                                                                .padding(.horizontal, 20)
                                                        }
                                                        .padding(.trailing, 10)
                                                    }
                                                }
                                            )
                                    }else{
                                        TextField("Password", text: $password)
                                            .textEditorStyle()

                                            .focused($isTextFieldPasswordFocused)
                                            .overlay(
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .inset(by: 0.5)
                                                        .stroke(isInvalidPass ? Color(red: 189 / 255, green: 9 / 255, blue: 9 / 255) : (isSecureFieldFocused ? Color(red: 0, green: 0.94, blue: 1) : Color.clear), lineWidth: isInvalidPass || isSecureFieldFocused ? 1 : 0.5)
                                                    
                                                    HStack {
                                                        Image("passwordIcon") // SF Symbol for a magnifying glass
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal, 20) // Position the icon
                                                        
                                                        Spacer()
                                                        
                                                        Button(action: {
                                                            isPasswordVisible.toggle()
                                                        }) {
                                                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                                                .foregroundColor(.white)
                                                                .padding(.horizontal, 20)
                                                        }
                                                        .padding(.trailing, 10)
                                                    }
                                                }
                                            )
                                    }
                                    
                                    
                                }
                                
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
                                        login(email: email, password: password) { success in
                                            if success {
                                                isLoggedIn = true
                                            } else {
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
                                    NavigationLink(destination: RegisterPage().navigationBarBackButtonHidden(true)) {
                                        Text("Register")
                                            .font(
                                                Font.custom("Barlow", size: 12)
                                                    .weight(.bold)
                                            )
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(red: 0.13, green: 0.58, blue: 0.67))
                                    }
                                }
                                .padding(.top, 15)
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                            }.alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text(title),
                                    message: Text(message),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            //                                }
                            .padding(0)
                            .frame(height: keyboardOffset == 0.0 ? 500 : 600)
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

//


func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let pred = NSPredicate(format:"SELF MATCHES %@", regex)
    return pred.evaluate(with: email)
}

func isValidPassword(_ password: String) -> Bool {
    // Password requirements: at least one uppercase,
    // one symbol, at least 8 characters total
    //    let regex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}"
    //    let pred = NSPredicate(format:"SELF MATCHES %@", regex)
    //    return pred.evaluate(with: password)
    return true
}
