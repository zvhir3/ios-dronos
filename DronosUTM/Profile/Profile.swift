import SwiftUI

struct Profile {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let workspaceId: String
}

func getUserProfile(completion: @escaping (Profile?) -> Void) {
    guard let savedToken = UserDefaults.standard.object(forKey: "token") as? String else {
        completion(nil)
        return
    }
    
    APIService.getProfile(token: savedToken) { apiProfile in
        guard let apiProfile = apiProfile else {
            completion(nil)
            return
        }
        
        // Convert APIService.Profile to Profile
        let convertedProfile = Profile(
            id: apiProfile.id,
            firstName: apiProfile.firstName,
            lastName: apiProfile.lastName,
            email: apiProfile.email,
            workspaceId: apiProfile.workspaceId
        )
        
        completion(convertedProfile)
    }
}

func performLogout(workspace_id: String, completion: @escaping (Bool) -> Void) {
    
    guard let savedToken = UserDefaults.standard.object(forKey: "token") as? String else {
        completion(false)
        return
    }
    APIService.logout(token: savedToken, workspaceId: workspace_id) { result in
        completion(result)
    }
}

func performDeactivateAcc(user_id: String, workspace_id: String, completion: @escaping (Bool) -> Void) {
    guard let savedToken = UserDefaults.standard.object(forKey: "token") as? String else {
        completion(false)
        return
    }
            
    APIService.deactivateAccount(token: savedToken, userId: user_id, workspaceId: workspace_id) { result in
        completion(result)
    }
}


struct ProfilePage: View {
    @State private var profile: Profile? = nil
    @State private var email: String = ""
    @State private var id: String = ""
    @State private var fullName: String = ""
    @State private var workspaceId: String = ""
    @State private var showLogin: Bool = false
    @State private var showingDeleteAlert = false
    @State private var showingSuccessAlert = false

    var body: some View {
        if showLogin {
            LoginPage()
        } else {
            NavigationView {
                ZStack {
                    VStack {
                        ZStack(alignment: .topTrailing) { // Set the alignment to topTrailing
                            Image("btn")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .top)
                            Button(action: {
                                performLogout(workspace_id: workspaceId) { success in
                                    if success {
                                        self.showLogin = true
                                        UserDefaults.standard.removeObject(forKey: "token")
                                    }
                                }
                            }) {
                                Image("logout")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing)
                                    .padding(.top, 60)
                            }
                        }
                        
                        
                        Spacer()
                    }
                    VStack {
                        
                        Spacer()
                        
                        Text(fullName)
                            .font(
                                Font.custom("Barlow", size: 20)
                                    .weight(.medium)
                            )
                            .kerning(4)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 389, alignment: .center)
                            .textCase(.uppercase)
                        VStack {
                            VStack(alignment: .leading) {
                                //                            if let unwrappedProfile = profile {
                                Text("FULLNAME")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                                    .padding(.top, 30)
                                
                                TextField("FULLNAME", text: $fullName)
                                    .textEditorStyle()
                                    .disabled(true)
                                    .overlay(
                                        HStack {
                                            Image("emailIcon") // SF Symbol for a magnifying glass
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 20) // Position the icon
                                            Spacer()
                                        }
                                    )
                                
                                Text("EMAIL")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top, 20)
                                TextField("EMAIL", text: $email)
                                    .textEditorStyle()
                                    .disabled(true)
                                    .overlay(
                                        HStack {
                                            Image("emailIcon") // SF Symbol for a magnifying glass
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 20) // Position the icon
                                            Spacer()
                                        }
                                    )
                                
                                
                                
                                //                            }
                                
                                Text("DELETE ACCOUNT")
                                    .font(Font.custom("Barlow", size: 16).weight(.semibold))
                                    .kerning(7.4)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0, green: 0.94, blue: 1))
                                    .frame(maxWidth: .infinity, alignment: .top)
                                    .padding(.bottom, 30)
                                    .padding(.top, 50)
                                    .onTapGesture {
                                        print("aaaaaaa")
                                        showingDeleteAlert = true
                                    }

                                Button(action: { /* No action needed here */ }, label: { EmptyView() })
                                    .alert(isPresented: $showingDeleteAlert) {
                                        Alert(
                                            title: Text("Warning"),
                                            message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                            primaryButton: .destructive(Text("Delete")) {
                                                performDeactivateAcc(user_id: id, workspace_id: workspaceId) { success in
                                                    if success {
                                                        self.showingSuccessAlert = true
                                                    }
                                                }
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    .frame(width: 0, height: 0)

                                Button(action: { /* No action needed here */ }, label: { EmptyView() })
                                    .alert(isPresented: $showingSuccessAlert) {
                                        Alert(title: Text("Account Deactivated"),
                                              message: Text("Your account has been successfully deactivated."),
                                              dismissButton: .default(Text("OK")) {
                                                  self.showLogin = true
                                              })
                                    }
                                    .frame(width: 0, height: 0)
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
                            }
                            .padding(.top, -140)
                            .frame(height:500)
                            
                        }
                        //                    .background(Color(.yellow))
                        .animation(.easeInOut, value: true)
                        .padding(.horizontal, 20)
                        .background(Color(red: 0.13, green: 0.15, blue: 0.2).opacity(1))
                        .cornerRadius(20)
                    }
                                    .onAppear {
                                        getUserProfile { fetchedProfile in
                                            self.profile = fetchedProfile
                                            self.id = fetchedProfile?.id ?? ""
                                            self.email = fetchedProfile?.email ?? ""
                                            self.fullName = "\(fetchedProfile?.firstName ?? "") \(fetchedProfile?.lastName ?? "")"
                                            self.workspaceId = fetchedProfile?.workspaceId ?? ""
                                        }
                                    }
                }
                .edgesIgnoringSafeArea(.all)
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(.white)
        }
    }
}
//
//struct ProfilePage_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePage()
//    }
//}
