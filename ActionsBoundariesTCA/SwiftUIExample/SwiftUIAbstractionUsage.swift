import SwiftUI
import ComposableArchitecture

struct TodoFeature: ReducerProtocol {
    enum Action: Equatable, ViewActionProvider {
        enum ViewAction: Equatable {
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

    struct State: Equatable, ViewStateProvider {
        struct ViewState: Equatable {
            var error: TodoError?
            var todos: IdentifiedArrayOf<Todo>
        }

        var viewState: ViewState
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .view(.list):
            let newTodos: [Todo] = [.init(name: "Wash Car", complete: false), .init(name: "Goto Gym", complete: true)]
            return .task { .reducer(.listResult(.success(newTodos))) }

        case .view(.toggle(let todo)):
            return .task { .reducer(.toggleResult(.success(.init(id: todo.id, name: todo.name, complete: !todo.complete)))) }

        case .view(.dismissError):
            state.error = nil
            return .none

        case .reducer(.listResult(.success(let todos))):
            state.todos = .init(uniqueElements: todos)
            return .none

        case .reducer(.toggleResult(.success(let todo))):
            state.todos[id: todo.id] = todo
            return .none

        case .reducer(.listResult(.failure(let error))), .reducer(.toggleResult(.failure(let error))):
            state.error = error
            return .none
        }
    }
}

struct TodoList: TCAView {
    var store: Store<TodoFeature.State, TodoFeature.Action>

    func storeView(_ viewStore: ViewStore<TodoFeature.State.ViewState, TodoFeature.Action.ViewAction>) -> some View {
        List(viewStore.todos) { todo in
            HStack {
                Text(todo.name).frame(maxWidth: .infinity, alignment: .leading)
                if todo.complete { Image(systemName: "checkmark.square") }
            }
            .swipeActions {
                Button(todo.complete ? "Mark Incomplete" : "Mark Complete") {
                    viewStore.send(.toggle(todo))
                }
             }
        }
//        .alert(item: viewStore.binding(get: \.error, send: .dismissError)) { error in
//            Alert.init(title: Text("Oh No"), message: Text(error.reason), dismissButton: .cancel { viewStore.send(.dismissError) })
//        }
        .onAppear { viewStore.send(.list) }
    }
}

public struct TodoList_Previews: PreviewProvider {

    public static var previews: some View {
        TodoList(
            store: Store(
                initialState: TodoFeature.State(viewState: .init(todos: [])),
                reducer: TodoFeature()
            )
        )
    }
}
