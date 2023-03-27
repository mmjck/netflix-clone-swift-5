//
//  TV.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 20/03/23.
//

import Foundation



struct TrendingTVResponse: Codable{
    let results: [TV ]
}


struct TV: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let release_date: String?
    
    let vote_count: Int
    let vote_average: Double
    
}
