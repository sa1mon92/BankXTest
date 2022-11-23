//
//  MainViewModel.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit

protocol MainViewModelProtocol {
    func biographyButtonTapped()
    func bestTracksButtonTapped()
}

class MainViewModel: MainViewModelProtocol {
    weak var coordinator: MainCoordinatorProtocol?
    
    func biographyButtonTapped() {
        coordinator?.goToBiography()
    }
    
    func bestTracksButtonTapped() {
        coordinator?.goToBestTracks()
    }
}
