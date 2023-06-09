import UIKit
import Combine
import ComposableArchitecture

class TCAViewController<FeatureState: Equatable&ViewStateProvider, FeatureAction: ViewActionProvider>: UIViewController {
    var cancellables: Set<AnyCancellable> = []
    let viewStore: ViewStore<FeatureState.ViewState, FeatureAction.ViewAction>

    init(store: Store<FeatureState, FeatureAction>) {
        self.viewStore = ViewStore(
            store.scope(
                state: { $0.viewState },
                action: { FeatureAction.view($0) }
            ),
            removeDuplicates: { $0 == $1 }
        )

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
