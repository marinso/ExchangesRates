//
//  UIViewController+Extensions.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 12/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    
    func showProgressHUD() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
