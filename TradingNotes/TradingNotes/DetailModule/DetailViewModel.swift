//
//  DetailViewModel.swift
//  TradingNotes
//
//  Created by Elvin Sestomi on 08/09/24.
//

import Foundation
import UIKit

class DetailViewModel : ObservableObject {
    
    class DetailViewModelFactory {
        static func createViewModel(stocks : [Stock]) -> DetailViewModel {
            let viewModel : DetailViewModel = DetailViewModel()
            viewModel.updateStocks(with: stocks)
            
            return viewModel
        }
    }
    
    private init() {}
    
    @Published var avgPrice : Double = 0
    @Published var totalPriceInHand : Double = 0
    @Published var totalAssetInHand : Double = 0
    @Published var stocks: [StockDetail] = []
    @Published var isselectAllFlag : Bool = false
    
    func updateStocks(with newStocks: [Stock]) {
        stocks = newStocks
            .map { stock in
                StockDetail(stock: stock)
            }
            .filter {
                !$0.stock.isSold
            }
    }
    
    func updateSoldStatus() {
        self.stocks.forEach{ stockDetail in
            if stockDetail.isSelected {
                guard
                    let docId = stockDetail.stock.identifier
                else { return}
                FireStoreManager.shared.updateData(collection: "Asset", documentId: docId, data: ["isSold" : true])
            }
        }
    }
    
    func addToCopyClipBoard(content : String) {
        UIPasteboard.general.string = content
    }
    
    func calculateSelectedData(){
        var totalPrice : Double = 0
        var totalAsset : Double = 0
        
        stocks.filter{
            $0.isSelected
        }.forEach { stock in
            totalAsset += stock.stock.StockQuantity
            totalPrice += stock.stock.StockPrice
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.totalPriceInHand = totalPrice
            self?.totalAssetInHand = totalAsset
            self?.avgPrice = totalPrice/totalAsset
        }
    }
}

