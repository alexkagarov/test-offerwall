//
//  MainViewController.swift
//  test-offerwall
//
//  Created by Alex Kagarov on 6/10/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    private var allow: Bool?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(defaults.integer(forKey: "ResponseState"))
        
        if (defaults.integer(forKey: "ResponseState") == 0 ) {
            getResponseFromServer()
            UIView.animate(withDuration: 2.0) {
                self.progressView.setProgress(1.0, animated: true)
            }
            self.progressLabel.text = "User status set. Proceeding..."
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.getResponse()
            }
        } else if (defaults.integer(forKey: "ResponseState") == 200 ) {
            allow = true
            self.getResponse()
        } else if (defaults.integer(forKey: "ResponseState") == -200 ) {
            allow = false
            self.getResponse()
        }
    }
    
    func getResponseFromServer() {
        let requestURLString = "http://127.0.0.1:8088/"
        guard let requestURL = URL(string: requestURLString) else {return}
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let jsonResponse = try JSONDecoder().decode(Response.self, from: data)
                print("JSON response is \(jsonResponse.allow)")
                
                DispatchQueue.main.async {
                    self.allow = jsonResponse.allow
                    print("response set randomly from server. response is \(self.allow)")
                    self.saveResponseState()
                }
            } catch let jsonError {
                print("error decoding JSON: \(jsonError)")
            }
        }.resume()
    }
    
    func saveResponseState() {
        if let responseState = allow {
            if responseState {
                defaults.set(200, forKey: "ResponseState")
                print("Response State is saved and set to 200 \(responseState)")
            } else if !responseState {
                defaults.set(-200, forKey: "ResponseState")
                print("Response State is saved and set to -200 \(responseState)")
            }
            print("response added to userdefaults. value: \(defaults.integer(forKey: "ResponseState")) response is \(responseState)")
        }
    }
    
    func getResponse() {
        if let state = allow {
            if state {
                performSegue(withIdentifier: "allowTrueSegue", sender: nil)
                print("response is \(state). moving to webview")
            } else {
                performSegue(withIdentifier: "allowFalseSegue", sender: nil)
                print("response is \(state). moving to game")
            }
        } else {
            print("state is nil somehow :(")
        }
    }
}
