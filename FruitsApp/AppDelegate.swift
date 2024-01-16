//
//  AppDelegate.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import UIKit

private let ManualCloseKey = "ManualClose"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow()
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.setValue(true, forKey: ManualCloseKey)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Just some very basic crash reporting, if the app wasnt manually closed we report as a crash
        if let current = UserDefaults.standard.value(forKey: ManualCloseKey) as? Bool {
            if !current {
                Task {
                    try? await NetworkClient.shared.recordUsage(event: "error", data: "Previously crashed")
                }
            } else {
                UserDefaults.standard.setValue(false, forKey: ManualCloseKey)
            }
        } else {
            UserDefaults.standard.setValue(false, forKey: ManualCloseKey)
        }
        let viewModel = FruitsViewModel()
        let viewController = FruitsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}

