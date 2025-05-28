//
//  ToDoListCell.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import UIKit
import SnapKit

class ToDoListCell: UITableViewCell {
    
    static let reuseId = "Cell"
    
    var onCheckBoxButtonTap: (() -> Void)?
    
    var containerView: UIView = {
        $0.backgroundColor = .white
        $0.applyShadow(cornerRadius: 17)
        
        return $0
    }(UIView())
    
    var verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 7
        $0.alignment = .leading
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        
        return $0
    }(UIStackView())
    
    var titleLabel: UILabel = {
        $0.text = "Client Review & FeedBack"
        $0.numberOfLines = 1
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
        
        return $0
    }(UILabel())
    
    var subTitleLabel: UILabel = {
        $0.text = "Crypto Wallet Redesign"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.gray
        $0.numberOfLines = 0
        
        return $0
    }(UILabel())
    
    var checkBoxButton: UIButton = {
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        $0.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        $0.addTarget(nil, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        
        return $0
    }(UIButton())
    
    @objc private func checkBoxButtonTapped() {
        onCheckBoxButtonTap?()
    }
    
    var dataCreatedLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = UIColor.gray
        
        return $0
    }(UILabel())
    
    var timeCreatedLabel: UILabel = {
        $0.text = "10:00PM - 12:00PM"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.lightGray
        
        return $0
    }(UILabel())
    
    var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .leading
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        
        return $0
    }(UIStackView())
    
    var separatorLineView: UIView = {
        $0.backgroundColor = Colors.lightGray
        
        return $0
    }(UIView())
    
    var emptyView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.backgroundColor = Colors.backGroundColor
        
        contentView.addSubview(containerView)
        
        [verticalStackView, checkBoxButton, horizontalStackView, separatorLineView].forEach {
            containerView.addSubview($0)
        }
        
        [titleLabel, subTitleLabel].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
        [dataCreatedLabel, timeCreatedLabel, emptyView].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.bottom.equalTo(contentView).inset(8)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(8)
            make.leading.equalTo(containerView).offset(8) 
            make.trailing.equalTo(checkBoxButton.snp.leading).offset(-8)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.trailing.equalTo(containerView).inset(16)
            make.centerY.equalTo(verticalStackView)
            make.width.height.equalTo(24)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(8)
            make.height.equalTo(1)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).inset(16)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(16)
            make.leading.equalTo(containerView).offset(8)
            make.trailing.equalTo(containerView).inset(16)
            make.bottom.lessThanOrEqualTo(containerView).inset(8)
        }
        
    }
    
    func update(_ toDoTask: TaskModel) {
        
        let date = Date()
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "EEEE, d"
        let formattedDate = formatterDate.string(from: date)
        
        if toDoTask.date == formattedDate {
            dataCreatedLabel.text = "Today"
        } else {
            dataCreatedLabel.text = toDoTask.date
        }
        
        if toDoTask.description == " " {
            subTitleLabel.text = toDoTask.todo
        }else {
            subTitleLabel.text = toDoTask.description
        }
        
        timeCreatedLabel.text = "\(toDoTask.startTime ?? "11:00 AM") - \(toDoTask.endTime ?? "13:00 PM")"
        
        
        if toDoTask.completed {
            checkBoxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            let attributedString = NSAttributedString(string: toDoTask.todo, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.gray
            ])
            titleLabel.attributedText = attributedString
            checkBoxButton.tintColor = Colors.darkBlue
        } else {
            let config = UIImage.SymbolConfiguration(weight: .thin)
            checkBoxButton.setImage(UIImage(systemName: "circle", withConfiguration: config), for: .normal)
            checkBoxButton.tintColor = Colors.gray
            
            titleLabel.attributedText = nil
            titleLabel.text = toDoTask.todo
        }
    }
    
}
