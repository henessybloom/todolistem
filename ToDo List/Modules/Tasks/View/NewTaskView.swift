//
//  NewTaskView.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import UIKit

final class NewTaskView: UIView {
    
    var onCheckBoxButtonTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 7
        $0.alignment = .leading
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        
        return $0
    }(UIStackView())
    
    private var titleLabel: UILabel = {
        $0.text = "Today's Task"
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        
        return $0
    }(UILabel())
    
    private var subTitleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.gray
        
        return $0
    }(UILabel())
    
    private var checkBoxButton: UIButton = {
        $0.setTitle("+ New Task", for: .normal)
        $0.setTitleColor(Colors.middleBlue, for: .normal)
        $0.backgroundColor = Colors.lightBlue
        $0.layer.cornerRadius = 14
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.widthAnchor.constraint(equalToConstant: 130).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 45).isActive = true
        $0.addTarget(nil, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        
        return $0
    }(UIButton())
    
    @objc private func checkBoxButtonTapped() {
        UIView.animate(withDuration: 0.1,
                       animations: { [weak self] in
            self?.checkBoxButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self?.checkBoxButton.backgroundColor = Colors.darkLightBlue
        }, completion: { [weak self] _ in
            UIView.animate(withDuration: 0.1) {
                self?.checkBoxButton.transform = CGAffineTransform.identity
                self?.checkBoxButton.backgroundColor = Colors.lightBlue
            }
        })
        onCheckBoxButtonTap?()
    }
    
    private func setupView() {
        
        [verticalStackView, checkBoxButton].forEach {
            self.addSubview($0)
        }
        
        [titleLabel, subTitleLabel].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
    }
    
    private func setupConstraints() {
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.leading.equalTo(self).offset(8)
            make.bottom.equalTo(self)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(16)
            make.centerY.equalTo(verticalStackView)
        }
    }
}

//MARK: - Public
extension NewTaskView {
    func update(date: String) {
        self.subTitleLabel.text = date
    }
}
