//
//  AlbumDetailViewController.swift
//  AlbumListApp
//
//  Created by Resat Pekgozlu on 9/27/18.
//  Copyright © 2018 Resat Pekgozlu. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupThumbnailImage(url: String){
        thumbnailImageView.loadImageUsingUrlString(urlString: url)
    }
}

class AlbumDetailViewController: UIViewController {

    var photos = [Photo]()
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (view.frame.size.width - 10) / 2
        let layout = photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        
    }
    
    func updateCollectionContent(userId: Int) {
        
        let service = ApiService()
        service.getAlbumWithUserId(userId: userId) { (result) in
            switch result {
            case .Success(let data):
                self.photos = data
                DispatchQueue.main.async {
                    self.photosCollectionView.reloadData()
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
        if (segue.identifier == "showPhoto"){
            let cell = sender as! PhotosCollectionViewCell
            let destination = segue.destination as! PhotoViewController
            destination.title = cell.titleLabel.text
            destination.imageUrl = photos[(photosCollectionView.indexPath(for: cell)?.row)!].url
        }
    }
    
}
extension AlbumDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "photosCollectionCell", for: indexPath) as! PhotosCollectionViewCell
        cell.titleLabel.text = photos[indexPath.row].title
        cell.setupThumbnailImage(url: photos[indexPath.row].thumbnailUrl)
        
        return cell
    }

}

extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
            }.resume()
    }
}
