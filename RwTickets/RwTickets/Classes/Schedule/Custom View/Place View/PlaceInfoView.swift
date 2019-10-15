//
//  PlaceInfoView.swift
//  testParsing
//
//  Created by Kiryl Klimiankou on 10/4/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import UIKit

@IBDesignable
class PlaceInfoView: UIView {

    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeCostLabel: UILabel!
    @IBOutlet weak var vacantPlaceLabel: UILabel!
    var view: UIView!
    
    @IBInspectable var cost: Double = 0 {
        didSet {
            placeCostLabel.text = foramtCoast(cost)
        }
    }
    
    @IBInspectable var places: Int = 0 {
        didSet {
            let underlineAttribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
            vacantPlaceLabel.attributedText = NSAttributedString(string: String(places), attributes: underlineAttribute)
        }
    }
    
    @IBInspectable var placeType: String = "" {
        didSet {
            placeTypeLabel.text = placeType
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PlaceInfoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.fixInView(self)
    }
    
    private func foramtCoast(_ newValue: Double) -> String {
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(newValue * multiplier) / multiplier
        let textCoast = String(rounded)
        return textCoast.replacingOccurrences(of: ".", with: ",") + " руб"
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
