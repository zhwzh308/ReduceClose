//
//  ViewController.swift
//  ReduceClose
//
//  Created by Wenzhong Zhang on 2019-09-02.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import os.log
import UIKit

let log = OSLog(subsystem: "reduce", category: "app")

class ViewController: InputEnclosedViewController {
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = 1 / UIScreen.main.scale
            guard let font = textView.font else { return }
            let fixed = UIFont.monospacedDigitSystemFont(ofSize: font.pointSize, weight: .regular)
            textView.font = fixed
        }
    }
    @IBOutlet weak var deleteItem: UIBarButtonItem!
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.inputView = _inputView
        textView.inputAccessoryView = accessoryToolbar
    }
    @IBAction func keystrokeEnter(_ sender: UIButton) {
        guard let text = sender.title(for: .normal) else { return }
        textView.text.append(text)
        guard let newText = textView.text else { return }
        deleteItem.isEnabled = !newText.isEmpty
        let result = reducingInput(newText)
        os_log(.info, log: log, "%@", result.description)
    }
    @IBAction func clearTextView(_ sender: UIBarButtonItem) {
        textView.text = ""
    }
    @IBAction func deleteCharOnTextView(_ sender: UIBarButtonItem) {
        if textView.text.isEmpty {
            return
        }
        textView.text.removeLast()
    }
    @IBAction func textViewEndEditing(_ sender: UIBarButtonItem) {
        textView.resignFirstResponder()
    }
    private func reducingInput(_ input: String) -> Bool {
        let processed = preprocess(input)
        os_log(.debug, log: log, "Processed: %@", processed)
        let result = processed.reduce([ClosablePairs]()) {
            if let openning = ClosablePairs(rawValue: $1) {
                return $0 + [openning]
            }
            guard let last = $0.last else { return $0 }
            if last.canClose($1) {
                return $0.dropLast()
            } else {
                os_log(.error, log: log, "Error on current value %@ cannot close %@", $1.description, last.rawValue.description)
                return $0
            }
        }
        if result.isEmpty {
            os_log(.debug, log: log, "success")
            statusLabel.text = "Good"
            return true
        }
        statusLabel.text = "Bad"
        os_log(.debug, log: log, "Failed at depth %d with members hanging %@", result.count, result.map({$0.rawValue.description}).reduce("", +))
        return false
    }
    private func preprocess(_ string: String) -> String {
        return string.reduce("") {
            guard "{}[]<>()".contains($1) else {
                return $0
            }
            return $0 + String($1)
        }
    }
    private func test() {
        let inputs = [
            "[[)]",
            "[P{I{U}}g[][][]]",
            "{[[[]]][[]]}",
            "[[]]][",
            "[][][][[]][][<{}>]",
            "<[[]{[]}]",
            "<[[]{[]}]>"
        ]
        let results = inputs.map(reducingInput)
        os_log(.debug, log: log, "%@", results.description)
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        deleteItem.isEnabled = !text.isEmpty
        let result = reducingInput(text)
        os_log(.info, log: log, "%@", result.description)
    }
}
