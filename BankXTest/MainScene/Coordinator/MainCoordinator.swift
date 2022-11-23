//
//  MainCoordinator.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func goToBiography()
    func goToBestTracks()
}

class MainCoordinator: Coordinator {
    
    private let apiManager: APIManager
    
    private lazy var navigationController: UINavigationController = {
        let nc = UINavigationController()
        nc.navigationBar.isHidden = true
        return nc
    }()
    
    var rootViewController: UIViewController {
        navigationController
    }
    
    lazy var viewModel: MainViewModel = {
        let viewModel = MainViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    override func start() {
        let mainViewController = MainViewController()
        mainViewController.viewModel = viewModel
        navigationController.setViewControllers([mainViewController], animated: true)
    }

    override func finish() {}
    
    func childDidFinish(_ coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension MainCoordinator: MainCoordinatorProtocol {
    func goToBiography() {
        let biographyCoordinator = BiographyCoordinator(navigationController: navigationController, apiManager: apiManager)
        biographyCoordinator.parentCoordinator = self
        addChildCoordinator(biographyCoordinator)
        biographyCoordinator.start()
    }
    
    func goToBestTracks() {
        let bestTracksCoordinator = BestTracksCoordinator(navigationController: navigationController, apiManager: apiManager)
        bestTracksCoordinator.parentCoordinator = self
        addChildCoordinator(bestTracksCoordinator)
        bestTracksCoordinator.start()
    }
}
