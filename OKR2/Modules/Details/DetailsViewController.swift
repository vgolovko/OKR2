//
//  DetailsViewController.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 01.07.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import UIKit
import RxSwift
import Action
import RxRealm
import RealmSwift

class DetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var addFavoritesButton: UIButton! {
        didSet {
            addFavoritesButton.setTitle("Add to favorites", for: .normal)
            addFavoritesButton.setTitle("Remote from favorites", for: .selected)
        }
    }
    
    //MARK: - Properties
    var model: Movie?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addFavoritesButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self, var model = self.model else { return }
            model.updateFavorite()
            let observable: Observable<RMMovie> = Observable.from(object: model.asModel(with: nil))
            observable.debug().subscribe(Realm.rx.add(update: .modified))
                .disposed(by: self.disposeBag)
            self.addFavoritesButton.isSelected = !self.addFavoritesButton.isSelected
        }
        .disposed(by: disposeBag)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        guard let model = model else { return }
        titleLabel.text = model.title
        overviewLabel.text = model.overview
    }
}
