import Foundation

@dynamicMemberLookup
public protocol ViewStateProvider: Equatable {
    associatedtype ViewState: Equatable

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

public protocol ViewActionProvider {
    associatedtype ViewAction

    static func view(_: ViewAction) -> Self
}
