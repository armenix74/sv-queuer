import Foundation
import UIKit

class Api{
    static let BASE_URL = "https://queuer-production.herokuapp.com/api/v1/"
    static let PROJECTS_URL = BASE_URL + "projects"
    
    static func getBaseRequest(url: URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if UserDefaults.standard.string(forKey: "apiKey") != nil{
            request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
        }
        return request
    }
    
    static func login(username: String, password: String) -> URLRequest {
        let url = URL(string: BASE_URL + "session")!
        var request = getBaseRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["username": username, "password": password], options: .prettyPrinted)
        return request
    }
    
    static func getProjects(projectId: Int? = nil) -> URLRequest{
        let url : URL = (projectId != nil) ? URL(string: PROJECTS_URL + "/\(projectId!)")! : URL(string: PROJECTS_URL)!
        let request = getBaseRequest(url: url)
        return request
    }
    
    static func deleteProject(projectId: Int) -> URLRequest{
        let url : URL = URL(string: PROJECTS_URL + "/\(projectId)")!
        var request = getBaseRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }
    
    static func addProject(projectName: String)-> URLRequest{
        let url = URL(string: Api.PROJECTS_URL)!
        var request = getBaseRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["project" : ["name": projectName, "color": -13508189 as AnyObject]], options: .prettyPrinted)
        
        return request
    }
    
    static func addTask(projectId: Int, taskName: String)  -> URLRequest{
        let url = URL(string: PROJECTS_URL + "/" + String(projectId) + "/tasks")!
        var request = getBaseRequest(url: url)
        request.httpMethod="POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["task" : ["name": taskName]], options: .prettyPrinted)
        return request
    }
    
    static func deleteTask(projectId: Int, taskId: Int) -> URLRequest{
        let url : URL = URL(string: PROJECTS_URL + "/\(projectId)/tasks/\(taskId)")!
        var request = getBaseRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }
}
