//
//  BiographyModel.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 17.11.2022.
//

import Foundation

// MARK: - BiographyModel
struct BiographyModel: Codable {
    let artist: Artist

    // MARK: - Artist
    struct Artist: Codable {
        let name: String?
        let image: [Image]
        let bio: Bio

        // MARK: - Bio
        struct Bio: Codable {
            let summary: String?
        }

        // MARK: - Image
        struct Image: Codable {
            let text: String?

            enum CodingKeys: String, CodingKey {
                case text = "#text"
            }
        }
    }
}
