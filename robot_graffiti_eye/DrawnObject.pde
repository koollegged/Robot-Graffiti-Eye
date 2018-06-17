
class DrawnObject {
  //creates lines from brightest light in camera view
  String newcolor="", currParams, paramRecord, lastS="off", cursorType = "sphere";
  float x, y, z, px, py, pz, currPx, currPy, currX, currY, currZ, currW, easing = 0.065;  
  color currentcolor;
  String[] rgbs;
   
  String beAvailable() { 
      if (dParam.available()) {       
        dParams = dParam.getDrawParams();
              if (dParams.length > 2) { 
                currParams = dParams[1];
            }
        }
      //println(currParams);
      return currParams; 

  }
  
  void update() {
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
void updateCurve(int this_width, int this_height) {
     
    //draw curve in frames to track mavement of item
    pct += step;
    pct = random(1.0,1000);
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
  
void printCurve() {
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
  
 String setParams(String currParams) {
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
  
  void drawLine(ArrayList xPosArr) { 
 
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
  
  void getLine(ArrayList xPosArr) { 
         
    
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
         
          if (xdim >= currX +25.0) {
             if (ydim >= currY +25.0) {
//           if (xpos <= currX +25.0) {
//             if (ypos <= currY +25.0) {

             this.chooseBrush(tokens[9]);      
       
            float rndX = random(0,2) * PI;
            float rndY = random(0,2) * PI;
            float rndZ = random(0,2) * PI;
            
             rotateX(rndX);  
             rotateY(rndY);  
             rotateZ(rndZ);
             this.chooseObject(cursorType, currPx+noise(0.5), currPy+noise(0.5), currX+0.0, currY+0.0,currZ+noise(0.5), currW+noise(0.5));
                         
            }
           }
           
          popMatrix();
     }
      currPx = currX;
      currPy = currY;
   }
  }


  void chooseObject(String objectIs, float currPx, float currPy, float currX, float currY, float currZ, float currW) {

    if (objectIs.equals("ellipse")) { //rename to cubes
      strokeWeight(0.5);
      translate(currX, currY, currZ);      
      box(((currX - currPx)* currW)* easing,((currY - currPy)* currW)* easing,(currPy * currZ)* easing); 
    }

    if (objectIs.equals("box")) {
      strokeWeight(0.5);
      translate(currX, currY, currZ);
      rotateX(PI/3.0);
      rotateY(PI/3.0);
      rotateZ(PI/3.0);
      box(((currX - currPx)* currW)*1.5* easing,((currY - currPy)* currW)*1.5* easing,(currPy * currZ)* easing); 
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
      strokeWeight(0.75);
      translate(currX, currY, currZ);
      float rndY = random(0,2) * PI;
      //float rndZ = random(0,2) * PI;
      
      rotateY(rndY);  
      rotateX(rndY);
      
      box(((currX - currPx)* currW)*1.5* easing,((currY - currPy)* currW)*1.5* easing,(currPy * currZ)* easing); 
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
  
  void chooseBrush(String brushIs) {
    
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
   
   
   void automate(){
     String rgbsStr="";
     float thisSeed;
     int thisIndex, thisColor;
     for (int i= 0; i < 3; i++) {
      thisSeed = random(255);
      thisIndex = int(thisSeed);
      thisColor = thisIndex;

       if (i !=3) rgbsStr = rgbsStr+Integer.toString(thisColor)+"|";
     } 
     
     String delims = "[|]";
     rgbs = rgbsStr.split(delims);
   }
   
   
  
  // ==================================================
  // drawBlobsAndEdges()
  // ==================================================
  void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
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
                            sphere(random(0,1) *((eA.x*width-eA.y*width) * (easing*currW)*0.25));
                            sphere(random(0,1) *((eB.x*width-eB.y*width) * (easing*currW)*0.25));
               
               }
               else if (cursorType.equals("fpse") ){
                            translate(eA.x*width, eA.y*height);
                            rotateX(PI/3.0);
                            rotateY(PI/3.0);
                            rotateZ(PI/3.0);
                      
                                           
                             box(eA.x*width, eA.y*height/8,(currPy * currZ)* easing*0.5); 
                             box(eB.x*width, eB.y*height/8,(currPy * currZ)* easing*0.5); 
                  
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
                    
                             box(eA.x*width/8, eA.y*height/4,(currPy * currZ)* easing*0.25); 
                             box(eB.x*width/8, eB.y*height/4,(currPy * currZ)* easing*0.25); 
<<<<<<< HEAD
                  
                 
               }  else if (cursorType.equals("box") ){  
 
                            stroke(currentcolor);
                            strokeWeight(1);
                            //fill(255);
                            fill(currentcolor );
                            translate(eA.x*width, eA.y*height, currZ);
                            //position in the center of the screen
                            //translate(width/2,height/2,currZ);
                            float thisDetail = random(1,5);
                            int intDetail = int(thisDetail);
                  
=======
                  
                 
               }  else if (cursorType.equals("box") ){  
 
                            stroke(currentcolor);
                            strokeWeight(1);
                            //fill(255);
                            fill(currentcolor );
                            translate(eA.x*width, eA.y*height, currZ);
                            //position in the center of the screen
                            //translate(width/2,height/2,currZ);
                            float thisDetail = random(1,5);
                            int intDetail = int(thisDetail);
                  
>>>>>>> c3922ae64f8a9a389e8fad7ae30d1864bfb4003b
                            sphereDetail(intDetail);    
                            float rndX = random(0,2) * PI;
                            float rndY = random(0,2) * PI;
                            /*
                            rotateY(rndY);  
                            rotateX(rndX);
                            */
                            sphere(random(0,1) *((eA.x*width-eA.y*width) * (easing*currW)*0.25));
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
                            sphere(random(0,1) *((eA.x*width-eA.y*width) * (easing*currW)*0.25));
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
