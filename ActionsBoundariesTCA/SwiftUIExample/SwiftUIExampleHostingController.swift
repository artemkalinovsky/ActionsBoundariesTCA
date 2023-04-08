//
//  SwiftUIExampleHostingController.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 08.04.2023.
//

import SwiftUI
import ComposableArchitecture

class SwiftUIExampleHostingController: UIHostingController<TodoList> {
    required init?(coder aDecoder: NSCoder) {
        super.init(rootView: TodoList(
            store: Store(
                initialState: TodoFeature.State(viewState: .init(todos: [])),
                reducer: TodoFeature()
            )
        ))
    }
}
