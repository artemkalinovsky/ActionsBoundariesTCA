//
//  HomeScreenFeature.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 07.04.2023.
//

import ComposableArchitecture

struct HomeScreenFeature: ReducerProtocol {
    struct State: Equatable {
    }

    enum Action: Equatable {
        case viewDidLoad
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewDidLoad:
            return .none
        }
    }
}
