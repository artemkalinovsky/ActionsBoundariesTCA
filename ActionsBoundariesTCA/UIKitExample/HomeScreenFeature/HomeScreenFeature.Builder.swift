//
//  HomeScreenFeature.Builder.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 07.04.2023.
//

import UIKit
import ComposableArchitecture

extension HomeScreenFeature {
    static func build() -> UIViewController {
        HomeScreenFeature.ViewController(
            store: Store(
                initialState: HomeScreenFeature.State(viewState: HomeScreenFeature.State.ViewState(todos: [])),
                reducer: HomeScreenFeature()
            )
        )
    }
}
