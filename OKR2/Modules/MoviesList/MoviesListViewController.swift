//
//  ViewController.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 04.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import RxSwift
import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet private weak var moviesTableView: UITableView! {
        didSet {
            moviesTableView.register(MoviesListTableViewCell.self)
        }
    }
    
    //MARK: - Properties
    let viewModel = MoviesListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.refreshMoviesList()
        viewModel.movies.map({ (movies) -> [MoviesListTableViewCell.Model] in
            movies.map { MoviesListTableViewCell.Model(id: $0.id,
                                                       title: $0.title,
                                                       imagePath: $0.posterPath) }
        }).bind(to: moviesTableView.rx.items(cellIdentifier: MoviesListTableViewCell.defaultReuseIdentifier)) { index, model, cell in
            if let cell = cell as? MoviesListTableViewCell {
                cell.model = model
            }
        }
        .disposed(by: disposeBag)
        
        moviesTableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            let model = self.viewModel.movies.value[index.row]
            let controller = self.controller()
            controller.model = model
            self.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func controller() -> DetailsViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier:"DetailsViewController") as? DetailsViewController else { fatalError() }
        return controller
    }
}

