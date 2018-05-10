//
//  Keyboard Componenets.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit



class KeyboardRow: BaseStackView {
    
    override func setupViews() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 1.5
    }
    
}

class MasterKeyboardStackView: BaseStackView {
    
    var rows = [KeyboardRow]()
    
    override func setupViews() {
        axis = .vertical
        distribution = .fillEqually
        spacing = 1.5
    }
    
    convenience init(rows: KeyboardRow... ) {
        self.init()
        rows.forEach({ addArrangedSubview($0) })
        self.rows = rows 
    }
    
    func appendButton(_ button: UIButton, toRow: Int) {
        if rows.indices.contains(toRow) {
            rows[toRow].addArrangedSubview(button)
        }
    }
    
    
}



public class KeyboardButton: ButtonWithAction {
    
    var primaryBackgroundColor: UIColor = UIColor.init(white: 1, alpha: 0.94)
    
    var secondaryBackgroundColor: UIColor = UIColor.init(white: 1, alpha: 0.64)
    
    var isPrimaryColor = true {
        didSet {
            //switch primary and secondary colors if btn is secondary color
            if isPrimaryColor == false {
                secondaryBackgroundColor = UIColor.init(white: 1, alpha: 0.94)
                primaryBackgroundColor = UIColor.init(white: 1, alpha: 0.64)
                backgroundColor = primaryBackgroundColor
            }
        }
    }
    
    override init(btnTap: (() -> Void)? ) {
        super.init(btnTap: btnTap)
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        backgroundColor = UIColor.init(white: 1, alpha: 0.94)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? secondaryBackgroundColor : primaryBackgroundColor
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            let titleC = isEnabled ? UIColor.black : UIColor.lightGray
            setTitleColor(titleC, for: .normal)
        }
    }
    
}

protocol DoneButtonDelegate {
    var doneBtnTap: (() -> Void)? { get }
}

class KeyboardDoneButton: UIButton {
    
    let delegate: DoneButtonDelegate
    
    init(delegate: DoneButtonDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setTitle("Done", for: .normal)
        backgroundColor = UIColor.clear
        setTitleColor(UIColor.white, for: .normal)
        addTarget(self, action: #selector(btnTapped), for: .touchDown)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnTapped() {
        delegate.doneBtnTap?()
    }
    
    override open var isHighlighted: Bool {
        didSet {
            //backgroundColor = isHighlighted ? UIColor.black : UIColor.lightGray
        }
    }
    
}



