//
//  TopRatedDTO.swift
//  NetflixClone
//
//  Created by 김윤홍 on 10/12/24.
//

import Foundation

struct TopRatedDTO: Codable {
  let results: [TopRatedResult]
  let page, totalPages, totalResults: Int
  
  enum CodingKeys: String, CodingKey {
    case results, page
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
}

struct TopRatedResult: Codable {
  let id: Int
  let adult: Bool?
}
