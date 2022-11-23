//
//  AppCoordinator.swift
//  BankXTest
//
//  Created by Дмитрий Садырев on 23.11.2022.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow?
    
    let apiManager = APIManager()
    
    init(window: UIWindow?) {
        self.window = window
    }

    override func start() {
        guard let window = window else {
            return
        }
        let mainCoordinator = MainCoordinator(apiManager: apiManager)
        mainCoordinator.start()
        addChildCoordinator(mainCoordinator)
        window.rootViewController = mainCoordinator.rootViewController
        window.makeKeyAndVisible()
    }

    override func finish() {

    }
}
