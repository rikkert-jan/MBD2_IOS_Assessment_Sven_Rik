//
//  Pokemon.swift
//  MBD2_Asessment_Sven_Rik
//
//  Created by Uitleen on 07/04/16.
//  Copyright © 2016 Sven Brettschneider & Rik van den Heuvel. All rights reserved.
//

import Foundation

class Pokemon {
    var id       :   Int!    = 0
    var name     :   String! = ""
    var sprite   :   String! = ""
    var height   :   Int!    = 0
    var weight   :   Int!    = 0
    var base_exp :   Int!    = 0
    
    init(name: String) {
        self.name   =   name
    }
    
    func updatePokemon(info: NSDictionary){
        self.id = info["id"] as! Int;
        self.height = info["height"] as! Int;
        self.weight = info["weight"] as! Int;
        self.base_exp = info["base_experience"] as! Int;
        self.sprite = info["sprites"]!["front_default"] as! String;
    }
}