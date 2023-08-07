import SwiftUI

struct ResetPasswordPage: View {
    // MARK -> PROPERTIES
    
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var navigateToLogin: Bool = false
    @State private var isInvalidPass: Bool = false
    @State private var isInvalidConfirmPass: Bool = false
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var isPassConfirm: Bool = false
    @FocusState private var isSecureFieldFocused: Bool
    @FocusState private var isConfirmFieldFocused: Bool
    
    
    let email: String
    @State private var keyboardOffset: CGFloat = 0
    
    // MARK -> BODY
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    VStack {
                        VStack(spacing: 15) {
                            if (keyboardOffset == 0.0) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 203, height: 203)
                                    .background(
                                        Image("reset-password")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 203, height: 203)
                                            .clipped()
                                    )
                            }
                            Spacer().frame(height: 5)
                            Text("Almost done..")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text("Enter your new password here.")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            Text("Tips! A strong password helps to prevent unauthorized access to your account. Use upper and lower case characters, numbers, and symbols.")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 20)
                            
                            //                            SecureField("New Password", text: $newPassword)
                            //                                .secureFieldStyle()
                            //                                .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                            
                            SecureField("Password", text: $newPassword)
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
                            
                            //                            SecureField("Confirm New Password", text: $confirmPassword)
                            //                                .secureFieldStyle()
                            //                                .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                            //                                .padding(.bottom, 15)
                            
                            SecureField("Password", text: $confirmPassword)
                                .secureFieldStyle()
                                .focused($isConfirmFieldFocused)
                                .overlay(
                                    isInvalidConfirmPass ? AnyView(
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
                                        isConfirmFieldFocused ?
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
                            
                            Button(action: {
                                if !isValidPassword(newPassword) {
                                    print("sini 1")
                                    showAlert = true
                                    isInvalidPass = true
                                    title = "Validation Error"
                                    message = "Password must contain at least one uppercase, one digit, one symbol, and be at least 8 characters long."
                                } else if confirmPassword != newPassword {
                                    print("sini 2")
                                    isInvalidConfirmPass = true
                                    showAlert = true
                                    isPassConfirm = true
                                    title = "Validation Error"
                                    message = "Confirm password need to be the same as new password"
                                } else {
                                    isInvalidPass = false
                                    isInvalidConfirmPass = false
                                    APIService.resetPassword(email: email, password: newPassword){ result in
                                        if (result == true) {
                                            print("Password Reset Successful")
                                            navigateToLogin = true
                                        }else{
                                            print("Password Reset Failed")
                                            showAlert = true
                                        }
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
                            .frame(width: .infinity, height: 58, alignment: .center)
                            .background(.black.opacity(0.15))
                            .background(Color(red: 0.13, green: 0.58, blue: 0.67))
                            .cornerRadius(15)
                            .shadow(color: Color(red: 0.4, green: 0.38, blue: 0.98).opacity(0.15), radius: 10, x: 0, y: 11)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 11)
                            //                            .padding()
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text(title),
                                    message: Text(message),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            
                            NavigationLink(destination: LoginPage().navigationBarBackButtonHidden(true), isActive: $navigateToLogin)
                            {
                                EmptyView()
                            }
                            
                            HStack(alignment: .center, spacing: 2) {
                                Text("Already have an account?")
                                    .font(.system(size: 12, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                                NavigationLink(destination: LoginPage().navigationBarBackButtonHidden(true)) {
                                    Text("Login")
                                        .font(.system(size: 12, weight: .bold))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.13, green: 0.58, blue: 0.67))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(height: keyboardOffset == 0.0 ? 700 : 450)
                    }
                    .navigationBarHidden(true)
                    .padding(.bottom, keyboardOffset)
                    .animation(.easeInOut, value: true)
                    .padding(.horizontal, 35)
                    .background(Color(red: 0.13, green: 0.15, blue: 0.2).opacity(0.6))
                    .cornerRadius(28)
                    .frame(width: .infinity)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardOffset = keyboardFrame.height / 3
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardOffset = 0
            }
        }
    }
}
//
//struct ResetPasswordPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ResetPasswordPage(email: "nad")
//    }
//}
