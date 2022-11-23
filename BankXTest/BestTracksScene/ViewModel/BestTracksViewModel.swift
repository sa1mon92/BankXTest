//
//  BestTracksViewModel.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import Foundation
import Combine

class BestTracksViewModel {
    private let apiManager: APIManager
    
    private weak var coordinator: BestTracksCoordinatorProtocol?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var artistName: String = ""
    @Published var bestTracks: BestTracksModel?
    
    private var randomTracks = [BestTracksModel.BestTracks.Track]()
    
    init(apiManager: APIManager, coordinator: BestTracksCoordinatorProtocol? = nil) {
        self.apiManager = apiManager
        self.coordinator = coordinator
        subscribeArtist()
    }
    
    private func subscribeArtist() {
        $artistName
            .dropFirst(1)
            .flatMap { (artist: String) -> AnyPublisher<BestTracksModel?, Never> in
                self.apiManager.fetchTopTracks(for: artist)
            }
            .assign(to: \.bestTracks, on: self)
            .store(in: &self.cancellableSet)
    }
    
    func getBestTracks(for artistName: String) {
        self.artistName = artistName.trimmingCharacters(in: .whitespaces)
        self.randomTracks = []
    }
    
    func getRandomTrackModel() -> BestTracksModel.BestTracks.Track? {
        guard let bestTracks = bestTracks else { return nil }
        var track: BestTracksModel.BestTracks.Track?
        repeat {
            track = bestTracks.bestTracks.track.randomElement()
        } while randomTracks.contains(where: { $0.name == track?.name })
        
        if let track = track {
            randomTracks.append(track)
            return track
        }
        return nil
    }
    
    func clear() {
        bestTracks = nil
    }
    
    func didFinish() {
        coordinator?.didFinish()
    }
}
