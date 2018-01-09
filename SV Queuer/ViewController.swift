import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(nil, forKey: "apiKey")
        if UserDefaults.standard.string(forKey: "apiKey") != nil {
            performSegue(withIdentifier: "projects", sender: self)
        } else {
            performSegue(withIdentifier: "login", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

