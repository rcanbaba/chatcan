//
//  SegmentedControl.swift
//  chatcan
//
//  Created by Can Babaoğlu on 29.05.2022.
//

import UIKit

protocol SegmentedControlViewDelegate: AnyObject {
    func segmentedController (_ view: SegmentedControlView, selected index: Int)
}

// TODO: not working with NSConstraints
class SegmentedControlView: UIView {
    
    public weak var delegate: SegmentedControlViewDelegate?
    
    lazy private var baseStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var selectionView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var baseIndex = 5000
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionView.layer.cornerRadius = selectionView.bounds.height / 2
    }
    
    private func configureUI () {
        layer.cornerRadius = 14
        clipsToBounds = true
        backgroundColor = UIColor.red
        translatesAutoresizingMaskIntoConstraints = false
        
        setSelectionView()
        setBaseStackView()
    }
    
    private func setSelectionView () {
        self.addSubview(selectionView)
    }
    
    private func setBaseStackView () {
        addSubview(baseStackView)
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    
    private lazy var lastSelected = baseIndex
    @objc private func buttonPressed (_ sender: UIButton) {
        
        if lastSelected == sender.tag {
            return
        }
        
        lastSelected = sender.tag
        setNewIndexUI(index: sender.tag)
        delegate?.segmentedController(self, selected: sender.tag - baseIndex)
    }
    
    private func setNewIndexUI (index: Int) {
        
        guard let selectedButton = baseStackView.arrangedSubviews.filter({$0.tag == (index)}).first as? UIButton else { return }
        
        NSLayoutConstraint.activate([
            selectionView.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: selectedButton.centerYAnchor),
            selectionView.heightAnchor.constraint(equalTo: heightAnchor),
            selectionView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        for button in baseStackView.arrangedSubviews {
            if let button = button as? UIButton{
                if button.tag == selectedButton.tag {
                    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                } else {
                    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                }
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}


extension SegmentedControlView {
    public func setSegments (title1: String, title2: String) {
        
        let button1 = UIButton(type: .system)
        button1.tintColor = UIColor.black
        button1.setTitle(title1, for: .normal)
        button1.setTitleColor(UIColor.black, for: .normal)
        button1.tag = baseIndex + 0
        button1.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button1.backgroundColor = UIColor.clear
        button1.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.addArrangedSubview(button1)
        
        let button2 = UIButton(type: .system)
        button2.tintColor = UIColor.black
        button2.setTitle(title2, for: .normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.tag = baseIndex + 1
        button2.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button2.backgroundColor = UIColor.clear
        button2.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.addArrangedSubview(button2)
    }
    
    public func setSelectedIndex (index: Int) {
        setNewIndexUI(index: (index + baseIndex))
    }
}

