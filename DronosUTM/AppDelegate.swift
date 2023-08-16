import UIKit
import SwiftUI

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        ProductCommunicationService.shared.registerWithProduct()

        let rootView: AnyView
//        if isLoggedIn() {
//            rootView = AnyView(Launchpad())
//        } else {
            rootView = AnyView(
                LoginPage()
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.5), value: true)
            )
//        }
        
        
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
        
        UINavigationBar.appearance().barTintColor = .red
        
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
