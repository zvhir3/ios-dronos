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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black // Set the background color to black
                if (isLoggedIn) {
                    MapBox()
                }
                else {
//                    ScrollView {
                    VStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        
                        Text("Dronos UTM") // Add a title
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email")
                                .font(.headline)
                            TextField("Email", text: $email)
                                .padding()
                                .foregroundColor(Color(red: 0, green: 240/255, blue: 255/255))
                                .font(.body)
                                .background(Color(red: 142/255, green: 249/255, blue: 249/255, opacity: 0.2))
                                .cornerRadius(10)
                                .frame(height: 49)
                                .border(Color.clear, width: 0)
                            
                            Spacer()
                                .frame(height: 10)
                            Text("Password")
                                .font(.headline)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .foregroundColor(Color(red: 0, green: 240/255, blue: 255/255))
                                .font(.body)
                                .background(Color(red: 142/255, green: 249/255, blue: 249/255, opacity: 0.2))
                                .cornerRadius(10)
                                .frame(height: 49)
                                .border(Color.clear, width: 0)
                            
                            Spacer()
                                .frame(height: 20)
                            Button(action: {
                                let data = LoginData(email: email, password: password)
                                //                            isLoggedIn = APIService.login(data);
                                APIService.login(data) { result in
//                                    isLoggedIn = result
                                    print("sini", result)
                                    if (result) {
                                        print("masuk tak sini sebenarnya")
                                        showAlert = result;
                                        
                                    }
                                    print("ada token tak", UserDefaults.standard.object(forKey: "token"))
                                }
                                print("Button tapped")
                                
                            }
                            )
                            {
                                Text("Login")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 0, green: 240/255, blue: 255/255, opacity: 0.2))
                                //                            .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 142/255, green: 249/255, blue: 249/255), lineWidth: 2)
                                    )
                                    .buttonStyle(PlainButtonStyle())
                            }
                            
                            .buttonStyle(PlainButtonStyle())
                        }.alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Status"),
                                message: Text("Login successful"),
                                dismissButton: .default(Text("OK")) {
                                    isLoggedIn = true
                                }
                            )
                        }
//                    }
                    .padding()
                }
            }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle to support earlier iOS versions
        .accentColor(.white) // Set the accent color for navigation elements
    }
    
   
}

//                    NavigationLink(
//                        destination: Splashscreen(),
//                        isActive: $isLoggedIn,
//                        label: {
//                            Text("Login")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color(red: 0, green: 240/255, blue: 255/255, opacity: 0.2))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .stroke(Color(red: 142/255, green: 249/255, blue: 249/255), lineWidth: 2)
//                                )
//                        })
//                    .onTapGesture {
//                        let data = LoginData(email: email, password: password)
//                        //                            isLoggedIn = APIService.login(data);
//                        APIService.login(data) { result in
//                            isLoggedIn = result
//                            print("sini", isLoggedIn)
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())
