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
            rootView = AnyView(MapBox())
        } else {
            rootView = AnyView(LoginPage())
        }
        
        // Use the SwiftUI view as the root view controller
        if #available(iOS 14.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                let splashScreen = Splashscreen() // Replace with your actual splash screen view
                let splashViewController = UIHostingController(rootView: splashScreen)
                window.rootViewController = splashViewController
                self.window = window
                window.makeKeyAndVisible()

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    // After a delay of 3 seconds (or any desired duration), switch to the appropriate root view
                    window.rootViewController = UIHostingController(rootView: rootView)
                }
            }
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            let splashScreen = Splashscreen() // Replace with your actual splash screen view
            let splashViewController = UIHostingController(rootView: splashScreen)
            window.rootViewController = splashViewController
            self.window = window
            window.makeKeyAndVisible()

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // After a delay of 3 seconds (or any desired duration), switch to the appropriate root view
                window.rootViewController = UIHostingController(rootView: rootView)
            }
        }
        
        return true
    }
    
    func isLoggedIn() -> Bool {
        
//        if let token = UserDefaults.standard.string(forKey: "token") {
//
//            // Check if the token exists
//            return !token.isEmpty
//        }
        return false
    }
}

