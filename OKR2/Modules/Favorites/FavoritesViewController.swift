//
//  FavoritesViewController.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 30.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import UIKit
import RxSwift

class FavoritesViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(FavoritesTableViewCell.self)
        }
    }
    
    //MARK: - Properties
    var viewModel = FavoritesViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.movies.map({ (movies) -> [FavoritesTableViewCell.Model] in
            movies.map { FavoritesTableViewCell.Model(title: $0.title,
                isFavorite: $0.isFavorites) }
        }).bind(to: tableView.rx.items(cellIdentifier: FavoritesTableViewCell.defaultReuseIdentifier)) { index, model, cell in
            if let cell = cell as? FavoritesTableViewCell {
                cell.model = model
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.changeset.subscribe(onNext: { [weak self] (changes, collection) in
            if let changes = changes {
                self?.tableView.applyChangeset(changes)
            } else {
                self?.tableView.reloadData()
            }
            })
            .disposed(by: disposeBag)
    }

}
