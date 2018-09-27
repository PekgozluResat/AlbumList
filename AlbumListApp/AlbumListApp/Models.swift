//
//  Models.swift
//  AlbumListApp
//
//  Created by Resat Pekgozlu on 9/27/18.
//  Copyright © 2018 Resat Pekgozlu. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

struct Album: Decodable {
    let userId: Int
    let id: Int
    let title: String
}
