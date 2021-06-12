

import UIKit
//import Reachability
//import FirebaseMessaging
//import Material
//import CoreLocation
////import SwifterSwift

class UtilityClass: NSObject
{
    
    // MARK:- Get IP address
    class func getIPAddressForCellOrWireless()-> String? {
        
        let WIFI_IF : [String] = ["en0"]
        let KNOWN_WIRED_IFS : [String] = ["en2", "en3", "en4"]
        let KNOWN_CELL_IFS : [String] = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
        
        var addresses : [String : String] = ["wireless":"",
                                             "wired":"",
                                             "cell":""]
        
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    let name: String = String(cString: (interface.ifa_name))
                    
                    if  (WIFI_IF.contains(name) || KNOWN_WIRED_IFS.contains(name) || KNOWN_CELL_IFS.contains(name)) {
                        
                        // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                        if WIFI_IF.contains(name){
                            addresses["wireless"] =  address
                        }else if KNOWN_WIRED_IFS.contains(name){
                            addresses["wired"] =  address
                        }else if KNOWN_CELL_IFS.contains(name){
                            addresses["cell"] =  address
                        }
                    }
                    
                }
            }
        }
        freeifaddrs(ifaddr)
        
        var ipAddressString : String? = ""
        let wirelessString = addresses["wireless"]
        let wiredString = addresses["wired"]
        let cellString = addresses["cell"]
        if let wirelessString = wirelessString, wirelessString.count > 0{
            ipAddressString = wirelessString
        }else if let wiredString = wiredString, wiredString.count > 0{
            ipAddressString = wiredString
        }else if let cellString = cellString, cellString.count > 0{
            ipAddressString = cellString
        }
        return ipAddressString
    }
    
    // MARK:- Check Internet
//    class func isInternetHasConnectivity() -> Bool {
//        
//        do {
//            let flag = try Reachability().isReachable
//            return flag
//        }catch{
//            return false
//            
//        }
//    }
    
    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK:- Get json from any object
    class func jsonString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    class func json(from string:String) -> NSDictionary? {
//        let string = "[{\"form_id\":3465,\"canonical_name\":\"df_SAWERQ\",\"form_name\":\"Activity 4 with Images\",\"form_desc\":null}]"
        
        var dictonary:NSDictionary = NSDictionary()
            
        if let data = string.data(using: String.Encoding.utf8){
                
             do {
                dictonary =  try (JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String:AnyObject] as NSDictionary?)!
                
                    if dictonary != nil
                      {
                          print("Dict:", dictonary)
                      }
                    } catch let error as NSError {
                    
                    print(error)
                 }
        }
        
        return dictonary
    }
    
    //MARK:- Get firebase token
//    class func getFirebaseToken() -> String
//    {
//        if let tokenStr = Messaging.messaging().fcmToken
//        {
//            return tokenStr
//        }
//        return ""
//    }
    
    //MARK:- setip Attributed string
    class func SetupAttributeString(MainText: String,Range : String, type: String, color: UIColor?, size: CGFloat, fontname : String? = "Poppins-Medium") -> NSAttributedString{
        let underlineAttriString = NSMutableAttributedString(string: MainText)
        let range1 = (MainText as NSString).range(of: Range)
        if type == "underline" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "font" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "underline" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        }else if type == "foreground color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "background color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.backgroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughColor, value: color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
        }
        return underlineAttriString
        
    }
    class func SetupAttributeString1(MainText: String,Range : String, type: String, color: UIColor?, size: CGFloat, fontname : String? = "Poppins-Regular") -> NSAttributedString{
        let underlineAttriString = NSMutableAttributedString(string: MainText)
        let range1 = (MainText as NSString).range(of: Range)
        if type == "underline" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "font" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "underline" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        }else if type == "foreground color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
        }
        else if type == "background color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.backgroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughColor, value: color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
        }
        return underlineAttriString
        
    }
    class  func createDottedLine(_ view: UIView,_ width: CGFloat, _ color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [3,4]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: view.frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        view.layer.addSublayer(caShapeLayer)
    }
    
    class  func createDottedLineVertical(_ view: UIView,_ width: CGFloat, _ color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [3,4]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: view.frame.height)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        view.layer.addSublayer(caShapeLayer)
    }
    
    //MARK:- Setup Material TextField
//    class func SetupTextField(_ textfield: TextField, _ name : String, textColor: UIColor, placeholderActiveColor : UIColor, dividerActiveColor: UIColor, dividerNormalColor : UIColor, placeholderNormalColor: UIColor)
//    {
//        textfield.placeholder = name
//        textfield.textColor =  textColor
//        textfield.isClearIconButtonEnabled = false
//        textfield.isPlaceholderUppercasedWhenEditing = false
//        textfield.placeholderAnimation = .default
//        textfield.placeholderActiveColor = placeholderActiveColor
//        textfield.dividerActiveColor = dividerActiveColor
//        textfield.dividerNormalColor = dividerNormalColor
//        textfield.dividerActiveHeight = 1.0
//        textfield.dividerNormalHeight = 1.0
//        textfield.detailColor = UIColor.red
//        textfield.detailLabel.font = UIFont.init(name: "Poppins-Regular", size: 10)
////        textfield.detailVerticalOffset = -0.5
//        textfield.placeholderVerticalOffset = 10
//        textfield.placeholderNormalColor = placeholderNormalColor
//        textfield.autocorrectionType = .no
//
//        textfield.placeholderLabel.font =  UIFont.init(name: "Poppins-Regular", size: 10)
//        textfield.font =  UIFont.init(name: "Poppins-Regular", size: 12)
////        if textfield.tag == 123{
////            textfield.placeholderLabel.font =  UIFont.init(name: "Poppins-Regular", size: 10)
////        }
//        textfield.minimumFontSize = 8
//
//        self.textFieldKerning(0.45, textfield)
//
//    }
    
 

    
    //MARK:- Open URL
    @available(iOS 10.0, *)
    class func openURL(_ str : String){
        guard let url = URL(string: str) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //MARK:- add shadow and radius to view
//    class func addshadowAndRadius(_ view1 : UIView, _ radius : CGFloat, shadowColor : UIColor){
//        view1.layer.cornerRadius = radius
//        view1.addShadow(ofColor: shadowColor, radius: 3.5, offset:CGSize(width: 0, height: 3), opacity: 0.5)
//    }
    
    
    //MARK:- add image with label text
    class func addImageOnLabel(_ img : String) -> NSAttributedString{
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named:img)
        let imageOffsetY: CGFloat = 0.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        return attachmentString
    }
 
    
    class func BasicSpringAnimation(_ view : UIView, _ duration : TimeInterval? = 1 ,_ delay : TimeInterval? = 0, _ dumping : CGFloat? = 0.5, _ valocity : CGFloat? = 5){
        UIView.animate(withDuration: duration!, delay: delay!, usingSpringWithDamping: dumping!, initialSpringVelocity: valocity!, options: .curveEaseInOut, animations: {
            view.layoutIfNeeded()
            
        })
    }
    
    
    
    //MARK:- Change imageview's image tint color
    class func changeImageviewColor(_ imgView:UIImageView, _ color: UIColor, _ image:UIImage)
    {
        imgView.image = image.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = color
    }
    
    //MARK:- Change button's image tint color
    class func changeButtonColor(_ button:UIButton, _ color: UIColor, _ image:UIImage)
    {
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = color
    }
    //MARK:- Add Kern on label text
    class func labelKerning(_ kern:CGFloat, _ label: UILabel){
        let attributes = [NSAttributedString.Key.kern: kern]
        let attributedString = NSAttributedString(string: label.text!, attributes: attributes)
        label.attributedText = attributedString
    }
    
    //MARK:- Add Kern on textfield text
    class func textFieldKerning(_ kern:CGFloat, _ textField: UITextField){
        textField.defaultTextAttributes.updateValue(kern,forKey: NSAttributedString.Key.kern)
    }
           
    //MARK:- Debug print
//    #if DEBUG
    class func myPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Swift.print(items[0], separator:separator, terminator: terminator)
    }
//    #endif

    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.font = font
        
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2 // change line spacing between paragraph like 36 or 48
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        // label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    //MARK:- Get app infor
   class func getAppInfo()->String {
           let dictionary = Bundle.main.infoDictionary!
           let version = dictionary["CFBundleShortVersionString"] as! String
           let build = dictionary["CFBundleVersion"] as! String
            print("version ",version)
            print("build ",build)
          // return version + "(" + build + ")"
            return build
       }
 
    
    //MARK:- Get Address from lat long
//    class func getAddressFromLatLon(_ pdblLatitude: String, _ pdblLongitude: String) -> String
//    {
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        //21.228124
//        let lon: Double = Double("\(pdblLongitude)")!
//        //72.833770
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = lat
//        center.longitude = lon
//
//
//
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//        var addressString : String = ""
//
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//                                    {(placemarks, error) in
//                                        if (error != nil)
//                                        {
//                                            print("reverse geodcode fail: \(error!.localizedDescription)")
//                                        }
//
//                                        if placemarks != nil{
//
//                                            let pm = placemarks! as [CLPlacemark]
//
//                                            if pm.count > 0 {
//                                                let pm = placemarks![0]
//                                                print(pm.country)
//                                                print(pm.locality)
//                                                print(pm.subLocality)
//                                                print(pm.thoroughfare)
//                                                print(pm.postalCode)
//                                                print(pm.subThoroughfare)
//
//                                                if pm.subLocality != nil {
//                                                    addressString = addressString + pm.subLocality! + ", "
//                                                }
//                                                if pm.thoroughfare != nil {
//                                                    addressString = addressString + pm.thoroughfare! + ", "
//                                                }
//                                                if pm.locality != nil {
//                                                    addressString = addressString + pm.locality! + ", "
//                                                }
//                                                if pm.country != nil {
//                                                    addressString = addressString + pm.country! + ", "
//                                                }
//                                                if pm.postalCode != nil {
//                                                    addressString = addressString + pm.postalCode! + " "
//                                                }
//
//                                                print(addressString)
//
//                                            }
//                                        }
//
//                                    })
//
//        return addressString
//
//    }
    
    class func buttonGrediant(button: UIButton, color1: UIColor, color2: UIColor, cornerRadius: CGFloat){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        button.layer.insertSublayer(gradientLayer, at: 0)
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
    }
    
}


