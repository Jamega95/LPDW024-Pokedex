//
//  ApiModel.swift
//  Pokedex
//
//  Created by AMGEGA Jérémie on 08/02/2024.
//

import SwiftUI

@Observable
class ApiModel {
    
    struct Root: Codable {
        let results: [PokemonLink]
    }

    static let shared = ApiModel()
    var pokemonLinks = [PokemonLink]()
    
    init(gettingPokemonLinks: Bool = true) {
        if gettingPokemonLinks { getPokemonLinks() }
    }
    
    func getPokemonLinks() {
        Task {
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon") else {
                print("Error with URL")
                return
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Error with request")
                return
            }
            
            let root = try JSONDecoder().decode(Root.self, from: data)
            self.pokemonLinks = root.results
        }
    }
}
