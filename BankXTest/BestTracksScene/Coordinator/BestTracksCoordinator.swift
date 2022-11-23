//
//  BestTracksCoordinator.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit

protocol BestTracksCoordinatorProtocol: AnyObject {
    func didFinish()
}

class BestTracksCoordinator: Coordinator {
    private let apiManager: APIManager
    private let navigationController: UINavigationController
    
    var parentCoordinator: MainCoordinator?
    
    private lazy var viewModel: BestTracksViewModel = BestTracksViewModel(apiManager: apiManager, coordinator: self)
    
    init(navigationController: UINavigationController, apiManager: APIManager) {
        self.navigationController = navigationController
        self.apiManager = apiManager
    }
    
    override func start() {
        let bestTracksViewController = BestTracksViewController()
        bestTracksViewController.title = "Лучшие треки"
        bestTracksViewController.viewModel = viewModel
        navigationController.pushViewController(bestTracksViewController, animated: true)
    }

    override func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}

extension BestTracksCoordinator: BestTracksCoordinatorProtocol {
    func didFinish() {
        finish()
    }
}
