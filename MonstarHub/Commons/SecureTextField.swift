//
//  SecureTextField.swift
//  MonstarHub
//
//  Created by Rokon on 2/4/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

class SecureTextField: TextField {

    // public Outlets

    public var secureViewShowMode: UITextField.ViewMode = .whileEditing {
        didSet {
            secureTextfieldMode = secureViewShowMode
        }
    }

    // Storage Vars
    private var secureImage : (show: UIImage?, hide: UIImage?) = (R.image.icon_textfield_show_password(), R.image.icon_textfield_hide_password())
    private var secureTitle : (show: String?, hide: String?) = ("Show", "Hide")

    private var secureButton: UIButton = UIButton(frame: .zero)
    private var secureTextfieldMode: UITextField.ViewMode = .always
    private var showHideMode: SecureViewMode = .image

    public enum SecureViewMode {
        case image
        case text
    }

    init() {
        super.init(frame: .zero)
        isSecureTextEntry = true
        validate()
        addShowHideButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        validate()
        addShowHideButton()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        validate()
        addShowHideButton()
    }

    fileprivate func addShowHideButton() {

        let height = self.frame.size.height
        let frame = CGRect(x: 0, y: 0, width: 0, height: height)

        secureButton.frame = frame
        secureButton.backgroundColor = .clear

        if showHideMode == .image {
            secureButton.setImage(secureImage.show, for: UIControl.State())
            secureButton.sizeToFit()
            secureButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        } else {
            secureButton.setTitle(secureTitle.show, for: UIControl.State())
            secureButton.sizeToFit()
            secureButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }

        secureButton.addTarget(self, action: #selector(toggleShowPassword(_:)), for: UIControl.Event.touchUpInside)

        self.rightViewMode = secureTextfieldMode
        self.rightView = secureButton

    }

    // MARK: - Handlers

    @objc private func toggleShowPassword(_ sender: AnyObject) {

        let wasFirstResponder = false

        if wasFirstResponder == self.isFirstResponder {

            self.resignFirstResponder()

        }

        self.isSecureTextEntry = !self.isSecureTextEntry

        self.applySwitchingWithAnimation()

    }

    override public func becomeFirstResponder() -> Bool {

        let returnValue = super.becomeFirstResponder()

        if returnValue {
            self.applySwitchingWithAnimation()
        }

        return returnValue
    }

    private func applySwitchingWithAnimation() {

        secureButton.alpha = 0.5
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {

            self.secureButton.alpha = 1

            if self.isSecureTextEntry {
                self.showHideMode == .image ? self.secureButton.setImage(self.secureImage.show, for: UIControl.State()) : self.secureButton.setTitle(self.secureTitle.show, for: UIControl.State())
            } else {
                self.showHideMode == .image ? self.secureButton.setImage(self.secureImage.hide, for: UIControl.State()): self.secureButton.setTitle(self.secureTitle.hide, for: UIControl.State())
                self.resetTextFont()
            }

        }, completion: nil)

    }

    private func resetTextFont() {
        self.attributedText = NSAttributedString(string: self.text!)
    }

    /// will validate that user has entered the values correctly to avoid unwanted crashes.
    private func validate() {

        if self.showHideMode == .image {
            if self.secureImage.show == nil || self.secureImage.hide == nil { assert(false, "Provide a valid image for display for both show and hide, then try again :)") }
        } else {
            if self.secureTitle.show == nil || self.secureTitle.hide == nil { assert(false, "Provide a valid text for display for both show and hide, then try again :)") }
        }
    }

}
