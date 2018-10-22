//
//  ViewController.swift
//  UrlReq
//
//  Created by Koray Birand on 22.10.2018.
//  Copyright © 2018 Koray Birand. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    let mainURL = "http://scouthy-test.com:8888/" + "admin/"
    
    
    var koko = [[String:String]]() {
        didSet {
            //print(self.koko)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startConnection(ps: "submit=1", file: "fillImages.php") { (json) in
            self.koko = json
            let mainURL = "http://scouthy-test.com:8888/" + "admin/"
            let url = URL(fileURLWithPath: mainURL).appendingPathComponent("test.php")
            var request : URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            let jsonDATA = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        
            request.httpBody = jsonDATA
        
            let dataTask = URLSession.shared.dataTask(with: request)
            dataTask.resume()
            
        }
       
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func foo()
{
    
    }
    
    func startConnection(ps: String, file: String, completion: @escaping ([[String:String]]) -> Void) {
        let mainURL = "http://scouthy-test.com:8888/" + "admin/"
        let url = URL(fileURLWithPath: mainURL).appendingPathComponent(file)
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = ps
        request.httpBody = postString.data(using: .utf8)
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                    self.koko = jsonResult as! [[String:String]]
              
                    //Use GCD to invoke the completion handler on the main thread
                    DispatchQueue.main.async() {
                        completion(jsonResult as! [[String:String]])
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    
}

