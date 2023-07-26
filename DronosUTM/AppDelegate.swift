import UIKit
import SwiftUI

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Start the registration at the launch of the app. This can be retriggered at any time from the main view.
        // DJI App key needs to be registered in the Info.plist before calling this method.
        ProductCommunicationService.shared.registerWithProduct()
        
        // Create the appropriate view based on the login status
        let rootView: AnyView
        if isLoggedIn() {
            rootView = AnyView(Launchpad())
        } else {
            rootView = AnyView(
                LoginPage()
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.5), value: true)
            )
        }
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let splashScreen = Splashscreen().transition(.move(edge: .trailing))
            .animation(.easeInOut(duration: 0.5), value: true)
        let splashViewController = UIHostingController(rootView: splashScreen)
        window.rootViewController = splashViewController
        self.window = window
        window.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            window.rootViewController = UIHostingController(rootView: rootView)
        }
        
        return true
    }
    
    func isLoggedIn() -> Bool {
        if let token = UserDefaults.standard.string(forKey: "token") {
            // Check if the token exists
            return !token.isEmpty
        }
        return false
    }
}

