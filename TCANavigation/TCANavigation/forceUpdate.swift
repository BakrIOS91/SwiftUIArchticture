//
//  forceUpdate.swift
//  TCANavigation
//
//  Created by Bakr mohamed on 29/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct ForceUpdateFeature: ReducerProtocol {
    
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
    
    
}
struct ForceUpdateView: View {
    let store: StoreOf<ForceUpdateFeature>

    var body: some View {
        Text("Force Update")
    }
}

struct forceUpdate_Previews: PreviewProvider {
    static var previews: some View {
        ForceUpdateView(store: .init(initialState: ForceUpdateFeature.State(), reducer: ForceUpdateFeature()))
    }
}
