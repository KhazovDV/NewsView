//
//  SceneDelegate.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: windowScene)
            window?.makeKeyAndVisible()

            let rootViewController = NewsTableViewController()
            window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        }

}

