//
//  InitialViewController.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 08.04.2023.
//

import UIKit
import SwiftUI
import ComposableArchitecture

final class InitialViewController: UITableViewController {
    @IBAction func didTapOnUIKitExampleCell(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(HomeScreenFeature.build(), animated: true)
    }
    
    @IBAction func didTapOnSwiftUIExampleCell(_ sender: Any) {
        navigationController?.pushViewController(
            UIHostingController(
                rootView: TodoList(
                    store: Store(
                        initialState: TodoFeature.State(viewState: .init(todos: [])),
                        reducer: TodoFeature()
                    )
                )
            ),
            animated: true)
    }
    
}
