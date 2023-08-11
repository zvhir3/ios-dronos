////
////  RegisterPage.swift
////  DronosUTM
////
////  Created by Hidayatul Nadhirah on 11/08/2023.
////  Copyright © 2023 DJI. All rights reserved.
////
//
//import SwiftUI
//
//struct RegisterData {
//    let email: String
//    let password: String
//    let first_name: String
//    let last_name: String
//}
//
//
//
//struct RegisterPage: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var first_name: String = ""
//    @State private var last_name: String = ""
//    @State private var keyboardOffset: CGFloat = 0
//    @State private var title: String = ""
//    @State private var message: String = ""
//    @FocusState private var isTextFieldFocused: Bool
//    @FocusState private var isSecureFieldFocused: Bool
//    @State private var showAlert: Bool = false
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                VStack {
//                    Spacer()
//                    VStack {
//                        VStack(alignment: .leading) {
//                            Text("Hi there,")
//                                .font(.system(size: 32, weight: .bold))
//                                .foregroundColor(Color(red: 0.13, green: 0.58, blue: 0.67))
//                                .frame(maxWidth: .infinity, alignment: .topLeading)
//
//                            Text("Let's get you on board")
//                                .font(.system(size: 32, weight: .bold))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity, alignment: .topLeading)
//                                .padding(.bottom, 10)
//
//                            Text("Create an account to access all features.")
//                                .font(.system(size: 15, weight: .medium))
//                                .foregroundColor(.white.opacity(0.6))
//                                .frame(maxWidth: .infinity, alignment: .topLeading)
//                                .padding(.bottom, 15)
//
//                            TextField("Email", text: $email)
//                                .textEditorStyle()
//                                .focused($isTextFieldFocused)
//                                .overlay(
//                                    invalidEmail ? AnyView(
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .inset(by: 0.5)
//                                                .stroke(Color(red: 189 / 255, green: 9 / 255, blue: 9 / 255), lineWidth: 0.5)
//                                            HStack {
//                                                Image("email-err") // SF Symbol for a magnifying glass
//                                                    .foregroundColor(.white)
//                                                    .padding(.horizontal, 20) // Position the icon
//                                                Spacer()
//                                            }
//                                        }
//                                    ) :
//                                        isTextFieldFocused ?
//                                    AnyView(
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .inset(by: 0.5)
//                                                .stroke(Color(red: 0, green: 0.94, blue: 1), lineWidth: 1)
//                                            HStack {
//                                                Image("email-active") // SF Symbol for a magnifying glass
//                                                    .foregroundColor(.white)
//                                                    .padding(.horizontal, 20) // Position the icon
//                                                Spacer()
//                                            }
//                                        }
//                                    ) : AnyView(
//                                        HStack {
//                                            Image("emailIcon") // SF Symbol for a magnifying glass
//                                                .foregroundColor(.white)
//                                                .padding(.horizontal, 20) // Position the icon
//                                            Spacer()
//                                        }
//                                    )
//                                )
//
//                            SecureField("Password", text: $password)
//                                .secureFieldStyle()
//                                .focused($isSecureFieldFocused)
//                                .overlay(
//                                    isInvalidPass ? AnyView(
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .inset(by: 0.5)
//                                                .stroke(Color(red: 189 / 255, green: 9 / 255, blue: 9 / 255), lineWidth: 0.5)
//                                            HStack{
//                                                Image("pass-err") // SF Symbol for a magnifying glass
//                                                    .foregroundColor(.white)
//                                                    .padding(.horizontal, 20) // Position the icon
//                                                Spacer()
//                                                Image("visibility_off") // SF Symbol for a magnifying glass
//                                                    .foregroundColor(.white)
//                                                    .padding(.horizontal, 20) // Position the icon
//                                            }
//                                        }
//                                    ) :
//                                        isSecureFieldFocused ?
//                                    AnyView(
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .inset(by: 0.5)
//                                                .stroke(Color(red: 0, green: 0.94, blue: 1), lineWidth: 1)
//                                            HStack{
//                                                Image("pass-active") // SF Symbol for a magnifying glass
//                                                    .foregroundColor(.white)
//                                                    .padding(.horizontal, 20) // Position the icon
//                                                Spacer()
//                                                Image("visibility_off") // SF Symbol for a magnifying glass
//                                                    .foregroundColor(.white)
//                                                    .padding(.horizontal, 20) // Position the icon
//                                            }
//                                        }
//                                    ) : AnyView(
//                                        HStack{
//                                            Image("passwordIcon") // SF Symbol for a magnifying glass
//                                                .foregroundColor(.white)
//                                                .padding(.horizontal, 20) // Position the icon
//                                            Spacer()
//                                            Image("visibility_off") // SF Symbol for a magnifying glass
//                                                .foregroundColor(.white)
//                                                .padding(.horizontal, 20) // Position the icon
//                                        }
//                                    )
//                                )
//
//
//                            Button(action: {
//                                if !isValidEmail(email) {
//                                    showAlert = true
//                                    invalidEmail = true
//                                    title = "Validation Error"
//                                    message = "Email must be the right format"
//                                }
//
//                                if !isValidPassword(password) {
//                                    showAlert = true
//                                    isInvalidPass = true
//                                    title = "Validation Error"
//                                    message = "Password must contain at least one uppercase, one digit, one symbol, and be at least 8 characters long."
//                                }
//
//                                if isValidEmail(email) && isValidPassword(password) {
//                                    let data = LoginData(email: email, password: password)
//                                    APIService.login(data) { result in
//                                        if (result == true) {
//                                            isLoggedIn = true
//                                        }else{
//                                            showAlert = true
//                                            title = "Login Failed"
//                                            message = "Please make sure your email and password is correct"
//                                        }
//                                    }
//                                }
//                            }) {
//                                Text("Login")
//                                    .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 58, alignment: .center)
//                                    .background(.black.opacity(0.15))
//                                    .background(Color(red: 0.13, green: 0.58, blue: 0.67))
//                                    .cornerRadius(15)
//                                    .foregroundColor(.white)
//                                    .buttonStyle(PlainButtonStyle())
//                            }
//                            .buttonStyle(PlainButtonStyle())
//
//                            HStack(alignment: .center, spacing: 2) {
//                                Text("Don’t have an account?")
//                                    .font(
//                                        Font.custom("Barlow", size: 12)
//                                            .weight(.medium)
//                                    )
//                                    .multilineTextAlignment(.center)
//                                    .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
//                                Text("Register")
//                                    .font(
//                                        Font.custom("Barlow", size: 12)
//                                            .weight(.bold)
//                                    )
//                                    .multilineTextAlignment(.center)
//                                    .foregroundColor(Color(red: 0.13, green: 0.58, blue: 0.67))
//                            }
//                            .padding(0)
//                            .frame(maxWidth: .infinity, alignment: .center)
//
//                        }.alert(isPresented: $showAlert) {
//                            Alert(
//                                title: Text(title),
//                                message: Text(message),
//                                dismissButton: .default(Text("OK"))
//                            )
//                        }
//                        //                                }
//                        .padding()
//                        .frame(height: keyboardOffset == 0.0 ? 600 : 500)
//                    }
//                    .padding(.bottom, keyboardOffset)
//                    .animation(.easeInOut, value: true)
//                    .padding(.horizontal, 32)
//                    //                            .padding(.top, 8)
//                    .background(Color(red: 0.13, green: 0.15, blue: 0.2).opacity(0.6))
//                    .cornerRadius(28)
//                    .frame(width: .infinity)
//                }
//            }
//            .edgesIgnoringSafeArea(.all)
//            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
//                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//                keyboardOffset = keyboardFrame.height / 4
//            }
//            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
//                keyboardOffset = 0
//            }
//        }
//        navigationViewStyle(StackNavigationViewStyle())
//        .accentColor(.white)
//}
