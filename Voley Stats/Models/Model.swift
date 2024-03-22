//
//  Model.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 7/3/24.
//

import SwiftUI

class Model{
    var id:Int
    func toJSON()->Dictionary<String, Any>{
        return [:]
    }
    init(id: Int){
        self.id = id
    }
}
