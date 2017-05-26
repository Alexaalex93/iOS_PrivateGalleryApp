//
//  MainCollectionViewController.swift
//  PrivGallery
//
//  Created by Alejandro Fernandez Gonzalez on 16/05/2017.
//  Copyright © 2017 Alejandro Fernandez Gonzalez. All rights reserved.
//
import UIKit
import Photos
import NohanaImagePicker
import ADMozaicCollectionViewLayout

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, NohanaImagePickerControllerDelegate, ADMozaikLayoutDelegate {


    
    @IBOutlet var selectButtonOut: UIBarButtonItem!
    var cellWidth: CGFloat = 128.0
    var selectionMode = false
    var boolSelection = [Bool] ()
    var assetArray = [PHAsset] ()
    var hiddenAssetArray = [PHAsset] ()
    
    @IBOutlet var longPressRecog: UILongPressGestureRecognizer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Private Gallery"

        getAssets()
        print("View did load" , assetArray)
//        createDirectory()
//        getImage() //Modificar para que lea a traves de PHAssets
//        
        let layout = ADMozaikLayout(delegate: self)
        self.collectionView?.collectionViewLayout = layout

        
        //        myBemCheckBox.onAnimationType = .bounce
        //        myBemCheckBox.offAnimationType = .bounce
        //
        //myBemCheckBox.setOn(true, animated: true)
        //elf.view.addSubview(myBemCheckBox)
        
        /* if(traitCollection.forceTouchCapability == .available){
         
         registerForPreviewing(with: self, sourceView: view)
         
         }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func importarImagen() {
        
        let picker = NohanaImagePickerController()
        picker.delegate = self
        picker.numberOfColumnsInPortrait = 3
        picker.toolbarHidden = true
        picker.maximumNumberOfSelection = 0
        picker.shouldShowMoment = false
        present(picker, animated: true)
    }
    
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts: [PHAsset]) {
        
        for i in 0...pickedAssts.count - 1 {
        
            hideImages(image: pickedAssts[i])
            
            if(assetArray.contains(pickedAssts[i])) {
                continue
            } else {
                assetArray.append(pickedAssts[i])
                boolSelection.append(false)
            }
        }
        
        
        self.collectionView?.reloadData()
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func getAssets() -> Void { //TODO hacer de manera asyncrona
        
        let allPhotosOption = PHFetchOptions()
        allPhotosOption.includeHiddenAssets = true
        
        let allPhotosResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: allPhotosOption)
    
        allPhotosResult.enumerateObjects({ (asset, index, stop) in
            if asset.isHidden {
                self.hiddenAssetArray.append(asset)
            }
        })
        
        assetArray = hiddenAssetArray
        
    }
    
    
    @IBAction func addPhoto(_ sender: Any) {
        importarImagen()
    }
    
    func hideImages(image: PHAsset) -> Void {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.init(for: image).isHidden = true
            
        }, completionHandler: { (success, error) in
            if !success { NSLog("error creating asset: \(String(describing: error))") }
        })
    }
    
    func unhideImages(image: PHAsset, index: Int, indexPath: IndexPath) -> Void {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.init(for: image).isHidden = false
            
        }, completionHandler: { (success, error) in
            if !success { NSLog("error creating asset: \(String(describing: error))") }
        })
        
        assetArray.remove(at: index)
        print("Remove: ", assetArray)

        self.collectionView?.deleteItems(at: [indexPath])
        self.collectionView?.reloadData()
        
    }

    func getImageAsset(asset: PHAsset) -> UIImage {
        
        let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.version = .current
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.resizeMode = .exact
        
        var image = UIImage()
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options, resultHandler: { (result, _: [AnyHashable : Any]?) -> Void in
            image = result!
        })
        return image
    }
    
//    func saveImageDocumentDirectory(assets: [PHAsset]){
//        let fileManager = FileManager.default
//        
//        for asset in assets {
//            
//            var resources = PHAssetResource.assetResources(for: asset)
//            print("Resources: " , resources[0].originalFilename)
//            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(resources[0].originalFilename)
//
//            let image = getImageAsset(asset: asset)
//            let imageData = UIImageJPEGRepresentation(image, 0.5)
//            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
//         
//            print(paths)
//        }
//    }
//    
//    func getDirectoryPath() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//    
//    
//    func getImage(){ //TODO Añadir mas extensiones
//        
//        // Get the document directory url
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        var jpgFilesNames = [String] ()
//        do {
//            // Get the directory contents urls (including subfolders urls)
//            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
//            
//            let jpgFiles = directoryContents.filter{ $0.pathExtension == "JPG" }
//            jpgFilesNames = jpgFiles.map{ $0.lastPathComponent }
//            print("JPG list:", jpgFilesNames)
//            
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        
//
//        let fileManager = FileManager.default
//        for fileName in jpgFilesNames {
//            
//            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(fileName)
//        
//            if fileManager.fileExists(atPath: imagePAth){
//                print(imagePAth)
//              //  self.imageView.image = UIImage(contentsOfFile: imagePAth)
//            } else {
//                print("No Image")
//            }
//        }
//    }
//    
//    func createDirectory(){
//        let fileManager = FileManager.default
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("privateGalleryDirectory")
//        if !fileManager.fileExists(atPath: paths) {
//            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
//        } else {
//            print("Already directory created.")
//        }
//    }
//    
//    
//    func deleteDirectory(){
//        let fileManager = FileManager.default
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("privateGalleryDirectory")
//        if fileManager.fileExists(atPath: paths){
//            try! fileManager.removeItem(atPath: paths)
//        } else {
//            print("Something wrong.")
//        }
//    }
    
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            selectionMode = true
            
            
            let pressureRecog = longPressRecog.location(in: self.collectionView)
            if let indexPath : NSIndexPath = (self.collectionView?.indexPathForItem(at: pressureRecog))! as NSIndexPath?{
                _ = collectionView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CellCollectionViewCell

                //do whatever you need to do
                // ############################################
                print(indexPath)
                print(indexPath.row)
                unhideImages(image: assetArray[indexPath.row], index: indexPath.row, indexPath: indexPath as IndexPath)
               
                
                //longPressDone = false
                //imageIndexInLongPress = indexPath.row
                //performSegue(withIdentifier: "showImage", sender: self)
            }
            // ############################################
            print("LongTapEnded")
        }
    }
    

    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return assetArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellCollectionViewCell
        if (assetArray.count != 0) {
            
            let retinaMultiplier = UIScreen.main.scale
            
            var size = CGSize()
            
                if indexPath.item == 0 {
                    size = CGSize(width: 93 * retinaMultiplier, height: 93 * retinaMultiplier)
                }
                if indexPath.item % 8 == 0 {
                    size = CGSize(width: 93 * 2 * retinaMultiplier, height: 93 * 2 * retinaMultiplier)

                }
                else if indexPath.item % 6 == 0 {
                    
                    size = CGSize(width: 93 * 3 * retinaMultiplier, height: 93 * retinaMultiplier)

                }
                else if indexPath.item % 4 == 0 {
                    size = CGSize(width: 93 * retinaMultiplier, height: 93 * 3 * retinaMultiplier)
                }
                else {
                    size = CGSize(width: 93 * retinaMultiplier, height: 93 * retinaMultiplier)

                }

            let options = PHImageRequestOptions()

            options.isSynchronous = true
            options.version = .current
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            options.resizeMode = .exact

            PHImageManager.default().requestImage(for: assetArray[indexPath.row], targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { (result, _:[AnyHashable : Any]?) in
                cell.imageCell.image = result
            })
        }
        return cell
    }
    

    
    
    /// Method should return `ADMozaikLayoutSectionGeometryInfo` to describe specific section's geometry
    ///
    /// - Parameters:
    ///   - collectionView: collection view is using layout
    ///   - layoyt:         layout itself
    ///   - section:        section to calculate geometry info for
    ///
    /// - Returns: `ADMozaikLayoutSectionGeometryInfo` struct object describes the section's geometry
    func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo {
        let rowHeight: CGFloat = 93
        let columns = [ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93)]
        let geometryInfo = ADMozaikLayoutSectionGeometryInfo(rowHeight: rowHeight,
                                                             columns: columns,
                                                             minimumInteritemSpacing: 1,
                                                             minimumLineSpacing: 1,
                                                             sectionInset: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0),
                                                             headerHeight: 0, footerHeight: 0)
        return geometryInfo
    }
    
    
    
    /// Method should return `ADMozaikLayoutSize` for specific indexPath
    ///
    /// - Parameter collectionView: collection view is using layout
    /// - Parameter layout:         layout itself
    /// - Parameter indexPath:      indexPath of item for the size it asks for
    ///
    /// - Returns: `ADMozaikLayoutSize` struct object describes the size
    func collectionView(_ collectionView: UICollectionView, mozaik layout: ADMozaikLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize {
        if indexPath.item == 0 {
            return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1)
        }
        if indexPath.item % 8 == 0 {
            return ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2)
        }
        else if indexPath.item % 6 == 0 {
            return ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 1)
        }
        else if indexPath.item % 4 == 0 {
            return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 3)
        }
        else {
            return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1)
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if (selectionMode) {
            
            let cell = collectionView.cellForItem(at: indexPath)
            let centerCell = cell?.center
            
            UIView.animate(withDuration: 0.3, animations: {
                cell?.transform = CGAffineTransform.identity
                cell?.center = centerCell!

            })

            boolSelection[indexPath.row] = boolSelection[indexPath.row] ? false : true
            print(boolSelection)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(selectionMode) {
            let cell = collectionView.cellForItem(at: indexPath)
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellCollectionViewCell
            let centerCell = cell?.center
            
            if cell?.frame.size.width == cellWidth {
                
                UIView.animate(withDuration: 0.3, animations: {
                    cell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    cell?.center = centerCell!
                })

                //myBemCheckBox.setOn(true, animated: true)
                //        //let pressureRecog = longPressRecog.location(in: self.collectionView)
                //        let pressureRecog = longPressRecog.location(in: self.collectionView)
                //
                //        if let indexPath : NSIndexPath = (self.collectionView?.indexPathForItem(at: pressureRecog))! as NSIndexPath?{
                //            //do whatever you need to do
                //
                //            let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ElementCollectionViewCell
                //            print("pressureRecog: \(pressureRecog), indexPath:  \(indexPath)")
                //            boolSelection[indexPath.row] = boolSelection[indexPath.row] ? false : true
                //print("Long press en \(indexPath.row)")
                //print("Minx: \(cell.frame.midX) miny \(cell.frame.minY)")
                //let checkbox = M13Checkbox(frame: CGRect(x: cell.frame.maxX - 50, y: cell.frame.maxY + 10 , width: 40.0, height: 40.0))
                boolSelection[indexPath.row] = boolSelection[indexPath.row] ? false : true
                print(boolSelection)
                
            }
        }
    }
    
    @IBAction func selectButton(_ sender: Any) {
        
        selectionMode = selectionMode ? false : true

        if(selectionMode) {
            selectButtonOut.title = "Done"
            selectButtonOut.style = .done
            collectionView?.allowsMultipleSelection = true
        } else {
            selectButtonOut.title = "Select"
            selectButtonOut.style = .plain
            collectionView?.allowsMultipleSelection = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if !selectionMode {
            if segue.identifier == "toDetailView" {
                if let indexPaths = collectionView?.indexPathsForSelectedItems {
                    let destinationController = segue.destination as! DetailViewController
                    destinationController.asset = assetArray[indexPaths[0].row]
                    collectionView?.deselectItem(at: indexPaths[0], animated: true)
                }
            }
        //}
    }
    /*
     ////////////////////////////////////
     //TOUCH3D
     //PopUp set up
     
     func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
     
     guard let indexPath = collectionView?.indexPathForItem(at: location) else { return nil }
     
     guard let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
     
     guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController else { return nil }
     
     
     let photo = imageStr[indexPath.row]
     
     detailVC.strImageDetail = photo
     
     detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
     
     previewingContext.sourceRect = cell.frame
     
     return detailVC
     }
     
     func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
     
     let detailVC = storyboard?.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController
     show(detailVC!, sender: self)
     
     
     }
     //FIN TOUCH3D
     ////////////////////////////////////
     */
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
