import UIKit

class LoginViewController: UIViewController {
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func loginpressed(_ sender: Any) {
    var request = Utils.prepareURLRequest(AppDelegate.SESSION_URL)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["username": usernameField.text, "password": passwordField.text], options: .prettyPrinted)
    
    URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
      DispatchQueue.main.async {
        if let error = optError {
          let alert = Utils.prepareUIAlert(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?")
          self.present(alert, animated: true){}
        }
        if ((response as? HTTPURLResponse)?.statusCode) != nil {
          if let jsonData = data {
            do {
              let dict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
              UserDefaults.standard.set(dict?["api_key"], forKey: "apiKey")
              self.performSegue(withIdentifier: "projects", sender: self)
            } catch let jsonError as NSError {
              print("error", jsonError)
            }
          }
        }
      }
    }).resume()
  }
}
