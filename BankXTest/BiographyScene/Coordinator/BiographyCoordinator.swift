//
//  BiographyCoordinator.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit

protocol BiographyCoordinatorProtocol: AnyObject {
    func didFinish()
}

class BiographyCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let apiManager: APIManager
    
    var parentCoordinator: MainCoordinator?
    
    private lazy var viewModel: BiographyViewModel = BiographyViewModel(apiManager: apiManager, coordinator: self)
    
    init(navigationController: UINavigationController, apiManager: APIManager) {
        self.navigationController = navigationController
        self.apiManager = apiManager
    }
    
    override func start() {
        let biographyViewController = BiographyViewController()
        biographyViewController.title = "Биография"
        biographyViewController.viewModel = viewModel
        navigationController.pushViewController(biographyViewController, animated: true)
    }

    override func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}

extension BiographyCoordinator: BiographyCoordinatorProtocol {
    func didFinish() {
        finish()
    }
}
