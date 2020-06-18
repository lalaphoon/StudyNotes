
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var trashImageView: UIImageView!
    
    var fileViewOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileImageView.isUserInteractionEnabled = true
        
        
        addPanGesture(view: fileImageView)
        fileViewOrigin = fileImageView.frame.origin
        
        //bring it to the top of the trash image view
        view.bringSubview(toFront: fileImageView)
    }
    
    func addPanGesture(view: UIView) {
        //The target is added to ViewController
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }
    
    // Refactor
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let fileView = sender.view!
        
        switch sender.state {
            
        case .began, .changed:
            moveViewWithPan(theView: fileView, sender: sender)

        case .ended:
            if fileView.frame.intersects(trashImageView.frame) {
                deleteView(view: fileView)
                
            } else {
                returnViewToOrigin(view: fileView)
            }
            
        default:
            break
        }
    }
    
    
    func moveViewWithPan(theView: UIView, sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: theView.superview)
        
        theView.center = CGPoint(x: theView.center.x + translation.x, y: theView.center.y + translation.y)
        //since have the new CG
        sender.setTranslation(CGPoint.zero, in: theView.superview)
    }
    
    
    func returnViewToOrigin(view: UIView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            view.frame.origin = self.fileViewOrigin
        })
    }
    
    
    func deleteView(view: UIView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0.0
        })
    }
}

