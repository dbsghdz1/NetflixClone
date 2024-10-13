//
//  APIError.swift
//  NetflixClone
//
//  Created by 김윤홍 on 10/13/24.
//

import Foundation

enum APIError: String, Equatable, Error {
  case serverErrpr = "인터넷 연결문제"
  case invalidId = "영화 아이디 문제"
  case invalidUrl = "url 문제"
  case internalError = "다시시도 and debugging"
}
