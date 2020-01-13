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
    
    func showError(with error :Error) {
        let errorText = error.localizedDescription.replacingOccurrences(of: "Status", with: "")
        let alert = UIAlertController(title: "Error", message: errorText.uppercased(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConnectionLost() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
