//
//  ToDoCollectionViewController.swift
//  MultiTasksProject
//
//  Created by Shawn Li on 5/17/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//  Topics:
//  1. JSON Parsing
//  2. CollectionView
//  3. Customizing NavBar
//  4. Web-service comm
//  5. URLSession
//  6. dataTask
//  7. MVC
//  8. Multi-threading concepts
//  9. Dispatch Queues
import UIKit

class ToDoCollectionViewController: UICollectionViewController
{

    var todos = [ToDo]()
    
    @IBOutlet weak var turnToNextBtnOutlet: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getToDoDataSource()
        setupNavigationBarItem()
    }
    
    //MARK:- URLSession to get Data Source
    
    func getToDoDataSource()
    {
        //  4. Web-service comm
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
        //  5. URLSession   6. dataTask
        let session = URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            if let data = data
            {
                do
                {
                    // 1. JSON Parsing
                    self.todos = try JSONDecoder().decode([ToDo].self, from: data)
                    //  8. Multi-threading concepts 9. Dispatch Queues
                    DispatchQueue.main.async
                    {
                        self.collectionView.reloadData()
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }
        session.resume()
    }
    
    //MARK: - Collection View configuration
    //  2. CollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return todos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todo", for: indexPath) as! ToDoCollectionViewCell
        
        cell.titleTF.text = todos[indexPath.row].title
        cell.idLab.text = String(todos[indexPath.row].id)
        
        if todos[indexPath.row].completed
        {
            cell.contentView.backgroundColor = .systemTeal
        }
        else
        {
            cell.contentView.backgroundColor = .white
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        todos[indexPath.row].completed = !todos[indexPath.row].completed
        collectionView.reloadData()
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - Customize Navigation Bar
    // 3. Customize Navigation Bar
    func setupNavigationBarItem()
    {
        // Navigation Bar Tittle View Logo
        let logoImage = UIImageView(frame: CGRect(x:0, y:0, width: 34, height: 34))
        logoImage.contentMode = .scaleAspectFit
        let titleLogo = UIImage(named: "ironMan")
        logoImage.image = titleLogo
        self.navigationItem.titleView = logoImage
    }
}
