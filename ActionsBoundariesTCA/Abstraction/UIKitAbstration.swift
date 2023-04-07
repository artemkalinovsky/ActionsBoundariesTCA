import UIKit
import Combine
import ComposableArchitecture

//
//open class StatefulViewController<State: Equatable, Action>: BaseViewController {
//    var cancellables: Set<AnyCancellable> = []
//    var store: Store<State, Action>
//    var viewStore: ViewStore<State, Action>
//
//    public init(store: Store<State, Action>) {
//        self.store = store
//        viewStore = .init(store)
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    public required init?(coder: NSCoder) {
//        fatalError("Not implemented")
//    }
//}

//class StatefulViewController<ScopedState: Equatable, ScopedAction>: UIViewController {
////    typealias ViewState
////    typealias ViewAction
////
////    typealias ScopedState
////    typealias ScopedAction
//    
//    var cancellables: Set<AnyCancellable> = []
//    var store: Store<ViewState, ViewAction>
//    var viewStore: ViewStore<ViewState, ViewAction>
//
//    public init(store: Store<State, Action>) {
//        self.store = store
//        viewStore = .init(store)
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    public required init?(coder: NSCoder) {
//        fatalError("Not implemented")
//    }
//
//    func scopeState(_ state: ViewState) -> ScopedState {
//
//    }
//
//    func viewAction(_ action: ScopedAction) -> ViewAction {
//
//    }
//}

// MARK: - TCAViewControllerProtocol
//protocol TCAViewControllerProtocol {
//    associatedtype ViewState
//    associatedtype ViewAction
//
//    associatedtype ScopedState
//    associatedtype ScopedAction
//
//    var store: Store<ViewState, ViewAction> { get }
//
//    func isDuplicate(_ a: ScopedState, _ b: ScopedState) -> Bool
//
//    func scopeState(_ state: ViewState) -> ScopedState
//    func viewAction(_ action: ScopedAction) -> ViewAction
//}
//
//extension TCAViewControllerProtocol where Self: UIViewController {
//    init(store: Store<State, Action>) {
//        self.init(nibName: nil, bundle: nil)
//        self.store = store
//        viewStore = .init(store)
//
//        super.init(nibName: nil, bundle: nil)
//    }
//}


class TCAViewController<FeatureState: Equatable&ViewStateProvider, FeatureAction: ViewActionProvider>: UIViewController where FeatureState.ViewState: Equatable {
    var cancellables: Set<AnyCancellable> = []
    var store: Store<FeatureState, FeatureAction>
    var viewStore: ViewStore<FeatureState.ViewState, FeatureAction.ViewAction>


    init(store: Store<FeatureState, FeatureAction>) {
        self.store = store
        self.viewStore = ViewStore(
            store.scope(state: { $0.viewState }, action: { FeatureAction.view($0) }),
            removeDuplicates: { $0 == $1 }
        )

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
