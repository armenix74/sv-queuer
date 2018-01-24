//
//  Utilis.swift
//  SV Queuer
//
//  Created by sergio armenia on 22/01/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation
import UIKit

class Utils {
  
  static func prepareURLRequest(_ currenURL: String) -> URLRequest {
    var request = URLRequest(url: URL(string: currenURL)!)
    
    if let apiKey = UserDefaults.standard.string(forKey: "apiKey") {
      request.addValue(apiKey, forHTTPHeaderField: "X-Qer-Authorization")
    }
    request.addValue(AppDelegate.HEADER_CONTENT_TYPE, forHTTPHeaderField: "Content-type")
    request.addValue(AppDelegate.HEADER_ACCEPT, forHTTPHeaderField: "Accept")
    
    return request
  }
  
  static func prepareUIAlert(title: String, message: String, okButtonTitle: String? = nil, cancelButtonTitle: String = ":(") -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    if let okTitle = okButtonTitle {
      alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
      }))
    }
    alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action) in
      alertController.dismiss(animated: true, completion: nil)
    }))
    
    return alertController
  }
}
