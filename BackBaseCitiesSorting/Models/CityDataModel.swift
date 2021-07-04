//
//  CityDataModel.swift
//  BackBaseCitiesSorting
//
//  Created by Shadab on 03/07/21.
//

import Foundation
import Foundation

// MARK: - UserCityDatum
struct CityData: Codable {
    let country, name: String
    let id: Int
    let coord: Coord

    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

typealias CityDataModel = [CityData]
