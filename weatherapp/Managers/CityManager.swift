//
//  CityManager.swift
//  weatherapp
//
//  Created by Dio Rovelino on 28/06/23.
//

import Foundation


class CityManager {
    func fetchCityByJawaBarat() async throws -> [CityModelElement] {
        guard let url = URL(string:"https://www.emsifa.com/api-wilayah-indonesia/api/regencies/32.json") else {
            fatalError("Cannot Connect URL")
        }
        let urlRequest = URLRequest(url: url)
        
        let (data,response) = try await URLSession.shared.data(for:urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Something went wrong")
        }
        
        let decodedData = try JSONDecoder().decode([CityModelElement].self, from:data)
        return decodedData
    }
}


struct CityModelElement: Codable {
    let id, provinceID, name: String

    enum CodingKeys: String, CodingKey {
        case id
        case provinceID = "province_id"
        case name
    }
}
