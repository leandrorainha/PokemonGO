//
//  PokemonAnotacao.swift
//  PokemonGO
//
//  Created by LEANDRO RAINHA on 24/02/23.
//

import UIKit
import MapKit

class PokemonAnotacao: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
    
}
