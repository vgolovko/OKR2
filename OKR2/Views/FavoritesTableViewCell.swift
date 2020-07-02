//
//  FavoritesTableViewCell.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 01.07.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import UIKit
import RxSwift

extension FavoritesTableViewCell {
    struct Model {
        let title : String
        let isFavorite: Bool
    }
}

class FavoritesTableViewCell: UITableViewCell, NibLoadableView, ReusableView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var switcher: UISwitch!
    
    public let switching = PublishSubject<Bool>()
    var model: Model? {
        didSet {
            update()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
        switching.dispose()
    }
    
    func update() {
        guard let viewModel = model else { return }
        self.titleLabel.text = viewModel.title
        self.switcher.isSelected = viewModel.isFavorite
        _ = switching.bind(to: switcher.rx.isSelected)
    }
    
}
