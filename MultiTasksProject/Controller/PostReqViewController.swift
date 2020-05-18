//
//  PostReqViewController.swift
//  MultiTasksProject
//
//  Created by Shawn Li on 5/17/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//  1. URLRequest
//  2. Web-service comm
//  3. DataTask
import UIKit

class PostReqViewController: UIViewController, UITextFieldDelegate
{

    
    @IBOutlet weak var systemLogTV: UITextView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var output = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        textFieldSetup()
        setupNavigationBarItem()
    }
    
    // MARK: - URL Request Setting
    
    @IBAction func loginClicked(_ sender: UIButton)
    {
        if let userName = userNameTF.text, let password = passwordTF.text, !userName.isEmpty, !password.isEmpty
        {
            output.append("Login Request is sending.\n Waiting for Respond......\n")
            systemLogTV.text = output
            
            let parameter = ["User Name": userName, "Password": password]
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else { return }
            request.httpBody = httpBody
            
            let session = URLSession.shared.dataTask(with: request)
            { (data, response, error) in
                if let response = response
                {
                    print(response)
                }
                if let data = data
                {
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        DispatchQueue.main.async
                        {
                            self.output.append("\nLogin Sucessfully!\nYour Post request is\n\(json)\n")
                            self.systemLogTV.text = self.output
                        }
                        
                    }
                    catch
                    {
                        DispatchQueue.main.async
                        {
                            self.output.append("Login Failture!\nThe Post request is faild.\n The error is \(error)\n")
                            self.systemLogTV.text = self.output
                        }
                    }
                }
            }
            session.resume()
        }
        else
        {
            alert()
        }
    }
    // MARK: - Alert Setting
    func alert()
    {
        let alertCtrl = UIAlertController(title: "Attention!", message: "User Name or Password can't be empty", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alertCtrl.addAction(alertAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    //MARK: - Text Field Setting
    func textFieldSetup()
    {
        userNameTF.delegate = self
        passwordTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        return true
    }
    
    //MARK: - Clear Button Tapped
    @IBAction func clearTapped(_ sender: UIButton)
    {
        systemLogTV.text = nil
        output = String()
    }
    
    //MARK: - Navitation Bar
    
    func setupNavigationBarItem()
    {
       // Navigation Bar Tittle View Logo
        let logoImage = UIImageView(frame: CGRect(x:0, y:0, width: 34, height: 34))
        logoImage.contentMode = .scaleAspectFit
        let titleLogo = UIImage(named: "stich")
        logoImage.image = titleLogo
        self.navigationItem.titleView = logoImage
        
        // left Item
        let backBtn = UIButton(type: .custom)
        let backLogo = UIImage(named: "turnBack")
        backBtn.setImage(backLogo, for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    @objc func backAction()
    {
           navigationController?.popViewController(animated: true)
    }
}
