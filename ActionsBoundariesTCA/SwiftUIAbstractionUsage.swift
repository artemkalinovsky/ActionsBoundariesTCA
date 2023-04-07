import SwiftUI
import ComposableArchitecture

struct TodoError: Error, Equatable {
    let reason: String
}

struct Todo: Identifiable, Equatable {
    var id = UUID()

    let name: String
    let complete: Bool
}

enum TodoAction: Equatable, ViewActionProvider {
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

struct TodoState: Equatable, ViewStateProvider {
    struct ViewState: Equatable {
        var error: TodoError?
        var todos: IdentifiedArrayOf<Todo>
    }

    var viewState: ViewState
}

let todoReducer = Reducer<TodoState, TodoAction, Void> { state, action, _ in
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

struct TodoList: TCAView {
    var store: Store<TodoState, TodoAction>

    func storeView(_ viewStore: ViewStore<TodoState.ViewState, TodoAction.ViewAction>) -> some View {
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
