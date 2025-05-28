//
//  FilterTaskView.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import UIKit

final class FilterTaskView: UIView {

    var onAllTaskButtonTap: (() -> Void)?
    var onOpenTaskButtonTap: (() -> Void)?
    var onClosedTaskButtonTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var containerView: UIView = {
        $0.backgroundColor = Colors.backGroundColor
       
        return $0
    }(UIView())
    
    private var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .leading
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        
        return $0
    }(UIStackView())
    
    private var allTaskButton = FilterButton(.selected)

    private var openTaskButton = FilterButton(.unselected)
    
    private var closedTaskButton = FilterButton(.unselected)
    
    private var separatorLineView: UIView = {
        $0.backgroundColor = Colors.gray
        
        return $0
    }(UIView())
    
    private func setupView() {
        self.addSubview(containerView)
        
        containerView.addSubview(horizontalStackView)
        
        [allTaskButton, separatorLineView, openTaskButton, closedTaskButton].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
    }
    
    func setupBindings() {
        allTaskButton.addTarget(self, action: #selector(allTaskButtonTapped), for: .touchUpInside)
        
        openTaskButton.addTarget(self, action: #selector(openTaskButtonTapped), for: .touchUpInside)
        
        closedTaskButton.addTarget(self, action: #selector(closedTaskButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(containerView).offset(5)
        }
        //FIXME: Rewrite constraitns(error)
        separatorLineView.snp.makeConstraints { make in
            make.left.equalTo(allTaskButton.snp.right).offset(20)
            make.width.equalTo(2)
            make.top.equalTo(horizontalStackView.snp.top).offset(20)
            make.bottom.equalTo(horizontalStackView.snp.bottom).offset(-10)
            make.height.equalTo(15)
            
        }
   
        allTaskButton.snp.makeConstraints { make in
            make.left.equalTo(horizontalStackView).offset(20)
            
        }
    
        openTaskButton.snp.makeConstraints { make in
            make.left.equalTo(separatorLineView.snp.right).offset(20)
        }
        
        closedTaskButton.snp.makeConstraints { make in
            make.left.equalTo(openTaskButton.snp.right).offset(20)
        }
    }
}

//MARK: - Event Handlers

extension FilterTaskView {
    
    @objc private func allTaskButtonTapped() {
        
        onAllTaskButtonTap?()
    }
    
    @objc private func openTaskButtonTapped() {
        onOpenTaskButtonTap?()
    }
    
    @objc private func closedTaskButtonTapped() {
        onClosedTaskButtonTap?()
    }
    
}

//MARK: - Public

extension FilterTaskView {
    func update(countTasks: (allTask: Int, openTask: Int, closedTask: Int)) {
                
        allTaskButton.setTitles(("\(FilterEnableType.all.rawValue)", " \(countTasks.allTask) "))
        openTaskButton.setTitles(("\(FilterEnableType.open.rawValue)"," \(countTasks.openTask) "))
        closedTaskButton.setTitles(("\(FilterEnableType.closed.rawValue)", " \(countTasks.closedTask) "))
    }
    
    func updateColorButton(state: FilterEnableType) {
        
        switch state {
        case .open:
            
            openTaskButton.setupStyle(.selected)
            allTaskButton.setupStyle(.unselected)
            closedTaskButton.setupStyle(.unselected)
            
        case .all:
            
            openTaskButton.setupStyle(.unselected)
            allTaskButton.setupStyle(.selected)
            closedTaskButton.setupStyle(.unselected)
            
        case .closed:
            
            openTaskButton.setupStyle(.unselected)
            allTaskButton.setupStyle(.unselected)
            closedTaskButton.setupStyle(.selected)
        }
    }
}

