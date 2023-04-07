import SwiftUI
import ComposableArchitecture

// MARK: - TCAView
public protocol TCAView: View where Body == WithViewStore<ScopedState, ScopedAction, Content> {
    associatedtype ViewState
    associatedtype ViewAction

    associatedtype ScopedState
    associatedtype ScopedAction

    associatedtype Content

    var store: Store<ViewState, ViewAction> { get }

    func isDuplicate(_ a: ScopedState, _ b: ScopedState) -> Bool

    func scopeState(_ state: ViewState) -> ScopedState
    func scopeAction(_ action: ScopedAction) -> ViewAction

    @ViewBuilder func storeView(_ viewStore: ViewStore<ScopedState, ScopedAction>) -> Content
}

extension TCAView where ScopedState: Equatable {
    public func isDuplicate(_ a: ScopedState, _ b: ScopedState) -> Bool { a == b }
}

extension TCAView where ScopedState == ViewState {
    public func scopeState(_ state: ViewState) -> ScopedState { state }
}
extension TCAView where ViewAction == ScopedAction {
    public func scopeAction(_ action: ScopedAction) -> ViewAction { action }
}

extension TCAView {
    public var body: Body {
        WithViewStore(store.scope(state: scopeState, action: scopeAction), removeDuplicates: isDuplicate, content: storeView)
    }
}

// MARK: - ViewStateProvider
@dynamicMemberLookup
public protocol ViewStateProvider {
    associatedtype ViewState

    var viewState: ViewState { get set }
}

extension ViewStateProvider {
    public subscript<T>(dynamicMember keyPath: KeyPath<ViewState, T>) -> T {
        viewState[keyPath: keyPath]
    }
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<ViewState, T>) -> T {
        get { viewState[keyPath: keyPath] }
        set { viewState[keyPath: keyPath] = newValue }
    }
}

extension TCAView where ViewState: ViewStateProvider, ScopedState == ViewState.ViewState {
    public func scopeState(_ state: ViewState) -> ScopedState { state.viewState }
}

// MARK: - ViewActionProvider
public protocol ViewActionProvider {
    associatedtype ViewAction

    static func view(_: ViewAction) -> Self
}

extension TCAView where ViewAction: ViewActionProvider, ScopedAction == ViewAction.ViewAction {
    public func scopeAction(_ action: ScopedAction) -> ViewAction { ViewAction.view(action) }
}
