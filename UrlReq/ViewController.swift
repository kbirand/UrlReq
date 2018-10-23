//
//  ViewController.swift
//  UrlReq
//
//  Created by Koray Birand on 22.10.2018.
//  Copyright © 2018 Koray Birand. All rights reserved.
//

import Cocoa
import CryptoSwift

class ViewController: NSViewController {
    
    
    let mainURL = "http://scouthy-test.com:8888/" + "admin/"
    let iv = "gqLOHUioQ0QjhuvI"
    let key = "koraybirand12711"
    
    var koko = [[String:String]]() {
        didSet {
            //print(self.koko)
        }
    }
    
    
    @IBAction func button(_ sender: NSButton) {
        startConnection(ps: "submit=1", file: "fillImages.php") { (json) in
            self.koko = json

            
            
            let mainURL = "http://scouthy-test.com:8888/" + "admin/"
            let url = URL(fileURLWithPath: mainURL).appendingPathComponent("test.php")
            let passData = try! "HADIBAKALIMKOCUM".aesEncrypt(key: self.key, iv: self.iv)
            var request : URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            print(passData)
            
            request.httpBody = passData.data(using: String.Encoding.utf8)

            let dataTask = URLSession.shared.dataTask(with: request)
            dataTask.resume()
            
        }
        
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func encryptionBase64(toEncode: String) -> String {
        let encodedData = (toEncode as NSString).data(using: String.Encoding.utf8.rawValue)
        let encodedString = encodedData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: Data.Base64EncodingOptions.RawValue(0)))
        return encodedString!
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

extension String{
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try! AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)!
        let decrypted = try! AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
        
    }
}


