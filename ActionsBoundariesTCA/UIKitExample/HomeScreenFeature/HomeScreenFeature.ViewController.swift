//
//  HomeScreenFeature.ViewController.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 07.04.2023.
//

import UIKit
import ComposableArchitecture

extension HomeScreenFeature {
    final class ViewController: TCAViewController<State, Action> {
        private let tableView = UITableView()

        override init(store: Store<State, Action>) {
            super.init(store: store)
            self.subscribe()
        }

        override func loadView() {
            super.loadView()

            view.backgroundColor = .white
            setupTableView()
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            viewStore.send(.didLoad)
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            viewStore.send(.list)
        }
    }
}

extension HomeScreenFeature.ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewStore.todos.elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewStore.todos.elements[indexPath.row].name
        return cell
    }
}

private extension HomeScreenFeature.ViewController {
    func subscribe() {
        viewStore.publisher.sink { [weak self] state in
            print(state)
            self?.tableView.reloadData()
        }
        .store(in: &cancellables)
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.dataSource = self
    }
}
