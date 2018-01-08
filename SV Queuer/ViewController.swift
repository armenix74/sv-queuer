import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "apiKey") != nil {
            print (UserDefaults.standard.string(forKey: "apiKey"))
            performSegue(withIdentifier: "projects", sender: self)
        } else {
            performSegue(withIdentifier: "login", sender: self)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

