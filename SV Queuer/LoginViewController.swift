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
        
        let request = HttpRequest.makeRequest(url: AppDelegate.SESSION_URL, httpMethod: HttpRequest.HttpMethod.POST, httpBody: ["username": usernameField.text, "password": passwordField.text])
        
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError {
                    let alertController = HttpRequest.getAlertConnection(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?")
                    self.present(alertController, animated: true, completion: nil)
                }
                if ((response as? HTTPURLResponse)?.statusCode) != nil {
                    if let jsonData = data {
                        do {
                            let dict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
                            UserDefaults.standard.set(dict?["api_key"], forKey: "apiKey")
                            self.performSegue(withIdentifier: "projects", sender: self)
                        }catch _ as NSError {
                            
                        }
                    } else {
                    }
                }
            }
        }).resume()
    }

    
}

