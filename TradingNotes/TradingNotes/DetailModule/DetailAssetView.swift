//
//  DetailAsset.swift
//  TradingNotes
//
//  Created by Elvin Sestomi on 08/09/24.
//

import SwiftUI

struct DetailAssetView: View {
    @ObservedObject var viewModel : DetailViewModel
    @Environment(\.colorScheme) var colorScheme
    
    fileprivate init(viewModel : DetailViewModel) {
        self.viewModel = viewModel
    }
    
    let dateFormatter : DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd MMM, yyyy"
        return f
    }()
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.stocks.indices, id: \.self) {index in
                    HStack {
                        Text("\(dateFormatter.string(from: viewModel.stocks[index].stock.dateBought))")
                            .foregroundStyle(viewModel.stocks[index].stock.isSold ? .red : colorScheme == .dark ? .white : .black)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Spacer()
                            Text(String(format: "%.12f", viewModel.stocks[index].stock.StockQuantity))
                                
                            Spacer()
                            Text(String(format: "%.7f", viewModel.stocks[index].stock.StockPrice))
                            Spacer()
                        }
                    }
                    .padding()
                    .background(viewModel.stocks[index].isSelected ? .green : colorScheme == .dark ? .black : .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        DispatchQueue.main.async {
                            viewModel.stocks[index].isSelected.toggle()
                            viewModel.calculateSelectedData()
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack {
                HStack {
                    Text("Total Asset")
                        .font(.title2)
                    Spacer()
                    Text(String(format: "%.12f", viewModel.totalAssetInHand))
                        .font(.title2)
                }.padding(.bottom, 16)
                
                HStack {
                    Text("Total Asset Price")
                        .font(.title2)
                    Spacer()
                    Text(String(format: "%.5f", viewModel.totalPriceInHand))
                        .font(.title2)
                }.padding(.bottom, 16)
                
                HStack {
                    Text("Avg each Stock : ")
                        .font(.title2)
                    Spacer()
                    Text(String(format: "%.3f", viewModel.avgPrice))
                        .font(.title2)
                }
            }.padding()
            
            HStack {
                Button {
                    viewModel.addToCopyClipBoard(content: String(viewModel.totalAssetInHand))
                } label: {
                    Text("Trade")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .padding(.horizontal, 16)
                        .background(.green)
                        .clipShape(.capsule(style: .circular))
                        
                }
                
                Button {
                    viewModel.updateSoldStatus()
                    
                } label: {
                    Text("Sell")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .padding(.horizontal, 16)
                        .background(.red)
                        .clipShape(.capsule(style: .circular))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.stocks.indices.forEach { index in
                        viewModel.stocks[index].isSelected = !viewModel.isselectAllFlag
                    }
                    viewModel.isselectAllFlag.toggle()
                    viewModel.calculateSelectedData()
                } label: {
                    Text(viewModel.isselectAllFlag ? "Unselect all" : "Select all")
                }
            }
        }
    }
}

class DetailAssetViewCoordinator {
    // Handle Navigation and others
    var navigationPath : NavigationPath
    
    init(navigationPath: NavigationPath) {
        self.navigationPath = navigationPath
    }
    
    func createModule(stocks : [Stock]) -> DetailAssetView {
        let viewModel : DetailViewModel = DetailViewModel.DetailViewModelFactory.createViewModel(stocks: stocks)
        let view : DetailAssetView = DetailAssetView(viewModel: viewModel)
        return view
    }
}
