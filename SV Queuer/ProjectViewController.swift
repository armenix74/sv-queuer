import UIKit

class ProjectViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var project: Dictionary<String, AnyObject?>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
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
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addTask() {
        let vc = UIAlertController(title: "Task name", message: nil, preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            
            let request = Api.addTask(projectId: self.project!["id"]! as! Int, taskName: vc.textFields![0].text!)
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                DispatchQueue.main.async{
                    if let error = optError
                    {
                        UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                    }
                    let request = Api.getProjects(projectId: self.project!["id"]! as? Int)
                    self.handleGetProject(request)
                }
            }).resume()
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
        if let count = project!["tasks"]??.count {
            return count
        }
        else
        {
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
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
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
    
    func handleDeleteTask(_ request: URLRequest){
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError
                {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                }
                else{
                    let projectRequest = Api.getProjects(projectId: self.project!["id"]! as? Int)
                    self.handleGetProject(projectRequest)
                    UIAlertView(title: "Result", message: "The task has been deleted.", delegate: nil, cancelButtonTitle: ":)").show()
                    self.tableView.reloadData()
                }
            }
        }).resume()
    }
    
}
