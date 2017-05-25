//
//  DetailViewController.swift
//  PrivateGallery
//
//  Created by Alejandro Fernandez Gonzalez on 19/05/2017.
//  Copyright © 2017 Alejandro Fernandez Gonzalez. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController {

    @IBOutlet var imageDetail: UIImageView!
    var asset: PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImageAsset(asset: asset)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func getImageAsset(asset: PHAsset) -> Void {
      
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth = screenRect.width
        let screenHeight = screenRect.height;
        
        let retinaMultiplier = UIScreen.main.scale
        let size = CGSize(width:screenWidth * retinaMultiplier, height:  screenHeight * retinaMultiplier)
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.version = .current
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.resizeMode = .exact
        
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options, resultHandler: { (result, _: [AnyHashable : Any]?) -> Void in
            self.imageDetail.image = result

        })
        
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
