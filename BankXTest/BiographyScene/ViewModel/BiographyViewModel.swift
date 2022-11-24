//
//  BiographyViewModel.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit
import Combine

class BiographyViewModel: ObservableObject {
    private let apiManager: APIManager
    
    private weak var coordinator: BiographyCoordinatorProtocol?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var artistName: String = ""
    @Published var biography: BiographyModel? {
        didSet {
            notFoundHidden = biography == nil ? false : true
        }
    }
    @Published var notFoundHidden: Bool?
    
    init(apiManager: APIManager, coordinator: BiographyCoordinatorProtocol? = nil) {
        self.apiManager = apiManager
        self.coordinator = coordinator
        subscribeArtist()
    }
    
    private func subscribeArtist() {
        $artistName
            .dropFirst(1)
            .flatMap { (artist: String) -> AnyPublisher<BiographyModel?, Never> in
                self.apiManager.fetchBiography(for: artist)
            }
            .assign(to: \.biography, on: self)
            .store(in: &self.cancellableSet)
    }
    
    func getBiography(for artistName: String) {
        self.artistName = artistName.trimmingCharacters(in: .whitespaces)
    }
    
    func clear() {
        biography = nil
        notFoundHidden = true
    }
    
    func didFinish() {
        coordinator?.didFinish()
    }
}
