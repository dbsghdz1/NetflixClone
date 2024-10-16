//
//  NetworkManager.swift
//  NetflixClone
//
//  Created by 김윤홍 on 10/13/24.
//

import Foundation
import Moya

//class NetworkManager {
//  static let shared = NetworkManager()
//  private init() {}
//  
//  let baseUrl = "https://api.themoviedb.org/3/movie/"
//  func getMovieInfo() async throws -> Result<[UpcomingResult], APIError> {
//    guard let Url = URL(string: baseUrl + "upcoming") else {
//      return .failure(.invalidUrl)
//    }
//    
//    // URLComponents
//    // Moya
//    
//    do {
//      var request = URLRequest(url: Url)
//      request.httpMethod = "GET"
//      request.timeoutInterval = 10
//      request.allHTTPHeaderFields = [
//        "Content-Type": "application/json",
//        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMzZmZDU1OTFkMTQ0M2UwZTVjMjkwYTYxZDAyMWEzMSIsIm5iZiI6MTcyODY5NTcyOS4yMjkyMTQsInN1YiI6IjY2YTlkYThmMDM3YzNiYzc2YjVjNWIwYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2Y-u9nG8U7FK4gRWe3gHifR2KpZv1GW8Gnt2hvJzc3E",
//      ]
//      let (data, response) = try await URLSession.shared.data(for: request)
//      print(Url)
//      print(response)
//      
//      if let httpResponse = response as? HTTPURLResponse {
//        switch httpResponse.statusCode {
//        case 200:
//          break
//        case 404:
//          return .failure(.invalidId)
//        case 500..<599:
//          return .failure(.serverErrpr)
//        default:
//          return.failure(.internalError)
//        }
//      }
//      
//      guard let movieData = try? JSONDecoder().decode(UpcomingDTO.self, from: data) else {
//        return .failure(.internalError)
//      }
//      return .success(movieData.results)
//    } catch {
//      return .failure(.serverErrpr)
//    }
//  }
//}

//class GetManager {
//  
//  private init() {}
//  static let shared = GetManager()
//  
//  func getMovieInfo() {
//    let provider = MoyaProvider<MovieAPI>()
//    provider.request(.popular) { result in
//      switch result {
//      case .success(let response):
//        do {
//          let decodedResponse = try JSONDecoder().decode(PopularResult, from: response.data)
//          DispatchQ
//        }
//      }
//      
//    }
//  }
//  
//}

//enum MovieList {
//  case popular(PopularDTO)
//  case upcoming(UpcomingDTO)
//  case topRated(TopRatedDTO)
//  
//  var type: String {
//    switch self {
//    case .popular:
//      return "popular"
//    case .upcoming:
//      return "upcoming"
//    case .topRated:
//      return "top_rated"
//    }
//  }
//}

enum MovieAPI {
  case popular
  case upcoming
  case topRated
}

extension MovieAPI: TargetType {
  var baseURL: URL { URL(string: "https://api.themoviedb.org/3/movie/")! }
  
  var path: String {
    switch self {
    case .popular: return "popular"
    case .topRated: return "topRated"
    case .upcoming: return "upcoming"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Moya.Task {
    switch self {
    case .popular:
      return .requestPlain
    case .topRated:
      return .requestPlain
    case .upcoming:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMzZmZDU1OTFkMTQ0M2UwZTVjMjkwYTYxZDAyMWEzMSIsIm5iZiI6MTcyODY5NTcyOS4yMjkyMTQsInN1YiI6IjY2YTlkYThmMDM3YzNiYzc2YjVjNWIwYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2Y-u9nG8U7FK4gRWe3gHifR2KpZv1GW8Gnt2hvJzc3E"
      ]
    }
  }
}
