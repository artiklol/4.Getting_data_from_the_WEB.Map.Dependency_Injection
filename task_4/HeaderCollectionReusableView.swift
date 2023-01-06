//
//  HeaderCollectionReusableView.swift
//  task_4
//
//  Created by Artem Sulzhenko on 03.01.2023.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    static let reuserId = "SectionHeader"

    private lazy var titleHeader: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "BlackWhite")
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleHeader)

        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        titleHeader.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(0)
            maker.left.right.equalToSuperview().inset(10)
        }
    }

    func setTitleHeader(title: String) {
        titleHeader.text = title
    }

}
