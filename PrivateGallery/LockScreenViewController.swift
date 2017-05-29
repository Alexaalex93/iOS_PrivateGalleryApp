//
//  LockScreenViewController.swift
//  PrivateGallery
//
//  Created by Alejandro Fernandez Gonzalez on 27/05/2017.
//  Copyright © 2017 Alejandro Fernandez Gonzalez. All rights reserved.
//

import UIKit
import DKCircleButton

class LockScreenViewController: UIViewController {

    var cgRectArray = [CGRect] ()
    var x = 50
    var y = 252
    var xc = 100
    var yc = 100
    var arrayNums = [Int]()
    var pass = ""
    var passdefs = String()
    var shapeLayer1 = CAShapeLayer()
    var shapeLayer2 = CAShapeLayer()
    var shapeLayer3 = CAShapeLayer()
    var shapeLayer4 = CAShapeLayer()
    var circlePath = UIBezierPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        defaults.set("1234", forKey: "password")
        passdefs = defaults.object(forKey: "password") as? String ?? String()
        
        randomNums()
        drawCircles()
        generateCGRects()
        generateButtons()
    }
    
    func randomNums() -> Void {
        repeat {
            let num = Int(arc4random_uniform(UInt32(10)))
            if (arrayNums.contains(num)) {
                continue
            }
            arrayNums.append(num)
        } while (arrayNums.count != 10)
    }
    
    func drawCircles() -> Void {
        for i in 1...4 {
            if i == 1 {
                circlePath = UIBezierPath(arcCenter: CGPoint(x: xc,y: yc), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                shapeLayer1.path = circlePath.cgPath
                shapeLayer1.fillColor = UIColor.clear.cgColor
                shapeLayer1.strokeColor = UIColor.red.cgColor
                shapeLayer1.lineWidth = 3.0
                shapeLayer1.isHidden = true
                view.layer.addSublayer(shapeLayer1)

            } else if i == 2 {
                xc += 55
                circlePath = UIBezierPath(arcCenter: CGPoint(x: xc,y: yc), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                shapeLayer2.path = circlePath.cgPath
                shapeLayer2.fillColor = UIColor.clear.cgColor
                shapeLayer2.strokeColor = UIColor.red.cgColor
                shapeLayer2.lineWidth = 3.0
                shapeLayer2.isHidden = true
                view.layer.addSublayer(shapeLayer2)

            } else if i == 3 {
                xc += 55
                circlePath = UIBezierPath(arcCenter: CGPoint(x: xc,y: yc), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                shapeLayer3.path = circlePath.cgPath
                shapeLayer3.fillColor = UIColor.clear.cgColor
                shapeLayer3.strokeColor = UIColor.red.cgColor
                shapeLayer3.lineWidth = 3.0
                shapeLayer3.isHidden = true
                view.layer.addSublayer(shapeLayer3)

            } else if i == 4 {
                xc += 55
                circlePath = UIBezierPath(arcCenter: CGPoint(x: xc,y: yc), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                shapeLayer4.path = circlePath.cgPath
                shapeLayer4.fillColor = UIColor.clear.cgColor
                shapeLayer4.strokeColor = UIColor.red.cgColor
                shapeLayer4.lineWidth = 3.0
                shapeLayer4.isHidden = true
                view.layer.addSublayer(shapeLayer4)

            }
        }
    }
    
    
    func thumbsUpButtonPressed(sender: UIButton) {
        
        if pass.isEmpty {
            shapeLayer1.isHidden = true
            shapeLayer2.isHidden = true
            shapeLayer3.isHidden = true
            shapeLayer4.isHidden = true
        }
        pass.append(String(sender.tag))

        if(pass.characters.count == 1) {
            shapeLayer1.isHidden = false
        } else if(pass.characters.count == 2){
            shapeLayer2.isHidden = false
        } else if(pass.characters.count == 3){
            shapeLayer3.isHidden = false
        } else if(pass.characters.count == 4){
            shapeLayer4.isHidden = false

        }
        if pass.characters.count == 4 && pass == passdefs {
            print("Result OK")
            shapeLayer1.isHidden = true
            shapeLayer2.isHidden = true
            shapeLayer3.isHidden = true
            shapeLayer4.isHidden = true
        } else if pass.characters.count == 4 && pass != passdefs {
            pass = ""

        }
        print(pass)
        print("Boton:" , sender.tag)
    }

    func generateCGRects() -> Void {
        for i in 0...9 {
            if( i == 9) {
                x = 150
                y = 552
            } else if( i % 3 == 0 && i != 0) {
                x = 50
                y += 100
            } else if (i != 0){
                x += 100
            }
            let coord = CGRect(x: x, y: y, width: 75, height: 75)
            cgRectArray.append(coord)
        }
    }
    
    
    func generateButtons() -> Void {
        
        let button1 = DKCircleButton.init(frame: cgRectArray[arrayNums[0]])
        
        
        button1.setTitle("1", for: .normal)
        button1.setTitleColor(UIColor.black, for: .normal)
        button1.borderColor = UIColor.black
        button1.tag = 1
        button1.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button1)
        
        let button2 = DKCircleButton.init(frame: cgRectArray[arrayNums[1]])
        
        
        button2.setTitle("2", for: .normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.borderColor = UIColor.black
        button2.tag = 2
        button2.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button2)

        let button3 = DKCircleButton.init(frame: cgRectArray[arrayNums[2]])
        
        
        button3.setTitle("3", for: .normal)
        button3.setTitleColor(UIColor.black, for: .normal)
        button3.borderColor = UIColor.black
        button3.tag = 3
        button3.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button3)

        let button4 = DKCircleButton.init(frame: cgRectArray[arrayNums[3]])
        
        
        button4.setTitle("4", for: .normal)
        button4.setTitleColor(UIColor.black, for: .normal)
        button4.borderColor = UIColor.black
        button4.tag = 4
        button4.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button4)

        let button5 = DKCircleButton.init(frame:cgRectArray[arrayNums[4]])
        
        
        button5.setTitle("5", for: .normal)
        button5.setTitleColor(UIColor.black, for: .normal)
        button5.borderColor = UIColor.black
        button5.tag = 5
        button5.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button5)

        let button6 = DKCircleButton.init(frame: cgRectArray[arrayNums[5]])
        
        
        button6.setTitle("6", for: .normal)
        button6.setTitleColor(UIColor.black, for: .normal)
        button6.borderColor = UIColor.black
        button6.tag = 6
        button6.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button6)

        let button7 = DKCircleButton.init(frame: cgRectArray[arrayNums[6]])
        
        
        button7.setTitle("7", for: .normal)
        button7.setTitleColor(UIColor.black, for: .normal)
        button7.borderColor = UIColor.black
        button7.tag = 7
        button7.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button7)

        let button8 = DKCircleButton.init(frame: cgRectArray[arrayNums[7]])
        
        
        button8.setTitle("8", for: .normal)
        button8.setTitleColor(UIColor.black, for: .normal)
        button8.borderColor = UIColor.black
        button8.tag = 8
        button8.addTarget(self, action:  #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button8)

        let button9 = DKCircleButton.init(frame: cgRectArray[arrayNums[8]])
        
        
        button9.setTitle("9", for: .normal)
        button9.setTitleColor(UIColor.black, for: .normal)
        button9.borderColor = UIColor.black
        button9.tag = 9
        button9.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button9)

        let button0 = DKCircleButton.init(frame: cgRectArray[arrayNums[9]])
        
        
        button0.setTitle("0", for: .normal)
        button0.setTitleColor(UIColor.black, for: .normal)
        button0.borderColor = UIColor.black
        button0.tag = 0
        button0.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button0)

        let fingerprintButton = DKCircleButton.init(frame: CGRect(x: 250, y: 542, width: 75, height: 75))
        
        fingerprintButton.imageView?.contentMode = .scaleAspectFit
        fingerprintButton.setImage(UIImage(named: "fingerprint"), for: .normal)
        fingerprintButton.setTitleColor(UIColor.black, for: .normal)
        fingerprintButton.borderColor = UIColor.black
        fingerprintButton.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(fingerprintButton)

       

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
