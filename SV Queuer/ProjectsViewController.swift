import UIKit

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var projects: Array<Dictionary<String, AnyObject?>>?
    var selProj: Dictionary<String, AnyObject?>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptProjCreate))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action:#selector(logout))
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request = Api.getProjects()
        self.handleGetProjects(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        title = "Projects"
        navigationController?.navigationBar.barTintColor = AppSettings.PROJECTS_NAVBAR_COLOR
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func promptProjCreate() {
        let vc = UIAlertController(title: "Project name", message: nil, preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            let request = Api.addProject(projectName: vc.textFields![0].text!)
            self.handleAddProject(request)
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func logout() {
        UserDefaults.standard.removeObject(forKey: "apiKey")
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier {
            case "viewproject":
                if let vC = segue.destination as? ProjectViewController {
                    vC.project = selProj;
                }
                break
            default:
                break
            }
        }
    }
    
    /**  UITABLEVIEW HANDLERS  **/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project")
        cell?.textLabel?.text = (projects![indexPath.row])["name"]! as? String
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = projects?.count {
            return count
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selProj = projects![indexPath.row];
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "viewproject", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let selectedProject = projects![indexPath.row];
            let selectedProjectId : Int = selectedProject["id"] as! Int
            let deleteRequest = Api.deleteProject(projectId: selectedProjectId)
            self.handleDeleteProject(deleteRequest)
        }
    }
    
    /** API HANDLERS **/
    func handleGetProjects(_ request: URLRequest){
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                }
                if let jsonData = data {
                    self.projects = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Array<Dictionary<String, AnyObject?>>
                    self.selProj = nil
                    self.tableView.reloadData()
                }else{
                    
                }
            }
        }).resume()
    }
    
    func handleAddProject(_ request: URLRequest){
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError
                {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                }
                let projectRequest = Api.getProjects()
                self.handleGetProjects(projectRequest)
            }
        }).resume()
    }
    
    func handleDeleteProject(_ request: URLRequest){
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError
                {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                }
                else{
                    let projectRequest = Api.getProjects()
                    self.handleGetProjects(projectRequest)
                    UIAlertView(title: "Result", message: "The project has been deleted.", delegate: nil, cancelButtonTitle: ":(").show()
                }
            }
        }).resume()
    }
}
