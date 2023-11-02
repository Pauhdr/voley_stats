//
//  Descriptable.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 1/11/23.
//

import SwiftUI

protocol Descriptable : Identifiable{
    var description : String {
        get
    }
    var id: Int {
        get
    }
}
