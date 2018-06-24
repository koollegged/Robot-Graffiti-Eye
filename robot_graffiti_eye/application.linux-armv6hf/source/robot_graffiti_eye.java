import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gohai.glvideo.*; 
import blobDetection.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class robot_graffiti_eye extends PApplet {




//increment of objects being drawn
int currCount = 0;

//when off, objects are cleared from screen
String state ="on";
String streamFrame = "on";

//sample rate
int drawNFrame = 31;//10000000

//current color of object
int currR, currG, currB;
int pixelColor;

//list to store locations of objects
ArrayList xPosArr  = new ArrayList();

//draw settings
DrawParamThread dParam;
String[] dParams;

//output settings  
String cameraName = "";   
GLCapture videocam;
BlobDetection theBlobDetection;
PImage blobImg;
boolean newFrame=false;

HashMap zMap = new HashMap(8);
 
// tracking Position
float xpos = 0, lxpos = 0, xdim = 0;
float ypos = 0, lypos = 0, ydim = 0;
float zpos = 0;

float step = 0.02f/drawNFrame; // Size of each step along the path
float pct = 0.0f; // Percentage traveled (0.0 to 1.0)

DrawnObject dObject = new DrawnObject();
int fillalpha = 102;
float strokealpha = 53;
int strokecolor = 10;
PImage whiteBg;
PImage blackBg;
String brush="";


public void setup () {
    frameRate(15); //updaate so code finds usb camera first, or the other
  
   

  String[] devices = GLCapture.list();
  println("Devices:");
  printArray(devices);
  if (0 < devices.length) {
    String[] configs = GLCapture.configs(devices[0]);
    println("Configs:");
    printArray(configs);
  }

  // this will use the first recognized camera by default
  videocam = new GLCapture(this);

  // you could be more specific also, e.g.
  //video = new GLCapture(this, devices[0]);
  //video = new GLCapture(this, devices[0], 640, 480, 25);
  //video = new GLCapture(this, devices[0], configs[0]);
   
    videocam.start();
   
    whiteBg = loadImage("white.png");
    blackBg = loadImage("black.png");
    noFill();
    //noStroke();
    strokeWeight (2);
    stroke (255, 0, 102);
    dParam = new DrawParamThread(2000);
    dParam.start();
    zMap.put(0.25f, new Float (10.0f)); zMap.put(0.5f, new Float(5.0f)); zMap.put(0.75f, new Float(3.0f)); zMap.put(1.0f, new Float(2.0f)); zMap.put(2.0f, new Float(1.0f)); zMap.put(3.0f, new Float(0.75f));  zMap.put(5.0f, new Float(0.5f)); zMap.put(10.0f, new Float(0.25f));
    // BlobDetection
    // img which will be sent to detection (a smaller copy of the cam frame);
    blobImg = createImage(100,100,RGB); 
    
    //img = new PImage(80,60); 
    theBlobDetection = new BlobDetection(blobImg.width, blobImg.height);
    theBlobDetection.setPosDiscrimination(true);
    theBlobDetection.setThreshold(0.365f); // will detect bright areas whose luminosity > 0.2f;


}
 
// ==================================================
// captureEvent()
// ==================================================
public void captureEvent(GLCapture videocam)
{
  videocam.read();
  newFrame = true;
}

// ==================================================
// draw()
// ==================================================
public void draw () {
  println("IN DRAW");
  
  //high quality document
  //if (streamFrame.equals("on")) saveFrame("mov/graffiti-## ##.tif"); 
  //if (streamFrame.equals("on")) saveFrame("mov/graffiti-## ##.png"); 
  //background (255);    
  //lights();
  //smooth();
  
  //LIGHTING POROPERTIES
  //lightSpecular(204, 204, 204); 
  //directionalLight(128,128,128, 1.5, -2, -1); 
  //directionalLight(128, 128, 128, 0, 2, 0); 
  //ambientLight(255,255,255);
   
   
   //MATERIAL PROPERTIES
  //emissive(126,126,126);
  //shininess(3.0);

  
  //flip image on vertical axis. Might be useful when interactive
 /* 
  pushMatrix();
  scale(-1,1);
  translate(-width, 0);
  image(videocam, 0, 0); 
  popMatrix();
 */

 if (videocam.available()) {
    videocam.read();
  }
  image(videocam, 0, 0, width, height);  
  
  /*
  if (state.equals("on")) {
    PImage cm = get();
    image(cm, 0,0);  
    cm.loadPixels();      
    if (brush.equals("follow")) image(whiteBg, 0, 0);
    if (streamFrame.equals("off")) image(cm, 0, 0, width/12, height/12); 
   
    int this_height=cm.height;int this_width=cm.width;
    
    
    if (frameCount % drawNFrame == 0){ 
      float brightestValue = 0, dimValue = 255; // Brightness of the brightest video pixel
      int index = 0; 
      for (float  j= 0; j < this_height; j++) {
        for (float i = 0; i < this_width; i++) {
        // Get the color stored in the pixel
        int pixelValue = cm.pixels[index];
        pixelColor = cm.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness >= brightestValue) {
          brightestValue = pixelBrightness;
          
          xpos = i;
          ypos = j; 
          pct = 0.0;
          currR = int(red(pixelColor)); currG = int(green(pixelColor)); currB = int(blue(pixelColor));
        }

        //if (pixelBrightness <= dimValue) {
        //  dimValue = pixelBrightness;
          
          xdim = i;
          ydim = j;          

        //}
        
          index++;

        }
      
      }
    
      dObject.update();     
      //changes size of objects at brightest point
      //dObject.getLine(xPosArr);

    
      } else {
        
      //set position, i think  
      //dObject.updateCurve(this_width,this_height);  
      //dcd 7.9.2014
      dObject.updateCurve(Math.round(xdim), Math.round(ydim));  
 
      //set color based on the previous
      int index = int((ypos*this_width)+xpos) > this_width*this_height ? 0 : int((ypos*this_width)+xpos);      
      pixelColor = cm.pixels[index];
      
      currR = int(red(pixelColor)); currG = int(green(pixelColor)); currB = int(blue(pixelColor));    
 
      //add data
      dObject.update();     
  
      dObject.printCurve();
 
    }   
  } else {
      
      dObject.update();     
   
  }  
        
    if (newFrame)
    {
      newFrame=false;
      //image(videocam,0,0,width,height);

      blobImg.copy(videocam, 0, 0, videocam.width, videocam.height, 
          0, 0, blobImg.width, blobImg.height);
      fastblur(blobImg, 2);
      theBlobDetection.computeBlobs(blobImg.pixels);
      dObject.drawLine(xPosArr);
      //DEBUG drawBlobsAndEdges(true,true);
    }
  */
  
}



// ==================================================
// drawBlobsAndEdges()
// ==================================================
public void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA,eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(3);
        stroke(0,255,0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
              eA.x*width, eA.y*height, 
              eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255,0,0);
        rect(
          b.xMin*width,b.yMin*height,
          b.w*width,b.h*height
          );
      }

    }

      }
}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================
public void fastblur(PImage img,int radius)
{
 if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }

}

public void mousePressed() {
  if(streamFrame.equals("on")) {
      streamFrame ="off";
  } else {
      streamFrame ="on";
  }
}

class DrawnObject {
  //creates lines from brightest light in camera view
  String newcolor="", currParams, paramRecord, lastS="off", cursorType = "sphere";
  float x, y, z, px, py, pz, currPx, currPy, currX, currY, currZ, currW, easing = 0.065f;  
  int currentcolor;
  String[] rgbs;
   
  public String beAvailable() { 
      if (dParam.available()) {       
        dParams = dParam.getDrawParams();
              if (dParams.length > 2) { 
                currParams = dParams[1];
            }
        }
      //println(currParams);
      return currParams; 

  }
  
  public void update() {
    String thisParam;
    String thisline = "";      
    thisline = dObject.beAvailable();        
    thisParam = dObject.setParams(thisline);
    
    if (state.equals("on")) {
      currCount++; 
     
     } else {
        xPosArr.clear();
       thisParam = xpos+","+ypos+","+1+","+"off"+","+"green"+","+0+","+0+","+0;;
       currCount=1;
       xPosArr.add(thisParam);
     }
    
    xPosArr.add(thisParam);
    py = y;
    px = x;

    //println("currCount: "+ currCount);
  }
  
//draw nexr object some distance from the last sampled location  
public void updateCurve(int this_width, int this_height) {
     
    //draw curve in frames to track mavement of item
    pct += step;
    pct = random(1.0f,1000);
    //println("pct: "+pct);
    
     // if (pct < 1.0) {
    xpos = random(0,this_width);
    ypos = random(0,this_height);
    zpos = random(0,10);
    
    /*      
    float distY = endY - beginY;
    float beginY = ypos; // Initial y-coordinate
    float exponent = 0.5; // Determines the curve
    ypos = beginY + (pow(pct, exponent) * distY);
     // }
     
    //printCurve();
     */ 
  }
  
public void printCurve() {
    String thisCursor;
    //make into separate function
    fill(currentcolor,fillalpha);
    //fill(currentcolor);  
    pushMatrix();
    translate(xpos, ypos, zpos);
    //box( currPx, currPy ,currW);
    //thisCursor = (cursorType.equals("sphere") ) ? "ellipse" : "box";
    thisCursor = cursorType;
    float rndX = random(0,2) * PI;
    float rndY = random(0,2) * PI;
    float rndZ = random(0,2) * PI;
    
     rotateX(rndX);  
     rotateY(rndY);  
     rotateZ(rndZ);  
    chooseObject(thisCursor, currPx, currPy, currX, currY,currZ, currW);    
    popMatrix();
}  
  
 public String setParams(String currParams) {
      //set values
      //draw settings
      if (newcolor.equals("")) newcolor="102|204|0";
      brush = "follow";
      String bShape = "sphere", weight = "1.0"; 
/* data example


0.75,white,on,stretch,follow
,,,, 

*/

      if (currParams != null) {
        String delims = "[,]";
        String[] tokens = currParams.split(delims);
        if (tokens.length >1 ) {
          if (!tokens[0].equals("") ) weight = tokens[0];
          if (!tokens[1].equals("") )newcolor = tokens[1].trim();
          state = tokens[2].trim();
          bShape = tokens[3].trim();
          brush = tokens[4].trim();
          
        }
      }
    
    if (state.equals("on")) {
      //draw circle lines
      String delims = "[|]";
      rgbs = newcolor.split(delims);
      
      /*
      //automatic colors
      this.automate();
      String rStr = rgbs[0];         
      String gStr = rgbs[1];
      String bStr = rgbs[2];    
      */
      //OR brightest pixel
      String rStr = Integer.toString(currR);         
      String gStr = Integer.toString(currG);
      String bStr = Integer.toString(currB);    
      
      String xToS = Float.toString(x);
      String yToS = Float.toString(y);
      paramRecord = xToS+","+yToS+","+weight+","+state+","+newcolor+","+rStr+","+gStr+","+bStr+","+bShape+","+brush;
      //paramRecord = xToS+","+yToS+","+weight+","+state+","+rStr+","+gStr+","+bStr+","+bShape+","+brush;
     } else {
       paramRecord ="";
     }
     return paramRecord;
  }
  
  public void drawLine(ArrayList xPosArr) { 
 
    for (int k=1; k < currCount; k++) {
      String currRecord = xPosArr.get(k).toString(),delims = "[,]";
      String[] tokens = currRecord.split(delims);
      String currS = tokens[3];
      //float currX, currY, currZ;
      
       currX = Float.parseFloat(tokens[0]);
       currY = Float.parseFloat(tokens[1]);
       currZ = currY;
       
       if (lastS.equals("off") && currS.equals("on")){
         currX = xpos;
         currY = ypos;
          
      }

       if (currS.equals("off")){
         currX = xpos;
         currY = ypos;
          
      }
      
      lastS = currS;
      currW = Float.parseFloat(tokens[2]);
      currZ = (Float) zMap.get(currW);
      currR = Integer.parseInt(tokens[5]); currG = Integer.parseInt(tokens[6]); currB = Integer.parseInt(tokens[7]);
      
      if (currS.equals("on")) {   
          cursorType = tokens[8];     
          strokeWeight(currW);
          currentcolor = color(currR,currG,currB);
           fill(currentcolor,fillalpha);
          stroke(strokecolor,strokealpha);
          pushMatrix();
          this.chooseBrush(tokens[9]);
          
          /*
          //make em jump
          float rndY = random(0,2) * PI;
          float rndZ = random(0,2) * PI;
          
           rotateX(rndX);  
           rotateY(rndY);  
           rotateZ(rndZ);          
          */
          //BACKGROUND
          if (newcolor.equals("0|0|0"))
          { 
            this.chooseObject(cursorType, currPx, currPy, currX, currY,currZ, currW);
          }
          popMatrix();
          
     }
      currPx = currX;
      currPy = currY;
      

   }
     //println(brush);
     // if (brush.equals("delay")) 
     // {
        //dcd  7-1-14
        //dObject.drawBlobsAndEdges(true,true);
     // }
 
  }
  
  public void getLine(ArrayList xPosArr) { 
         
    
    for (int k=1; k < currCount; k++) {
      String currRecord = xPosArr.get(k).toString(),delims = "[,]";
      String[] tokens = currRecord.split(delims);
      String currS = tokens[3];
      //float currX, currY, currZ;
      
       currX = Float.parseFloat(tokens[0]);
       currY = Float.parseFloat(tokens[1]);
       currZ = currY;
       
       if (lastS.equals("off") && currS.equals("on")){
         currX = xpos;
         currY = ypos;
          
      }

       if (currS.equals("off")){
         currX = xpos;
         currY = ypos;
          
      }
      
      lastS = currS;
      currW = Float.parseFloat(tokens[2]);
      currZ = (Float) zMap.get(currW);
      currR = Integer.parseInt(tokens[5]); currG = Integer.parseInt(tokens[6]); currB = Integer.parseInt(tokens[7]);
      
      if (currS.equals("on")) {   
          cursorType = tokens[8];     
          strokeWeight(currW);
          currentcolor = color(currR,currG,currB);
          fill(currentcolor,fillalpha);
          stroke(strokecolor,strokealpha);
          pushMatrix();
         //increase size
         
          if (xdim >= currX +25.0f) {
             if (ydim >= currY +25.0f) {
//           if (xpos <= currX +25.0) {
//             if (ypos <= currY +25.0) {

             this.chooseBrush(tokens[9]);      
       
            float rndX = random(0,2) * PI;
            float rndY = random(0,2) * PI;
            float rndZ = random(0,2) * PI;
            
             rotateX(rndX);  
             rotateY(rndY);  
             rotateZ(rndZ);
             this.chooseObject(cursorType, currPx+noise(0.5f), currPy+noise(0.5f), currX+0.0f, currY+0.0f,currZ+noise(0.5f), currW+noise(0.5f));
                         
            }
           }
           
          popMatrix();
     }
      currPx = currX;
      currPy = currY;
   }
  }


  public void chooseObject(String objectIs, float currPx, float currPy, float currX, float currY, float currZ, float currW) {

    if (objectIs.equals("ellipse")) { //rename to cubes
      strokeWeight(0.5f);
      translate(currX, currY, currZ);      
      box(((currX - currPx)* currW)* easing,((currY - currPy)* currW)* easing,(currPy * currZ)* easing); 
    }

    if (objectIs.equals("box")) {
      strokeWeight(0.5f);
      translate(currX, currY, currZ);
      rotateX(PI/3.0f);
      rotateY(PI/3.0f);
      rotateZ(PI/3.0f);
      box(((currX - currPx)* currW)*1.5f* easing,((currY - currPy)* currW)*1.5f* easing,(currPy * currZ)* easing); 
    }

    if (objectIs.equals("stretch")) {
    /*  
    translate(currX, currY, currZ);
      rotateX(PI/3.0);
      rotateY(PI/3.0);
      rotateZ(PI/3.0);
      
      box(((currX - currPx)* currW)*1.5* easing,((currY - currPy)* currW)*1.5* easing,(currPy * currZ)* easing); 
    }
    

    if (objectIs.equals("peaks")) {
    */
      strokeWeight(0.75f);
      translate(currX, currY, currZ);
      float rndY = random(0,2) * PI;
      float rndZ = random(0,2) * PI;
      
      rotateY(rndY);  
      rotateX(rndY);
      
      box(((currX - currPx)* currW)*1.5f* easing,((currY - currPy)* currW)*1.5f* easing,(currPy * currZ)* easing); 
    }
    
    
    if (objectIs.equals("sphere")) { //rename to pebbles
      noStroke();
      fill(currentcolor,fillalpha);
      translate(currX, currY, currZ);  
      //position in the center of the screen
      //translate(width/2,height/2,currZ);
      sphereDetail(3);    
      float rndX = random(0,2) * PI;
      float rndY = random(0,2) * PI;
      rotateY(rndX);  
      rotateX(rndY);
      sphere(random(0,1) *((currPx-currX) * (easing*currW)));
    }   
  }
  
  public void chooseBrush(String brushIs) {
    
       if (brushIs.equals("delay") || brushIs.equals("follow")) { 
           //used to be delayed brush
          float targetX = xpos;
          x += (targetX - x) * easing;
          float targetY = ypos;
          y += (targetY - y) * easing;
       }
       
       /*if (brushIs.equals("follow")) { 
          //smooth brush
          float targetX = xpos;
          x += (targetX - x);
          float targetY = ypos;
          y += (targetY - y);
       }*/
       
       if (brushIs.equals("point")) { 
        //points       
        x = xpos;
        y = ypos;
       }
   }
   
   
   public void automate(){
     String rgbsStr="";
     float thisSeed;
     int thisIndex, thisColor;
     for (int i= 0; i < 3; i++) {
      thisSeed = random(255);
      thisIndex = PApplet.parseInt(thisSeed);
      thisColor = thisIndex;

       if (i !=3) rgbsStr = rgbsStr+Integer.toString(thisColor)+"|";
     } 
     
     String delims = "[|]";
     rgbs = rgbsStr.split(delims);
   }
   
   
  
  // ==================================================
  // drawBlobsAndEdges()
  // ==================================================
  public void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
  {
    fill(pixelColor);
    //noFill();
    Blob b;
    EdgeVertex eA,eB;
    for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
    {
      b=theBlobDetection.getBlob(n);
      if (b!=null)
      {
        
       // Edges
      if (drawEdges)
      {
        strokeWeight(3);
        stroke(255,255,255,51);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
              eA.x*width, eA.y*height, 
              eB.x*width, eB.y*height
              );

              pushMatrix();
               if (cursorType.equals("sphere") ){
                   /*  WHITE LINES */
                            noStroke();
                            //fill(255);
                            //fill(currentcolor,fillalpha);
                            translate(eA.x*width, eA.y*height, currZ);
                            //position in the center of the screen
                            //translate(width/2,height/2,currZ);
                            sphereDetail(3);    
                            float rndX = random(0,2) * PI;
                            float rndY = random(0,2) * PI;
                            rotateY(rndY);  
                            rotateX(rndX);
                            sphere(random(0,1) *((eA.x*width-eA.y*width) * (easing*currW)*0.25f));
                            sphere(random(0,1) *((eB.x*width-eB.y*width) * (easing*currW)*0.25f));
               
               }
               else if (cursorType.equals("fpse") ){
                            translate(eA.x*width, eA.y*height);
                            rotateX(PI/3.0f);
                            rotateY(PI/3.0f);
                            rotateZ(PI/3.0f);
                      
                                           
                             box(eA.x*width, eA.y*height/8,(currPy * currZ)* easing*0.5f); 
                             box(eB.x*width, eB.y*height/8,(currPy * currZ)* easing*0.5f); 
                  
               }    
               else if (cursorType.equals("stretch") ){  
 
                           //noStroke();
                           
                            translate(eA.x*width, eA.y*height);
                            float rndX = random(5,10) * PI;
                            float rndY = random(0,1) * PI;
                            float rndZ = random(5,10) * PI;
                            
                            //ADD CHANGE TO MAKE CURRENT INCREMENT THIS. 
                            
                            rotateY(rndY);  
                            rotateX(rndX);
                            rotateZ(rndZ);
                    
                             box(eA.x*width/8, eA.y*height/4,(currPy * currZ)* easing*0.25f); 
                             box(eB.x*width/8, eB.y*height/4,(currPy * currZ)* easing*0.25f); 
                  
                 
               }  else if (cursorType.equals("box") ){  
 
                            stroke(currentcolor);
                            strokeWeight(1);
                            //fill(255);
                            fill(currentcolor );
                            translate(eA.x*width, eA.y*height, currZ);
                            //position in the center of the screen
                            //translate(width/2,height/2,currZ);
                            float thisDetail = random(1,5);
                            int intDetail = PApplet.parseInt(thisDetail);
                  
                            sphereDetail(intDetail);    
                            float rndX = random(0,2) * PI;
                            float rndY = random(0,2) * PI;
                            /*
                            rotateY(rndY);  
                            rotateX(rndX);
                            */
                            sphere(random(0,1) *((eA.x*width-eA.y*width) * (easing*currW)*0.25f));
                            //sphere(random(0,1) *((eB.x*width-eB.y*width) * (easing*currW)*2));
                             
             } else {
                            noStroke();
                            //fill(255);
                            //fill(currentcolor,fillalpha);
                            translate(eA.x*width, eA.y*height, currZ);
                            //position in the center of the screen
                            //translate(width/2,height/2,currZ);
                            sphereDetail(30);    
                            float rndX = random(0,2) * PI;
                            float rndY = random(0,2) * PI;
                            rotateY(rndY);  
                            rotateX(rndX);
                            sphere(random(0,1) *((eA.x*width-eA.y*width) * (easing*currW)*0.25f));
                            //sphere(random(0,1) *((eB.x*width-eB.y*width) * (easing*currW)*2));

               }
              popMatrix();

        }
      }

      // Blobs
      if (drawBlobs)
      {
        fill(currentcolor,fillalpha);                            
        strokeWeight(1);
        stroke(255,255,255);
        rect(
          b.xMin*width,b.yMin*height,
          b.w*width,b.h*height
          );
        }

    }

      }
}
   
}
class DrawParamThread extends Thread {
 
  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  String[] drawParams;
  boolean available;           // Is the thread available?  Yes or no?  
  int count;   // counter
  String paramAddress;
  
  // Constructor, create the thread
  // It is not running by default
  DrawParamThread (int w) {
    wait = w;
    running = false;
    available = false;
    count = 0;
  //online  
  //paramAddress = "http://www.createcreate.us/exquisite-corpse/source/get_data_db.php"; 
  //ofline mode
  paramAddress = "offline.txt"; 

    
  }

  // Overriding "start()"
  public void start () {
    // Set running equal to true
    running = true;
    // Print messages
    println("Starting thread (will execute every " + wait + " milliseconds.)"); 
    // Do whatever start does in Thread, don't forget this!
    super.start();
  }
 
 
  // We must implement run, this gets triggered by start()
  public void run () {
    while (running) {
         drawParams = loadStrings(paramAddress);
         //println(drawParams[1]);
         available = true;

      try {
        // Wait five seconds
        sleep((long)(wait));    
        } 
      catch (Exception e){
      available = false; 
      }
    }
  }
    
 
  public boolean available() {
    return available;
  } 
  
  public String[] getDrawParams() {
    return drawParams;
  } 
 
  // Our method that quits the thread
  public void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }  
}



/*
class MMThread extends Thread {
 
  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  boolean available;           // Is the thread available?  Yes or no?  
  int count;                 // counter
  //move setting
  GSMovie movie;
  GSMovieMaker mm;  
 
  // Constructor, create the thread
  // It is not running by default
  MMThread () {
    running = false;
    available = false;
    count = 0;

  }
  
  // Overriding "start()"
  void start () {
    // Set running equal to true
    running = true;
    // Print messages
    println("Starting recording"); 
    // Do whatever start does in Thread, don't forget this!
     //movie setup
     mm = new GSMovieMaker(pen_circleline.this, width, height, "drawing.ogg", GSMovieMaker.THEORA, GSMovieMaker.BEST, 4);  
     mm.setQueueSize(50, 10);
     mm.start();
    super.start();

  }
 
 
  // We must implement run, this gets triggered by start()
  void run () {
    while (running) {
    
      available = true;
      try {
        // Wait five seconds
        sleep((long)(wait));
      } 
      catch (Exception e) {
      }
    }

  }
 
  boolean available() {
    return available;
  } 
  
  void document() {
      //write movie
      loadPixels();
      mm.addFrame(pixels);         // New data is available!
 } 

  // Our method that quits the thread
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }  
}
*/
  public void settings() {  size(200,200, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "robot_graffiti_eye" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
