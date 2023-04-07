//
//  HomeScreenFeature.ViewController.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 07.04.2023.
//

import UIKit
import ComposableArchitecture

extension HomeScreenFeature {
    final class ViewController: TCAViewController<State, Action> {
        override init(store: Store<HomeScreenFeature.State, HomeScreenFeature.Action>) {
            super.init(store: store)

            subscribe()
        }
        
        private func subscribe() {
            viewStore.publisher
                .sink { state in
                    print(state)
                }
                .store(in: &cancellables)
        }
    }
}