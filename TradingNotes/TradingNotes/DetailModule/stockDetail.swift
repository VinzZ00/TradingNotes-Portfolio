//
//  stockDetail.swift
//  TradingNotes
//
//  Created by Elvin Sestomi on 08/09/24.
//

import Foundation

struct StockDetail : Identifiable {
    var id : UUID = UUID()
    var stock : Stock
    var isSelected : Bool = false
}
