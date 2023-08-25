import SwiftUI

struct RegisterData {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}

struct RegisterPage: View {
    @State private var keyboardOffset: CGFloat = 0
    @State private var showAlert: Bool = false
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var invalidEmail: Bool = false
    @State private var password: String = ""
    @FocusState private var isSecureFieldFocused: Bool
    @FocusState private var isLastNameFocused: Bool
    @FocusState private var isFirstNameFocused: Bool
    @State private var isInvalidPass: Bool = false
    @State private var isInvalidFirstname: Bool = false
    @State private var isInvalidLastname: Bool = false
    @State private var isLoggedIn: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                if isLoggedIn {
                    LoginPage()
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
                                
                                Text("Lets get you onboard.")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.bottom, 10)
                                
                                Text("Create an account to access all features.")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.bottom, 15)
                                
                                VStack(spacing: 15) {
                                    TextField("First Name", text: $firstName)
                                        .textEditorStyle()
                                        .focused($isFirstNameFocused)
                                        .overlay(
                                            isInvalidFirstname ? AnyView(
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
                                                isFirstNameFocused ?
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
                                    
                                    TextField("Last Name", text: $lastName)
                                        .textEditorStyle()
                                        .focused($isLastNameFocused)
                                        .overlay(
                                            isInvalidLastname ? AnyView(
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
                                                isLastNameFocused ?
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
                                    
                                    TextField("Email", text: $email)
                                        .textEditorStyle()
                                        .focused($isTextFieldFocused)
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
                                        let data = RegisterData(email: email, password: password, firstName: firstName, lastName: lastName)
                                        APIService.register(data) { result in
                                            if (result == true) {
                                                isLoggedIn = true
                                            }else{
                                                showAlert = true
                                                title = "Register Failed"
                                                message = "Please make sure your email and password is correct"
                                            }
                                        }
                                    }
                                }) {
                                    Text("REGISTER")
                                        .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 58, alignment: .center)
                                        .background(.black.opacity(0.15))
                                        .background(Color(red: 0.13, green: 0.58, blue: 0.67))
                                        .cornerRadius(15)
                                        .foregroundColor(.white)
                                        .buttonStyle(PlainButtonStyle())
                                    
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.top, 15)
                                
                                HStack(alignment: .center, spacing: 6) {
                                    Text("Already have an account?")
                                        .font(
                                            Font.custom("Barlow", size: 12)
                                                .weight(.medium)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                                    NavigationLink(destination: LoginPage()) {
                                        Text("Login")
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
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text(title),
                                    message: Text(message),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            .padding(0)
                            .frame(height: keyboardOffset == 0.0 ? 600 : 650)
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.white)
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage()
    }
}
