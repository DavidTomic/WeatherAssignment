//  A set of convenience methods that lets you set object properties with chaining
//
//  e.g. Usage
//  lblTitle = UILabel()
//     .style(numberOfLines: 0)
//     .style(parent: viewHeader)

// swiftlint:disable file_length

import UIKit
import SnapKit

public enum StyleOrientation {
    case top
    case bottom
    case left
    case right
}

// SnapKit extensions 😎 like a boss
extension UIView {
    @discardableResult public func styleMakeConstraints(_ closure: (_ make: SnapKit.ConstraintMaker) -> Void) -> Self {
        snp.makeConstraints(closure)
        return self
    }
}

extension UIView {
    /**
     Adds self as a subview of parent: UIView
     
     Method will call parent.addSubview(self). If parent is a UIStackView it will call stackView.addArrangedSubview(self)
     */
    @discardableResult public func style(parentView: UIView) -> Self {
        if let stackView = parentView as? UIStackView {
            stackView.addArrangedSubview(self)
        } else {
            parentView.addSubview(self)
        }
        return self
    }
    
    @discardableResult public func style(backgroundColor: UIColor?) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult public func style(contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    @discardableResult public func style(contentHuggingPriority: UILayoutPriority, forAxis axis: NSLayoutConstraint.Axis) -> Self {
        setContentHuggingPriority(contentHuggingPriority, for: axis)
        return self
    }
    
    @discardableResult public func style(contentCompressionResistancePriority: UILayoutPriority, forAxis axis: NSLayoutConstraint.Axis) -> Self {
        setContentCompressionResistancePriority(contentCompressionResistancePriority, for: axis)
        return self
    }
    
    @discardableResult public func style(addGestureRecognizer gestureRecognizer: UIGestureRecognizer) -> Self {
        addGestureRecognizer(gestureRecognizer)
        return self
    }
    
    @discardableResult public func style(isHidden: Bool) -> Self {
        if self.isHidden != isHidden {
            self.isHidden = isHidden
        }
        return self
    }
    
    @discardableResult public func style(tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    @discardableResult public func style(tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }
    
    @discardableResult public func style(isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    @discardableResult public func style(alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult public func style(isOpaque: Bool) -> Self {
        self.isOpaque = isOpaque
        return self
    }
    
    @discardableResult public func style(center: CGPoint) -> Self {
        self.center = center
        return self
    }
    
    @discardableResult public func style(frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    @discardableResult public func style(bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    
    @discardableResult public func style(layoutMargins: UIEdgeInsets) -> Self {
        self.layoutMargins = layoutMargins
        return self
    }
    
    @discardableResult public func style(clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }
    
    @discardableResult public func style(translatesAutoresizingMaskIntoConstraints: Bool) -> Self { // swiftlint:disable:this identifier_name
        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        return self
    }
    
    @discardableResult public func style(cornersRadius: CGFloat?, orientation: StyleOrientation) -> Self {
        let cornerRadius = cornersRadius ?? 10.0
        
        if #available(iOS 11.0, *) {
            self.layer.style(radius: cornerRadius)
            self.clipsToBounds = true
            
            switch orientation {
            case .top: self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .bottom: self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .left: self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            case .right: self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
        } else {
            var roundingCorners: UIRectCorner
            
            switch orientation {
            case .top: roundingCorners = [.topLeft, .topRight]
            case .bottom: roundingCorners = [.bottomLeft, .bottomRight]
            case .left: roundingCorners = [.topLeft, .bottomLeft]
            case .right: roundingCorners = [.topRight, .bottomRight]
            }
            
            let maskPath = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners: roundingCorners,
                                        cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            self.layer.mask = shape
        }
        return self
    }
    
}

extension CALayer {
    @discardableResult public func style(radius: CGFloat) -> Self {
        self.cornerRadius = radius
        return self
    }
    
    @discardableResult public func style(borderWidth: CGFloat) -> Self {
        self.borderWidth = borderWidth
        return self
    }
    
    @discardableResult public func style(borderColor: UIColor) -> Self {
        self.borderColor = borderColor.cgColor
        return self
    }
}

extension UIStackView {
    @discardableResult public func style(spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
    
    @discardableResult public func style(axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    
    @discardableResult public func style(alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    
    @discardableResult public func style(distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    @discardableResult public func style(isLayoutMarginsRelativeArrangement: Bool) -> Self {
        self.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
        return self
    }
}

extension UIControl {
    @discardableResult public func style(target: AnyObject?, action: Selector, controlEvents: UIControl.Event = .touchUpInside) -> Self {
        addTarget(target, action: action, for: controlEvents)
        return self
    }
}

extension UIButton {
    
    @discardableResult public func style(image: UIImage?, for controlState: UIControl.State = .normal) -> Self {
        setImage(image, for: controlState)
        return self
    }
    
    @discardableResult public func style(contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }
    
    @discardableResult public func style(titleColor: UIColor?, for controlState: UIControl.State = .normal) -> Self {
        setTitleColor(titleColor, for: controlState)
        return self
    }
    
    @discardableResult public func style(numberOfLines: Int) -> Self {
        titleLabel?.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult public func style(font: UIFont?, spacing: Float? = nil) -> Self {
        titleLabel?.font = font
        
        if let title = title(for: .normal), let spacing = spacing {
            let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.kern: spacing])
            self.setAttributedTitle(attributedTitle, for: .normal)
        }
        
        return self
    }
    
    @discardableResult public func style(contentEdgeInsets: UIEdgeInsets) -> Self {
        self.contentEdgeInsets = contentEdgeInsets
        return self
    }
    
    @discardableResult public func style(imageEdgeInsets: UIEdgeInsets) -> Self {
        self.imageEdgeInsets = imageEdgeInsets
        return self
    }
    
    @discardableResult public func style(titleEdgeInsets: UIEdgeInsets) -> Self {
        self.titleEdgeInsets = titleEdgeInsets
        return self
    }
    
    @discardableResult public func style(isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult public func style(title: String?, for controlState: UIControl.State = .normal) -> Self {
        setTitle(title, for: controlState)
        return self
    }
}

extension UILabel {
    @discardableResult public func style(text: String?) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult public func style(attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }
    
    @discardableResult public func style(numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult public func style(textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult public func style(baselineAdjustment: UIBaselineAdjustment) -> Self {
        self.baselineAdjustment = baselineAdjustment
        return self
    }
    
    @discardableResult public func style(font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult public func style(adjustsFontSizeToFitWidth: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    @discardableResult public func style(minimumScaleFactor: CGFloat) -> Self {
        self.minimumScaleFactor = minimumScaleFactor
        return self
    }
    
    @discardableResult public func style(textColor: UIColor?) -> Self {
        self.textColor = textColor
        return self
    }
}

extension UITextField {
    @discardableResult public func style(text: String?) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult public func style(placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult public func style(textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult public func style(inputAccessoryView: UIView?) -> Self {
        self.inputAccessoryView = inputAccessoryView
        return self
    }
    
    @discardableResult public func style(font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult public func style(textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    @discardableResult public func style(isSecureTextEntry: Bool) -> Self {
        self.isSecureTextEntry = isSecureTextEntry
        return self
    }
    
    @discardableResult public func style(keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }
    
    @discardableResult public func style(delegate: UITextFieldDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
}

extension UIScrollView {
    @discardableResult public func style(isPagingEnabled: Bool) -> Self {
        self.isPagingEnabled = isPagingEnabled
        return self
    }
    
    @discardableResult public func style(showsHorizontalScrollIndicator: Bool) -> Self {
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        return self
    }
    
    @discardableResult public func style(showsVerticalScrollIndicator: Bool) -> Self {
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return self
    }
    
    @discardableResult public func style(bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }
    
    @discardableResult public func style(isScrollEnabled: Bool) -> Self {
        self.isScrollEnabled = isScrollEnabled
        return self
    }
    
    @discardableResult public func style(delegate: UIScrollViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
}

extension UIImageView {
    @discardableResult public func style(image: UIImage?) -> Self {
        self.image = image
        return self
    }
}
