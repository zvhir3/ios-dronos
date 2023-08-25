import UIKit
import SwiftUI

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ProductCommunicationService.shared.registerWithProduct()
        
        let rootView: AnyView
        
        if UserDefaults.standard.object(forKey: "token") == nil {
            rootView = AnyView(
                LoginPage()
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.5), value: true)
            )
        } else {
            rootView = AnyView(
                BottomNavigation()
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
}
