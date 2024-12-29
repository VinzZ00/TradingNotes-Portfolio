//
//  BaseViewController.swift
//  CoreCommon
//
//  Created by Elvin Sestomi on 18/08/24.
//

import UIKit

class BaseViewController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
