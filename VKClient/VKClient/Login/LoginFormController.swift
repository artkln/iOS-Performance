//
//  LoginFormController.swift
//  VK Client
//
//  Created by Артём Калинин on 28.02.2021.
//

import UIKit
import WebKit
import Alamofire

class LoginFormController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7829028"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                            var dict = result
                            let key = param[0]
                            let value = param[1]
                            dict[key] = value
                            return dict
            }
        
        guard let token = params["access_token"],
              let userId = params["user_id"] else {
            decisionHandler(.allow)
            return
        }
        
        UserSession.shared.token = String(describing: token)
        UserSession.shared.userId = Int(userId)!
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    @IBAction func backToLogin(unwindSegue: UIStoryboardSegue) {
        
    }
}
