import Foundation
import UIKit


class HttpRequest {
    
    enum HttpMethod : String{
        case POST
        case GET
    }
    
    static func makeRequest(url: String, httpMethod: HttpMethod, httpBody: Any?)-> URLRequest{
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = httpMethod.rawValue
        if let b = httpBody {
            request.httpBody = try? JSONSerialization.data(withJSONObject: b, options: .prettyPrinted)
        }
        if let userKey = UserDefaults.standard.string(forKey: "apiKey") {
            request.addValue(userKey, forHTTPHeaderField: "X-Qer-Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func getAlertConnection(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: ":(", style: .cancel, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
}
