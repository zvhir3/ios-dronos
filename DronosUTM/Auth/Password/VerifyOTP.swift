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
    @State private var alertMessage = ""
    @State private var navigateToResetPassword = false
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
            
            .onAppear {
                pinFocusState = .pinOne
            }
            NavigationLink(destination: ResetPasswordPage(email: email), isActive: $navigateToResetPassword) {
                EmptyView()
            }
            
            Button(action: {
                let otp = "\(pinOne)\(pinTwo)\(pinThree)\(pinFour)\(pinFive)\(pinSix)"
                APIService.verifyOTP(otp: otp, email: email){ result in
                    if (result == true) {
                       print("yoohoo")
                        navigateToResetPassword = true
                    }else{
                        print("meheee")
                        // showAlert = true
                        navigateToResetPassword = true
                    }
                }
                
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
                Alert(
                    title: Text("Sorry"),
                    message: Text("The OTP you insert is not valid"),
                    dismissButton: .default(Text("OK"))
                )
            })
            
        }
    }
}

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
            .frame(width: 45, height: 45)
            .background(Color.white.cornerRadius(5))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("blueColor"), lineWidth: 2)
            )
    }
}
