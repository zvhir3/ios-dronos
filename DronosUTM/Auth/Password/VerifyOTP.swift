import SwiftUI
import Combine

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
    @State private var alertButton: String = ""
    @State private var alertMessage = ""
    @State private var navigateToResetPassword = false
    @State private var showAlert = false
    @State private var keyboardOffset: CGFloat = 0
    
    //MARK -> BODY
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    
                    VStack(spacing: 10) {
                        if (keyboardOffset == 0.0) {
                            Image("otp-image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 215, height: 203)
                                .clipped()
                        }
                        Spacer().frame(height: 5)
                        Text("Hang in there!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
//                        Spacer().frame(height: 10)
                        Text("We have sent a one-time password (OTP) to your inbox.Be sure to check your spam folder if the email isn’t in your inbox")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .fixedSize(horizontal: false, vertical: true)
//                        Spacer().frame(height: 10)
                        Text("Resend (52s)")
                            .font(.system(size: 12, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.4))
                        .frame(maxWidth: .infinity, alignment: .top)
                        HStack(spacing: 15) {
                            TextField("", text: $pinOne)
                                .modifier(OtpModifer(pin: $pinOne))
                                .onChange(of: pinOne) { newVal in
                                    if newVal.count == 1 {
                                        pinFocusState = .pinTwo
                                    }
                                }
                                .focused($pinFocusState, equals: .pinOne)
                                
                            
                            TextField("", text: $pinTwo)
                                .modifier(OtpModifer(pin: $pinTwo))
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
                                .onChange(of: pinSix) { newVal in
                                    if newVal.count == 0 {
                                        pinFocusState = .pinFive
                                    }
                                }
                                .focused($pinFocusState, equals: .pinSix)
                        }
                        .padding(.vertical)
                        .onAppear {
                            pinFocusState = .pinOne
                        }
                        NavigationLink(destination: ResetPasswordPage(email: email), isActive: $navigateToResetPassword) {
                            EmptyView()
                        }
//                        Spacer().frame(height: 30)
//                        HStack(alignment: .center, spacing: 10) {
                            Text("CREATE ACCOUNT")
                                .font(.system(size: 18, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(width: .infinity, height: 58, alignment: .center)
                            .background(Color(red: 0.29, green: 0.28, blue: 0.31).opacity(0.15))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .inset(by: 1)
                                    .stroke(Color(red: 0.79, green: 0.78, blue: 0.81).opacity(0.15), lineWidth: 2)
                            )
//                        }
                        
                        HStack(alignment: .center, spacing: 10) {
                            Button(action: {
                                let otp = "\(pinOne)\(pinTwo)\(pinThree)\(pinFour)\(pinFive)\(pinSix)"
                                APIService.verifyOTP(otp: otp, email: email){ result in
                                    if (result == true) {
                                        print("yoohoo")
                                        navigateToResetPassword = true
                                    }else{
                                        print("meheee")
                                         showAlert = true
                                        navigateToResetPassword = true
                                        alertMessage = "Please enter the right PIN"
                                        alertButton = "Retry"
                                    }
                                }
                                
                            }) {
                                Text("VERIFY")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .buttonStyle(PlainButtonStyle())
                                    
                            }
                            // Show the alert with the response message
                            .alert(isPresented: $showAlert, content: {
                                Alert(
                                    title: Text("Sorry"),
                                    message: Text("The OTP you insert is not valid"),
                                    dismissButton: .default(Text("OK"))
                                )
                            })
                        }
                        .frame(width: .infinity, height: 58, alignment: .center)
                        .background(.black.opacity(0.15))
                        .background(Color(red: 0.13, green: 0.58, blue: 0.67))
                        .cornerRadius(15)
                        .shadow(color: Color(red: 0.4, green: 0.38, blue: 0.98).opacity(0.15), radius: 10, x: 0, y: 11)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 11)
                    }
                    .frame(height: keyboardOffset == 0.0 ? 700 : 600)
                    
                }
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
            print("sini dia", keyboardOffset)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardOffset = 0
        }
    }
}

//struct VerifyOTPPage_Previews: PreviewProvider {
//    static var previews: some View {
//        VerifyOTPPage(email: "nad")
//    }
//}


struct OtpModifer: ViewModifier {

    @Binding var pin : String

    var textLimt = 1

    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }


    //MARK -> BODY
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimt)}
            .frame(width: 40, height: 45)
//            .padding(.leading, )
            .padding(.trailing, 7)
            .padding(.vertical, 5)
            .frame(alignment: .leading)
            .background(.white.opacity(0.1))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.25), radius: 1, x: 1, y: 1)
            .overlay(
            RoundedRectangle(cornerRadius: 8)
            .inset(by: -0.1)
            .stroke(.black.opacity(0.1), lineWidth: 0.2)
            )
    }
}
