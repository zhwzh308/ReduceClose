//
//  InputEnclosedViewController.swift
//  ReduceClose
//
//  Created by Wenzhong Zhang on 2019-09-02.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import UIKit

class InputEnclosedViewController: UIViewController {
    @IBOutlet public weak var controlContentView: UIView! {
        didSet {
            guard
                let stackView = controlContentView
                else {
                    return
            }
            customInputView.addSubview(stackView)
            let guide = customInputView.layoutMarginsGuide
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                stackView.topAnchor.constraint(equalTo: guide.topAnchor),
                guide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
                guide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
                ])
        }
    }
    @IBOutlet public weak var accessoryToolbar: UIToolbar!
    public var customInputView: UIInputView { return _inputView }
    public var firstResponderRequested: Bool = false {
        didSet {
            let capture = firstResponderRequested
            if oldValue == capture {
                return
            }
            controlContentView.isUserInteractionEnabled = capture
            if capture {
                becomeFirstResponder()
            } else {
                resignFirstResponder()
            }
        }
    }
    let _inputView: UIInputView = {
        let iv = KeyboardClickEnabledInputView(frame: .zero, inputViewStyle: .keyboard)
        iv.backgroundColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.allowsSelfSizing = true
        return iv
    }()
    override var inputAccessoryView: UIView? {
        return accessoryToolbar
    }
    open func collapse() {
        firstResponderRequested = false
    }
    open func expand() {
        firstResponderRequested = true
    }
    @IBAction open func selectionTouchedDown(_ sender: UIButton) {
        UIDevice.current.playInputClick()
    }
}
