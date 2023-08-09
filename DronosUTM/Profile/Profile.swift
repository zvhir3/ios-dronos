import SwiftUI


struct ProfilePage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = true
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
                VStack {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .top)
                    Spacer()
                }
                VStack {
                    Spacer()
                    Text("ALVIN LIM")
                        .font(
                            Font.custom("Barlow", size: 20)
                                .weight(.medium)
                        )
                        .kerning(4)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 389, alignment: .center)
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            
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
                                .padding(.bottom, 80)
                            Text("LOGOUT")
                                .font(
                                    Font.custom("Barlow", size: 16)
                                        .weight(.semibold)
                                )
                                .kerning(7.4)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0, green: 0.94, blue: 1))
                                .frame(maxWidth: .infinity, alignment: .top)
                                .padding(.bottom, 30)
                            HStack(alignment: .center, spacing: 0) {
                                Spacer()
                                Image("aerodyne")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 8)
                                Text("DRON")
                                    .font(
                                        Font.custom("Barlow", size: 16)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.white)
                                Text("OS")
                                    .font(
                                        Font.custom("Barlow", size: 16)
                                    )
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }.alert(isPresented: $showAlert) {
                            Alert(
                                title: Text(title),
                                message: Text(message),
                                dismissButton: .default(Text("OK"))
                            )
                        }
//                        .background(Color(.red))
                        .padding(.top, -100)
                        .frame(height: 500)
                        
                    }
//                    .background(Color(.yellow))
                    .animation(.easeInOut, value: true)
                    .padding(.horizontal, 20)
                    .background(Color(red: 0.13, green: 0.15, blue: 0.2).opacity(1))
                    .cornerRadius(20)
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

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
