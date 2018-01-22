//
//  Utilis.swift
//  SV Queuer
//
//  Created by sergio armenia on 22/01/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation

 class Utils {
  
  static func prepareURLRequest(_ currenURL: String) -> URLRequest {
    var request = URLRequest(url: URL(string: currenURL)!)
    request.addValue(AppDelegate.HEADER_CONTENT_TYPE, forHTTPHeaderField: "Content-type")
    request.addValue(AppDelegate.HEADER_ACCEPT, forHTTPHeaderField: "Accept")
    request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
    
    return request
  }
}

