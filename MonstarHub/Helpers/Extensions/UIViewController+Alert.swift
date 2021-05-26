//
//  UIViewController+Alert.swift
//  MonstarHub
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Monstarlab. All rights reserved.
//

import UIKit

extension UIViewController {

    public func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}
