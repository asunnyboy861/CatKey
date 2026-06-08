import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {
    private var hostingController: UIHostingController<CatKeyKeyboardView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightMultiplier = AppConstants.KeyboardHeight(
            rawValue: UserDefaults.appGroup.keyboardHeight
        )?.heightMultiplier ?? 1.0
        
        let baseHeight: CGFloat = 260
        let desiredHeight = baseHeight * heightMultiplier
        
        if hostingController?.view.frame.height != desiredHeight {
            hostingController?.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: desiredHeight)
        }
    }
    
    private func setupKeyboard() {
        let keyboardView = CatKeyKeyboardView(
            proxy: textDocumentProxy,
            onSwitchKeyboard: { [weak self] in
                self?.advanceToNextInputMode()
            }
        )
        
        let hosting = UIHostingController(rootView: keyboardView)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.view.backgroundColor = .clear
        
        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        hostingController = hosting
        
        if needsInputModeSwitchKey {
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        super.textWillChange(textInput)
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
    }
}
