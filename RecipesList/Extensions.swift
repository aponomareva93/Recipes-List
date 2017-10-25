//
//  Extensions.swift
//  RecipesList
//
//  Created by anna on 25.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(withTitle title: String, message: String, okButtonTapped: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      okButtonTapped?()
    }
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
}
