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

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, NohanaImagePickerControllerDelegate {
    
    @IBOutlet var selectButtonOut: UIBarButtonItem!
    var cellWidth: CGFloat = 128.0
    var selectionMode = false
    var boolSelection = [Bool] ()
    var assetArray = [PHAsset] ()
    
    @IBOutlet var longPressRecog: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Private Gallery"
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
        present(picker, animated: true)
    }
    
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts: [PHAsset]) {
        
        for i in 0...pickedAssts.count - 1 {
            
            if(assetArray.contains(pickedAssts[i]))
            {
                continue
            } else {
                assetArray.append(pickedAssts[i])
                boolSelection.append(false)
            }
        }
        
        print(boolSelection)
        print(assetArray)
        
        self.collectionView?.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func addPhoto(_ sender: Any) {
        importarImagen()
    }
    
//    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
//        if sender.state == .began {
//            selectionMode = true
//            
//            
//            let pressureRecog = longPressRecog.location(in: self.collectionView)
//            if let indexPath : NSIndexPath = (self.collectionView?.indexPathForItem(at: pressureRecog))! as NSIndexPath?{
//                
//                
//                let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CellCollectionViewCell
//
//                //do whatever you need to do
//                // ############################################
//                print(indexPath)
//                print(indexPath.row)
//               
//                
//                //longPressDone = false
//                //imageIndexInLongPress = indexPath.row
//                //performSegue(withIdentifier: "showImage", sender: self)
//            }
//            // ############################################
//            print("LongTapEnded")
//        }
//    }
//    

    

    
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
            
            let size = CGSize(width: 128, height: 128)
            
            let options = PHImageRequestOptions()

            options.isSynchronous = true
            options.version = .current
            options.deliveryMode = .fastFormat
            options.resizeMode = .exact

            PHImageManager.default().requestImage(for: assetArray[indexPath.row], targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { (result, _:[AnyHashable : Any]?) in
                cell.imageCell.image = result
            })
        }
        return cell
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
        if !selectionMode {
            if segue.identifier == "toDetailView" {
                if let indexPaths = collectionView?.indexPathsForSelectedItems {
                    let destinationController = segue.destination as! DetailViewController
                    destinationController.asset = assetArray[indexPaths[0].row]
                    collectionView?.deselectItem(at: indexPaths[0], animated: true)
                }
            }
        }
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
