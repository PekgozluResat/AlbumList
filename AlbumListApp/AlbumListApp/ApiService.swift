//
//  ApiService.swift
//  AlbumList
//
//  Created by Resat Pekgozlu on 9/26/18.
//  Copyright © 2018 Resat Pekgozlu. All rights reserved.
//

import Foundation

enum Result<T>{
    case Success(T)
    case Error(String)
}

class ApiService {
    
    func getDataWith(completion: @escaping (Result<[Album]>) -> Void) {
        
        let urlString = "https://jsonplaceholder.typicode.com/albums"
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                 let albums = try JSONDecoder().decode([Album].self, from: data)
                    DispatchQueue.main.async {
                        completion(.Success(albums))
                    }
              
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
    func getAlbumWithUserId(userId: Int, completion: @escaping (Result<[Photo]>) -> Void) {
        
        let urlStringPhotos = "https://jsonplaceholder.typicode.com/photos?albumId=\(userId)"
        
        guard let url = URL(string: urlStringPhotos) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                DispatchQueue.main.async {
                    completion(.Success(photos))
                }
                
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
}
