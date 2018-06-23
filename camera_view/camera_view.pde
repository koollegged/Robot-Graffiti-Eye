import processing.video.*;

//output settings  
String cameraName = "";   
Capture videocam;

//void settings() {
//  fullScreen();
//}

void setup () {
    frameRate(30);
    //screen settings
    int VIDEO_WIDTH  = width;
    int VIDEO_HEIGHT = height;
    size(800,600);
       
    videocam = new Capture (this);
    videocam.start();

}
 
void draw () {
  if (videocam.available ()) {
    videocam.read ();
  }  
  image(videocam, 0, 0); 
}
