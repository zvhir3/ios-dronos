import SwiftUI

struct ForgotPasswordPage: View {
    //    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var alertButton: String = ""
    @State private var otpSent: Bool = false
    @State private var keyboardOffset: CGFloat = 0
    @FocusState private var isTextFieldFocused: Bool
    @State private var invalidEmail: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: UIImage(named: "earth")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(1)
                VStack {
                    Spacer()
                    VStack {
                        if (keyboardOffset == 0.0) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 203, height: 216)
                                .background(
                                    Image("forgot-pass")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 203, height: 216)
                                        .clipped()
                                )
                            //                            Spacer().frame(height: 20)
                        }
                        
                        VStack {
                            Text("No worries! We got you.")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Spacer().frame(height: 10)
                            Text("Enter email associated with your account and we’ll send you passcode to reset your password.")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer().frame(height: 20)
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
                            Spacer().frame(height: 40)
                            HStack(alignment: .center, spacing: 10) { Text("CREATE ACCOUNT")
                                    .font(.system(size: 18, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center) }
                            .padding(16)
                            .frame(width: .infinity, height: 58, alignment: .center)
                            .background(Color(red: 0.29, green: 0.28, blue: 0.31).opacity(0.15))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .inset(by: 1)
                                    .stroke(Color(red: 0.79, green: 0.78, blue: 0.81).opacity(0.15), lineWidth: 2)
                            )
                            HStack(alignment: .center, spacing: 10) { Button(action: {
                                if !isValidEmail(email) {
                                    invalidEmail = true
                                    showAlert = true
                                    invalidEmail = true
                                    alertTitle = "Validation Error"
                                    alertMessage = "Email must be the right format"
                                    alertButton = "Retry"
                                } else {
                                    invalidEmail = false
                                    APIService.forgotPassword(email: email) { success in
                                        if success {
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
                                }
                                
                            }) {
                                Text("SEND PASSCODE")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
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
                            }
                            .padding(16)
                            .frame(width: .infinity, height: 58, alignment: .center)
                            .background(.black.opacity(0.15))
                            .background(Color(red: 0.13, green: 0.58, blue: 0.67))
                            .cornerRadius(15)
                            .shadow(color: Color(red: 0.4, green: 0.38, blue: 0.98).opacity(0.15), radius: 10, x: 0, y: 11)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 11)
                            
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
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                        .frame(height: 400)
                        NavigationLink(
                            destination: VerifyOTPPage(email: email).navigationBarBackButtonHidden(true),
                            isActive: $otpSent,
                            label: { EmptyView() }
                        )
                        .hidden()
                    }
                    .padding(.bottom, keyboardOffset)
                    .animation(.easeInOut, value: true)
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    .background(Color(red: 0.13, green: 0.15, blue: 0.2).opacity(0.6))
                    .cornerRadius(28)
                    .frame(width: .infinity, height: .infinity)
                }
                
                //                }
            }
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardOffset = keyboardFrame.height / 2
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardOffset = 0
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.white)
    }
    
    
}

//func isValidEmail(_ email: String) -> Bool {
//    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//    let pred = NSPredicate(format:"SELF MATCHES %@", regex)
//    return pred.evaluate(with: email)
//}

//struct ForgotPasswordPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ForgotPasswordPage()
//    }
//}
