//
//  BestTracksModel.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 17.11.2022.
//

import Foundation

// MARK: - BestTracksModel
struct BestTracksModel: Codable {
    let bestTracks: BestTracks
    
    enum CodingKeys: String, CodingKey {
        case bestTracks = "toptracks"
    }
    
    // MARK: - BestTracks
    struct BestTracks: Codable {
        let track: [Track]
        
        // MARK: - Track
        struct Track: Codable {
            let name: String?
            let artist: Artist
            let image: [TrackImage]
            
            // MARK: - TrackImage
            struct TrackImage: Codable {
                let urlString: String?

                enum CodingKeys: String, CodingKey {
                    case urlString = "#text"
                }
            }
            
            // MARK: - ArtistClass
            struct Artist: Codable {
                let name: String?
            }
        }
    }
}










