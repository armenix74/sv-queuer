import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if UserDefaults.standard.string(forKey: "apiKey") != nil {
      performSegue(withIdentifier: "projects", sender: self)
    }
    else {
      performSegue(withIdentifier: "login", sender: self)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

