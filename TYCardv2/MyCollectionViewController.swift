//
//  MyCollectionViewController.swift
//  
//
//  Created by Andy Wei on 7/20/15.
//
//
import UIKit

class MyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //Data received from ViewController1 Segue
    var emailText1 = String()
    var subjeText1 = String()
    var RecEmailText1 = String()
    var tyImages = [String]()
    var selectedImage = String()
  

    //If ViewController2 loaded correctly, initialize header and images
    override func viewDidLoad() {
        super.viewDidLoad()
        //let myNib = UINib(nibName: "tyHeaderCell",bundle: nil)
        tyImages = ["card-01.jpg", "card-02.jpg", "card-03.jpg", "card-04.jpg", "card-05.jpg", "card-07.jpg", "card-08.jpg", "card-09.jpg", "card-10.jpg", "card-11.jpg"]
        //println(tyImages)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set section to 1
    override func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
            return 1
    }
    
    //Set number of items in section to number of images
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tyImages.count
    }
    
    /*1. Initialize cell
      2. Initialize "Choose Button" and hide
      3. Set each cell corresponding to each image
    */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tyCardCell",
        forIndexPath: indexPath) as! MyCollectionViewCell
        //selectedImage = tyImages[indexPath.row]
                
        let chooseBtn = cell.viewWithTag(3) as! UIButton
        chooseBtn.hidden = true
        chooseBtn.addTarget(self, action: Selector("chooseBtnAction"), forControlEvents: UIControlEvents.TouchUpInside)

        let image = UIImage(named: tyImages[indexPath.row])
        cell.imageView.image = image
        cell.selected = true
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)

        return cell
    }
    
    //Set up header
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "tyHeader",
                    forIndexPath: indexPath)
                    as! MyCollectionReusableView
                headerView.tyHeaderLabel.text = "Choose your card!"
                return headerView
            default:
                assert(false, "Unexpected element kind")
                fatalError("Unexpected element kind")
            }
    }
    
    /*1. Initialize Cell
      2. Show choose button on tap
      3. Show highlight on tap
      4. Set image as selected image on tap
    */
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        let chooseBtn = cell!.viewWithTag(3) as! UIButton
        
        //hide highlight if tapped again
        if(chooseBtn.hidden == false){
            chooseBtn.hidden = true
            cell!.layer.borderColor = UIColor.whiteColor().CGColor
            //print("tappedagain")
        }
        
        //show highlight if new tap
        else {
            chooseBtn.hidden = false
            cell!.layer.borderWidth = 2.0
            cell!.layer.borderColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0).CGColor
            //print("newtap")
        }
        selectedImage = tyImages[indexPath.row]
        //println(tyImages[indexPath.row])
    }
    
    //If chose another cell, unhighlight and hide choose button from previously chosen cell
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        let chooseBtn = cell!.viewWithTag(3) as! UIButton
        cell!.layer.borderWidth = 2.0
        cell!.layer.borderColor = UIColor.whiteColor().CGColor
        chooseBtn.hidden = true
    }
    

    //Choose Button segues to next View Controller
    func chooseBtnAction(){
        self.performSegueWithIdentifier("Chosen", sender: self)
        //println(selectedImage)
    }

    //Function to overlay text to chosen image
    func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.blackColor()
        let textFont: UIFont = UIFont(name: "Helvetica", size: 65)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as big as the image.
        let rect: CGRect = CGRectMake(30.0, 1090.0, 1409.0, inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }


    //Segues to next View Controller, sending overlayed image and other data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Chosen" {

            if let DestV3 = segue.destinationViewController as? ViewController2
            {
                var tycard1 = UIImage()
                //println(selectedImage)
                tycard1 = textToImage(emailText1, inImage: UIImage(named: selectedImage)!, atPoint: CGPointMake(20,20))
                DestV3.RecEmailText = RecEmailText1
                DestV3.subjeText = subjeText1
                DestV3.emailText = emailText1
                DestV3.tycard2 = tycard1
            }

        }
        
    }


}
