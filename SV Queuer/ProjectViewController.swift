import UIKit

class ProjectViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
  
  var project: Dictionary<String, AnyObject?>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let red = CGFloat((0x31e1a3 & 0xFF0000) >> 16)/256.0
    let green = CGFloat((0x31e1a3 & 0xFF00) >> 8)/256.0
    let blue = CGFloat(0x31e1a3 & 0xFF)/256.0
    tableView.dataSource = self
    tableView.delegate = self
    title = "Tasks"
    navigationController?.navigationBar.barTintColor = UIColor(red:red, green:green, blue:blue, alpha:1.0)
    let url = AppDelegate.PROJECTS_URL + "/" + String(self.project!["id"]! as! Int)
    let request = Utils.prepareURLRequest(url)
    
    URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
      DispatchQueue.main.async {
        if let error = optError {
          let alert = Utils.prepareUIAlert(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?")
          self.present(alert, animated: true){}
        }
        if let jsonData = data {
          self.project = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String, AnyObject?>
          self.tableView.reloadData()
        }
      }
    }).resume()
    navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ProjectViewController.addTask))
  }
  
  @IBOutlet weak var tableView: UITableView!
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc func addTask() {
    let vc = UIAlertController(title: "Task name", message: nil, preferredStyle: .alert)
    
    vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
      vc.dismiss(animated: true, completion: nil)
      
      let url = AppDelegate.PROJECTS_URL + "/" + String(self.project!["id"]! as! Int) + "/tasks"
      var request = Utils.prepareURLRequest(url)
      request.httpBody = try? JSONSerialization.data(withJSONObject: ["task" : ["name": vc.textFields![0].text as AnyObject]], options: .prettyPrinted)
      request.httpMethod = "POST"
      
      URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
        DispatchQueue.main.async {
          if let error = optError {
            let alert = Utils.prepareUIAlert(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?")
            self.present(alert, animated: true){}
          }
          
          let url = AppDelegate.PROJECTS_URL + "/" + String(self.project!["id"]! as! Int)
          let request = Utils.prepareURLRequest(url)
          
          URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async {
              if let error = optError {
                let alert = Utils.prepareUIAlert(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?")
                self.present(alert, animated: true){}
              }
              if let jsonData = data {
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                self.project = json as? Dictionary<String, AnyObject?>
                self.tableView.reloadData()
              }
            }
          }).resume()
        }
      }).resume()
    }))
    
    vc.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
      vc.dismiss(animated: true, completion: nil)
    }))
    vc.addTextField { (textfield) in
      textfield.placeholder = "Name"
    }
    
    present(vc, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let c = tableView.dequeueReusableCell(withIdentifier: "task")
    c?.textLabel?.text = ((project!["tasks"])! as! Array<Dictionary<String, AnyObject?>>)[indexPath.row]["name"]! as? String
    return c!
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = project!["tasks"]??.count {
      return count
    } else {
      return 0
    }
  }
}
