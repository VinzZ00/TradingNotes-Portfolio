//
//  Stock.swift
//  TradingNotes
//
//  Created by Elvin Sestomi on 01/09/24.
//

import Foundation
import FirebaseCore

public struct Stock : Hashable {
    public var identifier : String?
    public var StockName : String
    public var StockPrice : Double
    public var StockQuantity : Double
    public var dateBought : Date
    public var isSold : Bool = false
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(StockName)
    }
    
    public static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.StockName == rhs.StockName
    }
}

extension Stock {
    static public func toStock(data : [String : Any]) -> Stock {
        return Stock(
            StockName: data["StockName"] as! String,
            StockPrice: data["StockPrice"] as! Double,
            StockQuantity: data["StockQuantity"] as! Double,
            dateBought: (data["dateBought"] as! Timestamp).dateValue(),
            isSold: data["isSold"] as! Bool
        )
    }
}
