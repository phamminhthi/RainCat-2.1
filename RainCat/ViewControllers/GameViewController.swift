//
//  GameViewController.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Speech

class GameViewController: UIViewController,SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
  override func viewDidLoad() {
    super.viewDidLoad()

    var sceneNode : SKScene //= LogoScene(size: view.frame.size)
//    if UIDevice.current.userInterfaceIdiom == .phone {
//      sceneNode = SKScene(fileNamed: "LogoScene-iPhone")!
//    } else {
      sceneNode = RainCatScene(size: getDisplaySize())
//    }

    if let view = self.view as! SKView? {
      view.presentScene(sceneNode)
      view.ignoresSiblingOrder = true
//      view.scene?.scaleMode = .aspectFill
//      view.showsPhysics = true
      //view.showsFPS = true
      //view.showsNodeCount = true
    }

    SoundManager.sharedInstance.startPlaying()

    speechRecognizer?.delegate = self
    //startRecording()
  }

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if let result = result {
                var lastString = ""
                let bestString = result.bestTranscription.formattedString.lowercased()
                for i in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: i.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                    
                }
                
                isFinal = result.isFinal
                self.checkFruit(resultString: lastString)
                print(lastString)
                
                
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.startRecording()
                //self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        //textView.text = "Say something, I'm listening!"
        
        
    }
    func checkFruit(resultString: String) {
        switch resultString {
        case "apple":

            print(resultString)
        case "chili":
            print(resultString)
        case "orange":
            print(resultString)
        case "pineapple":
            print(resultString)
        case "grapes":
            print(resultString)
        case "cherries":
            print(resultString)
        case "tomato":
            print(resultString)
        case "raspberry":
            print(resultString)
        case "strawberry":
            print(resultString)
        default: break
        }
    }
    

}
