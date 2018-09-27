//
//  PhotoViewController.swift
//  AlbumListApp
//
//  Created by Resat Pekgozlu on 9/27/18.
//  Copyright © 2018 Resat Pekgozlu. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    var imageUrl: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage(url: imageUrl)
        
        // Do any additional setup after loading the view.
    }
    
    func setupImage(url: String){
        photoImageView.loadImageUsingUrlString(urlString: url)
    }

}
