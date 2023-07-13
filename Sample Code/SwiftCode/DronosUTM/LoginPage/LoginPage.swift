import SwiftUI

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white // Set the background color to white
                
                VStack {
                    Text("Welcome to Dronos UTM") // Add a title
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    NavigationLink(
                        destination: MapBox(),
                        isActive: $isLoggedIn,
                        label: {
                            Text("Login")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1))) // #1e1e1e
                                .cornerRadius(10)
                        })
                        .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle to support earlier iOS versions
        .accentColor(.white) // Set the accent color for navigation elements
    }
}
