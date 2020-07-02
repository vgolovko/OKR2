//
//  MoviesListTableViewCell.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 01.07.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import UIKit
import Kingfisher

extension MoviesListTableViewCell {
    struct Model {
        var id: Int
        var title: String
        var imagePath: String
    }
}

class MoviesListTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    //MARK: - Property
    var model: Model? {
        didSet {
            update()
        }
    }
    
    //MARK: - Live Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
        posterImageView.kf.cancelDownloadTask()
    }
    
    func update() {
        guard let viewModel = model else { return }
        titleLabel.text = viewModel.title
        if let url = URL(string: Networking.Requests.popular + viewModel.imagePath) {
            posterImageView.kf.setImage(with: .network(url))
        }
    }
}

extension MoviesListTableViewCell: NibLoadableView, ReusableView {}
