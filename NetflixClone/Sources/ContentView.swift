import SwiftUI
import ComposableArchitecture
import Combine
import Moya

struct Feature: Reducer {
  private let provider = MoyaProvider<MovieAPI>()
  struct State: Equatable {
    var results:[UpcomingResult] = []
    var posterArray = [String]()
    var errorMessage: String?
    //var response: Result<[UpcomingResult], APIError>?
  }
  
  enum Action: Equatable {
    case fetchData
    case fetchResponse(Result<[UpcomingResult], APIError>)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .fetchData:
      state.results = []
      //state.response = nil
      state.errorMessage = nil
      return .run { send in
        provider.request(.popular) { result in
          switch result {
          case let .success(response):
            print(response.statusCode)
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(PopularDTO.self, from: response.data) {
              let posters = json.results
              for poster in posters {
                
              }
            }
            return
          case .failure(let error):
            print(error)
            return
          }
        }
//        do {
//          provider.request(.popular) { responsee in
//            switch responsee {
//            case .success(let result):
//              guard let data = try? result.map(DataResponse<PopularResult>.self) else {
//                print(data)
//              }
//            case .failure(let error):
//              print(err)
//            }
//            
//          }
////          let response = try await NetworkManager.shared.getMovieInfo()
////          await send(.fetchResponse(response))
//        } catch {
//          let apiError = error as? APIError ?? .serverErrpr
//          await send(.fetchResponse(.failure(apiError)))
//        }
      }
    case .fetchResponse(.success(let movieData)):
      state.results = movieData
      state.errorMessage = nil
      //state.response = .success(movieData)
      return .none
      
    case .fetchResponse(.failure(let error)):
      //state.response = .failure(error)
      state.errorMessage = error.rawValue
      return .none
    }
  }
}

struct ContentView: View {
  let store: StoreOf<Feature>
  let columns = Array(repeating: GridItem(.fixed(100)), count: 1)
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Text("NetFlix")
      VStack {
        if let errorMessage = viewStore.errorMessage {
          Text("Error: \(errorMessage)")
            .foregroundColor(.red)
        } else {
          Text("개봉 예정영화")
          ScrollView(.horizontal) {
            LazyHGrid(rows: columns) {
              ForEach(viewStore.results) { result in
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(result.posterPath).jpg")) { image in
                  image.resizable()
                } placeholder: {
                  ProgressView()
                }
              }
            }
          }
          
          Text("개봉 예정영화")
          ScrollView(.horizontal) {
            LazyHGrid(rows: columns) {
              ForEach(viewStore.results) { result in
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(result.posterPath).jpg")) { image in
                  image.aspectRatio(contentMode: .fill)
                } placeholder: {
                  ProgressView()
                }
              }
            }
          }
          
          Text("개봉 예정영화")
          ScrollView(.horizontal) {
            LazyHGrid(rows: columns) {
              ForEach(viewStore.results) { result in
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(result.posterPath).jpg")) { image in
                  image.scaledToFit()
                } placeholder: {
                  ProgressView()
                }
              }
            }
          }
        }
      }
      .padding()
      .onAppear {
        viewStore.send(.fetchData)
      }
    }
  }
}

#Preview {
  ContentView(
    store: Store(
      initialState: Feature.State(),
      reducer: {
        Feature()
      }
    )
  )
}
