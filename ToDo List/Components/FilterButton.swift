//
//  FilterButton.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.


import UIKit

enum FilterState: Int {
    case selected = 0
    case unselected = 1
}

class CustomButton: UIButton {
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

class FilterButton: CustomButton {
    
    public let lhsTextLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    public let rhsTextLabel: UILabel = {
        $0.layer.cornerRadius = 9
        $0.clipsToBounds = true
        $0.font = UIFont.systemFont(ofSize: 14)
        
        return $0
    }(UILabel())
    
    override var contentEdgeInsets: UIEdgeInsets {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    convenience init(_ state: FilterState) {
        self.init(frame: .zero)
        setupViews()
        setupStyle(state)
    }
    
    func setupViews() {
        self.addSubview(lhsTextLabel)
        self.addSubview(rhsTextLabel)
    }
    
    func setupStyle(_ state: FilterState) {
       
        switch state {
        case .unselected:
            lhsTextLabel.textColor = UIColor.gray
            
            rhsTextLabel.textColor = UIColor.white
            rhsTextLabel.backgroundColor = Colors.gray
        case .selected:
            lhsTextLabel.textColor = Colors.blue
            
            rhsTextLabel.textColor = UIColor.white
            rhsTextLabel.backgroundColor = Colors.blue
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        lhsTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(contentEdgeInsets.left)
        }
        
        rhsTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-contentEdgeInsets.right)
            make.leading.equalTo(lhsTextLabel.snp.trailing).offset(6)
        }
        
    }
    
    // MARK: - Convenience
    
    public func setTitles(_ titleStrings: (String?, String?) = (nil, nil)) {
        lhsTextLabel.text = titleStrings.0
        rhsTextLabel.text = titleStrings.1
    }
}
