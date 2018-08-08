//
//  VkLoginViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 27/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import WebKit

class VkLoginViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
    }
    
    func getToken() {
        
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "oauth.vk.com"
            urlComponents.path = "/authorize"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: "6644391"),
                URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "scope", value: "270342"), // friends, photos, groups, wall
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: "5.80")
            ]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }

}

extension VkLoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment.components(separatedBy: "&").map { $0.components(separatedBy: "=") }.reduce([String : String]()) { (result, param) in
            
            var dict = result
            let key = param[0]
            let value = param[1]
            dict[key] = value
            return dict
        }
        
        print(params["access_token"])
        VKService.shared.setup(token: params["access_token"] ?? "", user_id: params["user_id"] ?? "")
        decisionHandler(.cancel)
        performSegue(withIdentifier: "Vklogin", sender: self)
    }
    
}















