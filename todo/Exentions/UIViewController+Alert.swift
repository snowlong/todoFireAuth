//
//  UIViewController+Alert.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/29.
//  Copyright © 2019 Jun Takahashi. All rights reserved.
//

import UIKit

extension UIViewController {
    func singleAlert(title: String, message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
