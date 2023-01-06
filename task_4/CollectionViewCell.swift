//
//  CollectionViewCell.swift
//  task_4
//
//  Created by Artem Sulzhenko on 02.01.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "ATMList"

    private lazy var installPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        label.numberOfLines = 4
        label.textColor = .white
        return label
    }()
    private lazy var workTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Режим работы:"
        label.font = .boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    private lazy var workTimeLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    private lazy var currencyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Валюта:"
        label.font = .boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor(named: "Green")
        contentView.layer.cornerRadius = 15

        contentView.addSubview(installPlaceLabel)
        contentView.addSubview(workTimeTitleLabel)
        contentView.addSubview(workTimeLabel)
        contentView.addSubview(currencyTitleLabel)
        contentView.addSubview(currencyLabel)

        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        installPlaceLabel.snp.makeConstraints { maker in
            maker.top.left.right.equalTo(contentView).inset(5)
        }
        workTimeTitleLabel.snp.makeConstraints { maker in
            maker.left.right.equalTo(contentView).inset(5)
            maker.bottom.equalTo(workTimeLabel.snp.top).inset(3)
        }
        workTimeLabel.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(contentView).inset(5)
            maker.bottom.equalTo(contentView).inset(25)
        }
        currencyTitleLabel.snp.makeConstraints { maker in
            maker.left.right.equalTo(contentView).inset(5)
            maker.bottom.equalTo(contentView).inset(15)
        }
        currencyLabel.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(contentView).inset(5)
        }
    }

    func dataInCell(element: WelcomeElement) {
        installPlaceLabel.text = element.installPlace
        workTimeLabel.text = element.workTime
        currencyLabel.text = element.currency.rawValue
    }
}
