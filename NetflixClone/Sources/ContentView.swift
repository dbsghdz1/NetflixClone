import SwiftUI
import ComposableArchitecture
import Combine

struct Feature: Reducer {
  struct State: Equatable {
    var results = [String]()
    var errorMessage: String?
    var response: Result<UpcomingDTO, APIError>?
  }
  
  enum Action: Equatable {
    case fetchData
    case fetchResponse(Result<UpcomingDTO, APIError>)
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
          // NSURLError와 다른 오류를 처리합니다.
          let apiError = error as? APIError ?? .serverErrpr // 기본 오류 설정
          await send(.fetchResponse(.failure(apiError)))
        }
      }
    case .fetchResponse(.success(let movieData)):
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
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        if let errorMessage = viewStore.errorMessage {
          Text("Error: \(errorMessage)")
            .foregroundColor(.red)
        } else {
          List(viewStore.results, id: \.self) { result in
            Text(result) // 영화 제목을 표시
          }
        }
        
        Button("Fetch Upcoming Movies") {
          viewStore.send(.fetchData) // 버튼 클릭 시 fetchData 액션 발송
        }
      }
      .padding()
      .onAppear {
        viewStore.send(.fetchData) // 뷰가 나타날 때 데이터 가져오기
      }
    }
  }
}

#Preview {
  ContentView(store: Store(initialState: Feature.State(), reducer: { Feature() }))
}
