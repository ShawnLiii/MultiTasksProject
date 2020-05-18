//
//  XMLLetterViewController.swift
//  MultiTasksProject
//
//  Created by Shawn Li on 5/17/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//  1. XML Parser

import UIKit

class XMLLetterViewController: UIViewController, XMLParserDelegate
{

    
    @IBOutlet weak var displayTV: UITextView!
    
    var letter: Letter?
    var output = String()
    var elementName = String()
    var letterTitle = [String]()
    var salutation = String()
    var text = [String]()
    var greetings = String()
    var signature = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupNavigationBarItem()
    }
    
    @IBAction func readFileBtnTapped(_ sender: UIButton)
    {
        readXMLFile()
        displayResult()
    }
    
    func readXMLFile()
    {
        if let path = Bundle.main.url(forResource: "Letter", withExtension: "xml")
        {
            if let parser = XMLParser(contentsOf: path)
            {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        if elementName == "letter"
        {
            output = String()
            letterTitle = [String]()
            salutation = String()
            text = [String]()
            greetings = String()
            signature = String()
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "letter"
        {
            let aLetter = Letter(title: letterTitle, salutation: salutation, text: text, greetings: greetings, signature: signature)
           letter = aLetter
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !data.isEmpty
        {
            switch elementName
            {
                case "title":
                    letterTitle.append(data)
                case "salutation":
                    salutation = data
                case "text":
                    text.append(data)
                case "greetings":
                    greetings = data
                case "signature":
                    signature = data
                default:
                    output = String()
            }
        }
    }
    
    //MARK: - Display Result
    func displayResult()
    {
        if let letterContent = letter
        {
            output = "\(letterContent.title[0])\n" + "\n\(letterContent.salutation)\n" + "\n\(letterContent.text[0])\n" + "\n\(letterContent.title[1])\n" + "\n\(letterContent.text[1])\n" + "\n\(letterContent.greetings)\n" + "\n\(letterContent.signature)"
        }
        
        displayTV.text = output
    }
    
    //MARK: - Navigation Bar
    func setupNavigationBarItem()
    {
       // Navigation Bar Tittle View Logo
        let logoImage = UIImageView(frame: CGRect(x:0, y:0, width: 34, height: 34))
        logoImage.contentMode = .scaleAspectFit
        let titleLogo = UIImage(named: "wukong")
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
