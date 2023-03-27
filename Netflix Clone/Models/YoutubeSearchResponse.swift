//
//  YoutubeSearchModel.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 23/03/23.
//

import Foundation



struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
