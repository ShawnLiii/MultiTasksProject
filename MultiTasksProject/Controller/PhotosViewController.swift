//
//  ViewController.swift
//  MultiTasksProject
//
//  Created by Shawn Li on 5/16/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//  Topics:
//  1. Collectionview flow layout
//  2. CollectionView
//  3. DownloadTask
import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{

    var photos = [Item]()
    let reuseIdentifier = "Cell"
    
    @IBOutlet weak var collectionView: UICollectionView!
     
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCV()
        setupDataSource()
        setupNavigationBarItem()
    }
    // MARK: - DataSource Setup
    
    func setupDataSource()
    {
        if let url = URL(string:"https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")
        {
           let task = URLSession.shared.dataTask(with: url)
           { (data, response, error) in
              if let data = data, let photoData = try? JSONDecoder().decode(FeedData.self, from: data)
              {
                self.photos = photoData.items
                
                DispatchQueue.main.async
                {
                    self.collectionView.reloadData()
                }
              }
           }
           task.resume()
        }
    }
    
   func downloadImage(url: URL, handler: @escaping (UIImage?) -> ())
   {
        //  3. DownloadTask
        let task = URLSession.shared.downloadTask(with: url)
        { (downloadedURL, response, error) in
            if let url = downloadedURL
            {
                do
                {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    handler(image)
                }
                catch
                {
                    handler(nil)
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Collection View Setup
    //  1. Collectionview flow layout 2. CollectionView
    func setupCV()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        let width = (view.frame.size.width - 10) / 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width + 80)
        collectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        // Configure the cell
        let photo = photos[indexPath.item]
        cell.imageURL = photo.media.m
        cell.photoImageView.image = nil
        downloadImage(url: cell.imageURL)
        { (image) in
            if cell.imageURL == photo.media.m, let image = image
            {
                DispatchQueue.main.async
                {
                    cell.photoImageView.image = image
                }
            }
        }
        return cell
    }
    
    // MARK: - Customize Navigation Bar
    // 3. Customize Navigation Bar
    func setupNavigationBarItem()
    {
        // Navigation Bar Tittle View Logo
        let logoImage = UIImageView(frame: CGRect(x:0, y:0, width: 34, height: 34))
        logoImage.contentMode = .scaleAspectFit
        let titleLogo = UIImage(named: "venom")
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

