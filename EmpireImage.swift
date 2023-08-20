//
//  EmpireImage.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/03/17.
//

import Foundation
import UIKit
import MessageUI

class EmpireImage: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var c: UIButton!
    @IBAction func c(_ sender: Any) {
        if MFMailComposeViewController.canSendMail()==false {
                    print("Email Send Failed")
                    return
                }

                var mailViewController = MFMailComposeViewController()
                var toRecipients = ["akihide.yoshida5@gmail.com"]
                var CcRecipients = [""]
                var BccRecipients = [""]

                mailViewController.mailComposeDelegate = self
                mailViewController.setSubject("質問および要望")
                mailViewController.setToRecipients(toRecipients) //宛先メールアドレスの表示
                mailViewController.setCcRecipients(CcRecipients)
                mailViewController.setBccRecipients(BccRecipients)
                mailViewController.setMessageBody("メールの本文", isHTML: false)

        self.present(mailViewController, animated: true, completion: nil)
            }
    
    @IBOutlet weak var b: UIButton!
    @IBAction func b(_ sender: Any) {
        /*
        if MFMailComposeViewController.canSendMail()==false {
                    print("Email Send Failed")
                    return
                }

                var mailViewController = MFMailComposeViewController()
                var toRecipients = ["akihide.yoshida5@gmail.com"]
                var CcRecipients = [""]
                var BccRecipients = [""]

                mailViewController.mailComposeDelegate = self
                mailViewController.setSubject("削除依頼 ID:"+String(myname))
                mailViewController.setToRecipients(toRecipients) //宛先メールアドレスの表示
                mailViewController.setCcRecipients(CcRecipients)
                mailViewController.setBccRecipients(BccRecipients)
                mailViewController.setMessageBody("メールの本文", isHTML: false)

        self.present(mailViewController, animated: true, completion: nil)
        */
            }

    @IBOutlet weak var a: UIButton!
    @IBAction func a(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
          }

                var mailViewController = MFMailComposeViewController()
                var toRecipients = ["akihide.yoshida5@gmail.com"]
                var CcRecipients = [""]
                var BccRecipients = [""]

                mailViewController.mailComposeDelegate = self
                mailViewController.setSubject("お問合せ")
                mailViewController.setToRecipients(toRecipients) //宛先メールアドレスの表示
                mailViewController.setCcRecipients(CcRecipients)
                mailViewController.setBccRecipients(BccRecipients)
                mailViewController.setMessageBody("メールの本文", isHTML: false)

        self.present(mailViewController, animated: true, completion: nil)
            }

            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                switch result {
                case .cancelled:
                    print("Email Send Cancelled")
                    break
                    
                case .saved:
                    print("Email Saved as a Draft")
                    break
                    
                case .sent:
                    print("Email Sent Successfully")
                    break
                    
                case .failed:
                    print("Email Send Failed")
                    break
                    
                default:
                    break
                }
                controller.dismiss(animated: true, completion: nil)
            }
    
    @IBOutlet weak var redView: UIImageView!
    override func viewDidLoad() {
            super.viewDidLoad()
        
        redView.layer.cornerRadius = 15
        redView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(redView)
        redView.layer.cornerRadius = 8 // 角丸を設定
        redView.layer.shadowColor = UIColor.black.cgColor // 影の色
        redView.layer.shadowOpacity = 0.5 // 影の透明度（0.0から1.0までの値）
        redView.layer.shadowOffset = CGSize(width: 0, height: 2) // 影のオフセット
        redView.layer.shadowRadius = 4 // 影のぼかしの程度
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
