//
//  LoginViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 19/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let login = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let output =  (login == "admin" && password == "admin") ? true : false
        
        // Information for user about incorrect login or password
        if !output {
            let alert = UIAlertController(title: "Ошибка", message: "Неверные данные.", preferredStyle: .alert)
            let buttonAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
            
            alert.addAction(buttonAction)
            present(alert, animated: true, completion: nil)
            
            // resetting data fields
            usernameTextField.text = ""
            passwordTextField.text = ""
        }
        
        return output
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let info = notification.userInfo as NSDictionary?, let value = info.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue else { return }
        
        let height = value.cgRectValue.size.height
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        print("Username - \(usernameTextField.text ?? "")")
        print("Password - \(passwordTextField.text ?? "")")
    }

    @IBAction func viewTapped(_ sender: Any) {
        view.endEditing(true)
    }
}
