import SwiftUI
import ComposableArchitecture

public protocol TCAView: View where Body == WithViewStore<ViewState, ViewAction, Content> {
    associatedtype FeatureState
    associatedtype FeatureAction

    associatedtype ViewState
    associatedtype ViewAction

    associatedtype Content

    var store: Store<FeatureState, FeatureAction> { get }

    func isDuplicate(_ a: ViewState, _ b: ViewState) -> Bool

    func scopeState(_ state: FeatureState) -> ViewState
    func scopeAction(_ action: ViewAction) -> FeatureAction

    @ViewBuilder func storeView(_ viewStore: ViewStore<ViewState, ViewAction>) -> Content
}

extension TCAView where ViewState: Equatable {
    public func isDuplicate(_ a: ViewState, _ b: ViewState) -> Bool { a == b }
}

extension TCAView where ViewState == FeatureState {
    public func scopeState(_ state: FeatureState) -> ViewState { state }
}
extension TCAView where FeatureAction == ViewAction {
    public func scopeAction(_ action: ViewAction) -> FeatureAction { action }
}

extension TCAView {
    public var body: Body {
        WithViewStore(
            store.scope(state: scopeState, action: scopeAction),
            removeDuplicates: isDuplicate,
            content: storeView
        )
    }
}

extension TCAView where FeatureState: ViewStateProvider, ViewState == FeatureState.ViewState {
    public func scopeState(_ state: FeatureState) -> ViewState { state.viewState }
}

extension TCAView where FeatureAction: ViewActionProvider, ViewAction == FeatureAction.ViewAction {
    public func scopeAction(_ action: ViewAction) -> FeatureAction { FeatureAction.view(action) }
}
