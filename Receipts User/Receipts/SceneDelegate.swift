//
//  SceneDelegate.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 18/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let _ = (scene as? UIWindowScene) else { return }
		
		self.determineStoryboard()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
		
		self.biometricProtection { (_) in
			print("Biometrics complete.")
		}
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.

		// Save changes in the application's managed object context when the application transitions to the background.
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}
		
	// MARK: - Storyboard Methods
	func determineStoryboard() {
		if Authentication.account.isSignedIn == true {
			self.biometricProtection() { (success) in
				if success {
					// Send to 'Main.storyboard'
					let storyboard = UIStoryboard(name: "Main", bundle: nil)
					let firstVC = storyboard.instantiateInitialViewController()
					self.window?.rootViewController = firstVC
				} else {
					// TODO: - Notify user that did not authenticate and give option to retry
				}
			}
		} else {
			// Send to 'Onboarding.storyboard'
			let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
			let firstVC = storyboard.instantiateInitialViewController() as! SignInViewController
			
			self.window?.rootViewController = firstVC
		}
	}
	
	func biometricProtection(completion: @escaping(Bool) -> ()) {
		if UserDefaults.standard.bool(forKey: "Authenticate On Launch") {
			let localAuthContext = LAContext()
			
			var authError: NSError?
			if localAuthContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
				localAuthContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Access Receipts") { (success, error) in
					if success {
						completion(true)
					} else {
						guard let _ = error else { completion(false); return }
					}
				}
			} else {
				guard let _ = authError else { completion(false); return }
			}
		} else {
			completion(true)
		}
	}
	
}

