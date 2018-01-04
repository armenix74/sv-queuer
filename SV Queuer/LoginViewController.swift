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
        let request = Api.login(username: usernameField.text!, password: passwordField.text!)
        handleLogin(request)
    }
    
    func handleLogin(_ request: URLRequest){
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                }
                if ((response as? HTTPURLResponse)?.statusCode) != nil {
                    if let jsonData = data {
                        do {
                            let dict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
                            if let loginError = dict?["errors"]{
                                UIAlertView(title: "Error", message: String(describing: loginError), delegate: nil, cancelButtonTitle: ":(").show()
                            }
                            else{
                                UserDefaults.standard.set(dict?["api_key"], forKey: "apiKey")
                                self.performSegue(withIdentifier: "projects", sender: self)
                            }
                        }catch let jsonError as NSError {
                            
                        }
                    }else{
                    }
                }
            }
        }).resume()
    }
}
