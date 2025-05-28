//
//  UpdateTaskViewController.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import UIKit
import SnapKit

protocol IUpdateTaskViewController {
    var presenter: UpdateTaskPresenter? { get set }
    
}

class UpdateTaskViewController: UIViewController {
    
    var delegate: IUpdateTaskDelegate?
    
    var presenter: UpdateTaskPresenter?
    
    var onCheckBoxButtonTap: (() -> Void)?
    
    var containerViewTitle: UIView = {
        $0.backgroundColor = Colors.backGroundColor
        $0.applyShadow(cornerRadius: 20)
        
        return $0
    }(UIView())
    
    var containerViewDescription: UIView = {
        $0.backgroundColor = Colors.backGroundColor
        $0.applyShadow(cornerRadius: 20)
        
        return $0
    }(UIView())
    
    var titleTask: UITextField = {
        $0.placeholder = " "
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.lightGray
        $0.clearButtonMode = .unlessEditing
        $0.textAlignment = .left
       
        return $0
    }(UITextField())
    
    var descriptionTask: UITextField = {
        $0.placeholder = " "
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.lightGray
        $0.clearButtonMode = .unlessEditing
        $0.textAlignment = .left
        
        return $0
    }(UITextField())
    
    var titleLabel: UILabel = {
        $0.text = "Title"
        $0.numberOfLines = 1
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
        
        return $0
    }(UILabel())
    
    var descriptionLabel: UILabel = {
        $0.text = "Description"
        $0.numberOfLines = 1
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = UIColor.black
        
        return $0
    }(UILabel())
    
    private var checkBoxButton: UIButton = {
        $0.setTitle("Save Changes", for: .normal)
        $0.setTitleColor(Colors.middleBlue, for: .normal)
        $0.backgroundColor = Colors.lightBlue
        $0.layer.cornerRadius = 14
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.widthAnchor.constraint(equalToConstant: 250).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 45).isActive = true
        $0.addTarget(nil, action: #selector(onCheckBoxButtonTapped), for: .touchUpInside)
        
        return $0
    }(UIButton())
    
    @objc private func onCheckBoxButtonTapped() {
        onCheckBoxButtonTap?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        setupView()
        setupConstraints()
        setupBindings()

    }
    
    func setupView() {
        view.backgroundColor = Colors.backGroundColor
        
        [titleLabel, containerViewTitle, descriptionLabel, containerViewDescription, checkBoxButton].forEach {
            view.addSubview($0) }
        
        containerViewTitle.addSubview(titleTask)
        containerViewDescription.addSubview(descriptionTask)
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(view).inset(20)
        }
        
        containerViewTitle.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(titleLabel).inset(30)
        }
        
        titleTask.snp.makeConstraints { make in
            make.edges.equalTo(containerViewTitle).inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(containerViewTitle.snp.bottom).offset(20)
            make.left.equalTo(view).inset(16)
            
        }
        
        descriptionTask.snp.makeConstraints { make in
            make.edges.equalTo(containerViewDescription).inset(10)
        }
        
        containerViewDescription.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(16)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalTo(containerViewDescription.snp.bottom).offset(30)
            make.centerX.equalTo(view)
        }
    }
}

extension UpdateTaskViewController {
    func update(_ task: TaskModel) {
        titleTask.text = task.todo
        descriptionTask.text = task.description
        presenter?.saveTask(task: task)
    }
}

//MARK: - Event Handlers

extension UpdateTaskViewController {
    func setupBindings() {
        self.onCheckBoxButtonTap = { [weak self] in
            self?.presenter?.updateTask(title:  self?.titleTask.text ?? " "  , description: self?.descriptionTask.text ?? " ")
            
            self?.delegate?.reloadAndFetchList()
            
            self?.dismiss(animated: true, completion: nil)
            
        }
    }
}
