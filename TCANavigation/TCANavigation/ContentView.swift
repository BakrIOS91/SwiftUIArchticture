//
//  ContentView.swift
//  TCANavigation
//
//  Created by Bakr mohamed on 29/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct ContentFeature: ReducerProtocol {
    
    struct State: Equatable {
        @PresentationState var forceUpdate: ForceUpdateFeature.State?
    }
    
    enum Action {
        case onAppear
        case forceUpdate(PresentationAction<ForceUpdateFeature.Action>)

    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.forceUpdate = .init()
                return .none
            case .forceUpdate:
                  return  .none
            }
        }
        .ifLet(\.$forceUpdate, action: /Action.forceUpdate) {
            ForceUpdateFeature()
        }
    }
    
    
}

struct ContentView: View {
    let store: StoreOf<ContentFeature>

    
    var body: some View {
        WithViewStore(store, observe: {$0}){ viewStore in
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewStore.send(.onAppear)
                }
            })
            .fullScreenCover(store: store.scope(state: \.$forceUpdate, action: ContentFeature.Action.forceUpdate), content: ForceUpdateView.init(store:))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .init(initialState: ContentFeature.State(), reducer: ContentFeature()))
    }
}
