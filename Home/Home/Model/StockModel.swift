//
//  StockModel.swift
//  Home
//
//  Created by Elvin Sestomi on 18/08/24.
//

import Foundation

struct StockModel : Identifiable, Hashable {
    var name : String
    var currentPrice : Double
    var priceBoughtAvg : Double
    var Volume : Double
    var id : String { name }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs : StockModel, rhs : StockModel) -> Bool {
        lhs.name == rhs.name
    }
}
