import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let router = Router(navigationController: UINavigationController(), moduleBuilder: ModuleBuilder())
        router.setInitialViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

