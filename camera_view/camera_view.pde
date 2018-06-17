import processing.video.*;

//output settings  
String cameraName = "";   
Capture videocam;

<<<<<<< HEAD


void settings() {
//    fullScreen(P2D); may need to rebuild drivers to have this run in linux
fullScreen();

}

void setup () {
    frameRate(30);
    //screen settings
    int VIDEO_WIDTH  = width;
    int VIDEO_HEIGHT =  height;

    //size (256,192);
    print ("width-w :"+ width);
    
      String[] cameras = Capture.list();
  
=======
//screen settings
final int VIDEO_WIDTH  = 256;
final int VIDEO_HEIGHT =  192;
//final int VIDEO_WIDTH  = displayWidth;
//final int VIDEO_HEIGHT =  displayHeight;


void setup () {
    frameRate(30);
    size (VIDEO_WIDTH, VIDEO_HEIGHT);
    //size(displayWidth, displayHeight);

    //updaate so code finds usb camera first, or the other
    
      String[] cameras = Capture.list();
      String rF = "Rocketfish HD Webcam";
      String uS = "Logitech Camera";
      String thisCamera = ""; 
       
>>>>>>> c3922ae64f8a9a389e8fad7ae30d1864bfb4003b
      if (cameras.length == 0) {
        println("There are no cameras available for capture.");
        exit();
      } else {
        for (int i = 0; i < cameras.length; i++) {
<<<<<<< HEAD
          String rF = "Rocketfish HD Webcam";
          String uS = "USB2.0 Camera";
          if(cameras[i].contains(rF)) cameraName = rF;
          if(cameras[i].contains(uS)) cameraName = uS;
    
        }
      }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    if (cameraName!="") {
      //videocam = new Capture(this, 40*4, 30*4, cameraName);
      videocam = new Capture (this, VIDEO_WIDTH, VIDEO_HEIGHT,cameraName);
    } else {
//      videocam = new Capture(this,40*4,30*4);
      videocam = new Capture(this);
    }
    videocam.start();
=======
          if (thisCamera.equals("")) thisCamera = cameras[i];    
        }
      }

    if(thisCamera.contains(rF)) cameraName = rF;
    if(thisCamera.contains(uS)) cameraName = uS;
      
      println(thisCamera );
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    if (cameraName!="") {
      videocam = new Capture (this, width, height,cameraName);
    } else {
      videocam = new Capture (this, width, height);
    }
    videocam.start();

>>>>>>> c3922ae64f8a9a389e8fad7ae30d1864bfb4003b
}
 
void draw () {
  if (videocam.available ()) {
    videocam.read ();
  }  
  image(videocam, 0, 0); 
<<<<<<< HEAD
}
=======
}
>>>>>>> c3922ae64f8a9a389e8fad7ae30d1864bfb4003b
