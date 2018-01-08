import UIKit

class ProjectViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var project: Dictionary<String, AnyObject?>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request = Api.getProjects(projectId: self.project!["id"]! as? Int)
        self.handleGetProject(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        title = "Tasks"
        navigationController?.navigationBar.barTintColor = AppSettings.PROJECT_NAVBAR_COLOR
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func addTask() {
        let vc = UIAlertController(title: "Task name", message: nil, preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            
            let request = Api.addTask(projectId: self.project!["id"]! as! Int, taskName: vc.textFields![0].text!)
            self.handleAddTask(request)
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    /**  UITABLEVIEW HANDLERS  **/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "task")
        c?.textLabel?.text = ((project!["tasks"])! as! Array<Dictionary<String, AnyObject?>>)[indexPath.row]["name"]! as? String
        return c!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = project, let count = project!["tasks"]??.count {
            return count
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let selectedProjectId : Int = project!["id"] as! Int
            let selectedTask = ((project!["tasks"])! as! Array<Dictionary<String, AnyObject?>>)[indexPath.row]
            let selectedTaskId : Int = selectedTask["id"] as! Int
            let deleteRequest = Api.deleteTask(projectId: selectedProjectId, taskId: selectedTaskId)
            self.handleDeleteTask(deleteRequest)
        }
    }
    
    /** API HANDLERS **/
    func handleGetProject(_ request: URLRequest){
        self.project = nil
        self.tableView.reloadData()
        self.view.makeToastActivity(.center)
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                self.view.hideToastActivity()
                if let error = optError {
                    let message = error.localizedDescription + "\nMaybe check your internet?"
                    self.view.makeToast(message, duration: 3.0, position: .center)
                }
                if let jsonData = data {
                    self.project = nil
                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                    self.project = json as? Dictionary<String, AnyObject?>
                    self.tableView.reloadData()
                }else{
                    
                }
            }
        }).resume()
    }
    
    func handleAddTask(_ request: URLRequest){
        self.view.makeToastActivity(.center)
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                self.view.hideToastActivity()
                if let error = optError {
                    let message = error.localizedDescription + "\nMaybe check your internet?"
                    self.view.makeToast(message, duration: 3.0, position: .center)
                }
                let request = Api.getProjects(projectId: self.project!["id"]! as? Int)
                self.handleGetProject(request)
            }
        }).resume()
    }
    
    func handleDeleteTask(_ request: URLRequest){
        self.view.makeToastActivity(.center)
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                self.view.hideToastActivity()
                var message = ""
                if let error = optError {
                    message = error.localizedDescription + "\nMaybe check your internet?"
                }
                else{
                    let projectRequest = Api.getProjects(projectId: self.project!["id"]! as? Int)
                    self.handleGetProject(projectRequest)
                    message = "The task has been deleted."
                    self.tableView.reloadData()
                }
                self.view.makeToast(message, duration: 3.0, position: .center)
            }
        }).resume()
    }
    
}
