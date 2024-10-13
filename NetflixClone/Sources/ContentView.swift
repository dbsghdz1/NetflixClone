import SwiftUI
import ComposableArchitecture
import Combine

struct Feature: Reducer {
  struct State: Equatable {
    var results:[UpcomingResult] = []
    var errorMessage: String?
    var response: Result<[UpcomingResult], APIError>?
  }
  
  enum Action: Equatable {
    case fetchData
    case fetchResponse(Result<[UpcomingResult], APIError>)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .fetchData:
      state.response = nil
      state.errorMessage = nil
      return .run { send in
        do {
          let response = try await NetworkManager.shared.getMovieInfo()
          await send(.fetchResponse(response))
        } catch {
          let apiError = error as? APIError ?? .serverErrpr
          await send(.fetchResponse(.failure(apiError)))
        }
      }
    case .fetchResponse(.success(let movieData)):
      state.results = movieData
      state.response = .success(movieData)
      return .none
      
    case .fetchResponse(.failure(let error)):
      state.response = .failure(error)
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
                  image.resizable()
                } placeholder: {
                  ProgressView()
                }
              }
            }
          }
//          List(viewStore.results) { result in
//            Text(result.title)
//          }
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
  ContentView(store: Store(initialState: Feature.State(), reducer: { Feature() }))
}
