//
//  AlbumsViewController.swift
//  AlbumListApp
//
//  Created by Resat Pekgozlu on 9/27/18.
//  Copyright © 2018 Resat Pekgozlu. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class AlbumsViewController: UIViewController {

    var albums = [Album]()
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (view.frame.size.width - 10) / 2
        let layout = albumsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width * 1.3)
        updateCollectionContent()
    }
    func updateCollectionContent() {
        
        let service = ApiService()
        service.getDataWith { (result) in
            switch result {
            case .Success(let data):
                self.albums = data
                DispatchQueue.main.async {
                    self.albumsCollectionView.reloadData()
                }
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPhotos"){
            let cell = sender as! AlbumCollectionViewCell
            let destination = segue.destination as! AlbumDetailViewController
            
            destination.title = cell.titleLabel.text
            let userId = albums[(albumsCollectionView.indexPath(for: cell)?.row)!].id
            destination.updateCollectionContent(userId: userId)
        }
    }

}

extension AlbumsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = albumsCollectionView.dequeueReusableCell(withReuseIdentifier: "albumCollectionCell", for: indexPath) as! AlbumCollectionViewCell
        cell.titleLabel.text = albums[indexPath.row].title
        
        return cell
    }
}
