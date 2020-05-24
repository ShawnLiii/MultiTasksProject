//
//  BookCollectionViewController.swift
//  MultiTasksProject
//
//  Created by Shawn Li on 5/17/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//  1. Json Parsing
//  2. Bundle Management
//  3. Types of Parser
//  4. CollectionView
//  5. FileManager
import UIKit

class PokemonCollectionViewController: UICollectionViewController
{
    let reuseIdentifier = "pokemon"
    var pokemons = [Pokemon]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchDataSource()
        setupNavigationBarItem()
    }
    
    // MARK: - Json Parsing/Bundle Management/Types of Parser/FileManager
    
    func fetchDataSource()
    {
        if let filePath = Bundle.main.path(forResource: "pokedex", ofType: "json")
        {
            if let data = FileManager.default.contents(atPath: filePath)
            {
                do
                {
                    pokemons = try JSONDecoder().decode([Pokemon].self, from: data)
                }
                catch
                {
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Collection View Configuration
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pokemons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokemonCollectionViewCell
        let pokemon = pokemons[indexPath.row]
        
        cell.pokemonId.text = String(pokemon.id)
        cell.pokemonName.text = pokemon.name["english"]
        
        var types = String()
        
        for type in pokemon.type
        {
            types += type + " "
        }
        
        cell.pokemonType.text = types
        cell.pokemonImage.image = UIImage(named: String(format: "%03d", indexPath.row + 1))
        
        return cell
    }
    
    // MARK: - Customize Navigation Bar
 
    func setupNavigationBarItem()
    {
        // Navigation Bar Tittle View Logo
        // Create a navView to add to the navigation bar
        let navView = UIView()
        // Create a label
        let label = UILabel()
        label.text = " Pokemon Dex"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        // Create the image view
        let image = UIImageView()
        image.image = UIImage(named: "masterBall")
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x - label.frame.size.height * imageAspect, y: label.frame.origin.y, width: label.frame.size.height * imageAspect, height: label.frame.size.height)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(image)
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
        
        // left back button
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
