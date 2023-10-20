import UIKit
import SwiftUI
import RealmSwift

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // ProductCommunicationService.shared.registerWithProduct()
        setInitialScreen()
        return true
    }
    func setInitialScreen() {
        var rootView: AnyView = AnyView(LoginPage()) // Default value
        
        // Check if Token has expired
        let realm = try! Realm()
        // Print the Realm file URL
        if let authSession = realm.objects(AuthSession.self).first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
            
            if let expirationDate = dateFormatter.date(from: authSession.tokenExpiredAt) {
                if Date() > expirationDate {
                    // Token has expired
                    print("Token has expired")
                } else {
                    // Token is still valid
                    print("\n\n\n")
                    print(asciiArt)
                    print("\n")
                    print("Token is still valid")
                    rootView = AnyView(
                        BottomNavigation()
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut(duration: 0.5), value: true)
                    )
                }
            }
        } else {
            // Auth session is empty (user has logged out)
            print("User has logged out")
            rootView = AnyView(
                LoginPage()
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.5), value: true)
            )
        }
        
        if let realmFileURL = realm.configuration.fileURL {
            print("\n\n\n")
            print("Realm Database Location: \(realmFileURL)")
            print("\n\n\n")
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: rootView)
        self.window = window
        window.makeKeyAndVisible()
    }
    
}
