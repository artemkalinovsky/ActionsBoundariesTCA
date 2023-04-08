//
//  HomeScreenFeature.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 07.04.2023.
//

import ComposableArchitecture

struct HomeScreenFeature: ReducerProtocol {
    struct State: Equatable, ViewStateProvider {
        struct ViewState: Equatable {
            var error: TodoError?
            var todos: IdentifiedArrayOf<Todo>
        }

        var viewState: ViewState
    }

    enum Action: Equatable, ViewActionProvider {
        enum ViewAction: Equatable {
            case didLoad
            case list
            case toggle(Todo)
            case dismissError
        }
        enum ReducerAction: Equatable {
            case listResult(Result<[Todo], TodoError>)
            case toggleResult(Result<Todo, TodoError>)
        }

        case view(ViewAction)
        case reducer(ReducerAction)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        print(action)

        switch action {
        case .view(.list):
            let newTodos: [Todo] = [.init(name: "Wash Car", complete: false), .init(name: "Goto Gym", complete: true)]
            return .task { .reducer(.listResult(.success(newTodos))) }
        case .reducer(.listResult(.success(let todos))):
            state.todos = .init(uniqueElements: todos)
            return .none
        default:
            return .none
        }
    }
}
