//
//  StockTableViewCell.swift
//  Home
//
//  Created by Elvin Sestomi on 18/08/24.
//

import UIKit
import Stevia

class StockTableViewCell: UITableViewCell {

    var nameLabel : UILabel = UILabel()
    var stockPriceCurrent : UILabel = UILabel()
    var stockPriceBoughtAvg : UILabel = UILabel()
    var stockVolumeBoughtTotal : UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViewHierarchy()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewHierarchy() {
        subviews {
            nameLabel
            stockPriceCurrent
            stockPriceBoughtAvg
            stockVolumeBoughtTotal
        }
    }
    
    private func setupLayout() {
            self.top(0).right(0).left(0).bottom(0).height(100%).width(100%)
            
            self.nameLabel.Leading == self.safeAreaLayoutGuide.Leading + 16
            self.nameLabel.CenterY == self.CenterY
            
            self.stockPriceCurrent.CenterX == self.CenterX
            self.stockPriceCurrent.CenterY == self.CenterY
            
            self.stockPriceBoughtAvg.Top == self.Top
            self.stockPriceBoughtAvg.Bottom == self.CenterY
            self.stockPriceBoughtAvg.Trailing == self.Trailing - 16
            
            self.stockVolumeBoughtTotal.Trailing == self.stockPriceBoughtAvg.Trailing
            self.stockVolumeBoughtTotal.Top == self.CenterY
            self.stockVolumeBoughtTotal.Bottom == self.Bottom
    }
    
    private func setupStyle() {
        self.stockPriceBoughtAvg.style { l in
            l.textAlignment = .right
        }
        
        self.stockVolumeBoughtTotal.style { l in
            l.textAlignment = .right
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(true, animated: true) // The selected Things will only be handle in the UITableDelegate, this is done to prevent the user from selecting it
    }

}
