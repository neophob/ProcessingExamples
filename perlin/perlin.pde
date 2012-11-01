//src: http://www.iquilezles.org/www/articles/warp/warp.htm

import processing.opengl.*;
import processing.video.*;
import toxi.math.noise.*;

int XSIZE=360;//720;
int YSIZE=240;//480;

PImage imgPerlin;
float walk;

//color stuff
private int colSet=0;
private List<ColorSet> colorSet;
private ColorSet currentColorSet;

int pIterations=7;
float pDetail=0.610753f;
float mul=60*4;
float sn=0.10f;
float ofs = 4.0f;

void setup() {
  size(XSIZE, YSIZE);
  background(0);
  frameRate(10);
  smooth();
  
  //  noiseDetail(8,0.47);
  //  noiseDetail(6,0.6);

//  noiseDetail(7,0.46);//132267; //*726

  noiseDetail(pIterations, pDetail);
  
  println("load colorsets");
  colorSet = loadColorsets();
  //no error check here..
  println("... done, loaded "+colorSet.size()+" color sets");  
  currentColorSet = colorSet.get(0);
  
  loadPixels();
  println("size: "+this.pixels.length);
  updatePixels();
}

float xstep = 1.0f/float(XSIZE);
float ystep = 1.0f/float(YSIZE);

/**
 * SETUP
 */

void draw() { 
  int ofs=0;  
  float xx,yy;
  
  yy=0;
  
  loadPixels();
  for (int y=0; y<this.height; y++) {
    xx=0;
    for (int x=0; x<this.width; x++) {
      this.pixels[ofs++] = pattern4(xx,yy);      
      xx += xstep;
    }
    yy += ystep;
  }
  updatePixels();  
  walk += 0.001f;

//  saveFrame("scr/filename-#####.png");
}

//second domain wraping
color pattern4(float x, float y) {
  float qx = pattern3(x, y);
  float qy = pattern3(x+5.2f, y+1.3f);

  float rx = pattern3(x + ofs*qx + 1.7f, y + ofs*qy + 9.2f);
  float ry = pattern3(x + ofs*qx + 8.3f, y + ofs*qy + 2.8f);

  float val = pattern3(x + ofs*rx, y + ofs*ry);//*mul;
 // print(" "+val);
  float vv=val;
  val*=mul;
  val+=  (rx+ry)*val + val*(qx+qy) + val*(rx*qy);
  float cc=pattern(qx+x, qy+y);
  
  return currentColorSet.getSmoothColor(int(val*cc*255f));
/*  
//  return color(val*rx,val*ry,val*qy);
//  return color(val, val, val);
  

//  return color(val*qx,val*qy,val*cc); //cyan rot
//  return color(val*cc*val*qx, val*cc*val*qy ,val*cc*val); //cyan rot

  if (val>200) {
     return color(val*0.8f+(val-200), val*(0.9f-vv), val*0.6f);    
  }
 return color(val*0.8f, val*(0.9f-vv), val*0.6f);
  */
  //return color(val*ry+val*rx, val*qy+val*qx, val*qx+val*ry); //colorfull
}


//second domain wraping
float pattern3(float x, float y) {
  float qx = pattern2(x, y);
  float qy = pattern2(x+5.2f, y+1.3f);

//  float rx = pattern2(x + 4.0*qx + 1.7f, y + 4.0*qy + 9.2f);
//  float ry = pattern2(x + 4.0*qx + 8.3f, y + 4.0*qy + 2.8f);
  float rx = pattern2(x + ofs*qx + 1.7f, y + ofs*qy + 9.2f);
  float ry = pattern2(x + ofs*qx + 8.3f, y + ofs*qy + 2.8f);

  return pattern2(x+ofs*rx, y+ofs*ry);
//  return pattern2(x+4.0*rx, y+4.0*ry);
}

//first domain wraping
float pattern2(float x, float y) {

  float qx = pattern(x, y);
  float qy = pattern(x+5.2f, y+1.3f);

//  return pattern(x+4f*qx, y+4f*qy);
  return pattern(x+ofs*qx, y+ofs*qy);
}

float pattern(float x, float y) {
//  return noise(x, y, walk);
  float f = (float)SimplexNoise.noise(x,y,walk);
  float fsn=f*sn;
  return (fsn+fsn/2+fsn/4)/2;
}


void keyPressed() {
  float value = 0.1f;

  switch (key) {
  case 'u':
    pIterations--;
    noiseDetail(pIterations, pDetail);
    break;
  case 'U':
    pIterations++;
    noiseDetail(pIterations, pDetail);
    break;
  case 'c':
    colSet--;
    if (colSet<0) {
      colSet = colorSet.size()-1;
    }
    currentColorSet = colorSet.get(colSet);
    break;
  case 'C':
    colSet++;
    if (colSet>colorSet.size()-1) {
       colSet = 0; 
    }
    currentColorSet = colorSet.get(colSet);
    break;
  case 's':
    sn-=0.05f;
    break;
  case 'S':
    sn+=0.05f;
    break;
  case 'i':
    pDetail-=0.01f;
    noiseDetail(pIterations, pDetail);
    break;
  case 'I':
    pDetail+=0.01f;
    noiseDetail(pIterations, pDetail);
    break;
  case 'm':
    mul-=2;
    break;
  case 'M':
    mul+=2;
    break;
  case 'o':
    ofs--;
    break;
  case 'O':
    ofs++;
    break;
  case 'x':
    //pIterations=2+int(random(14));
    pDetail=random(9000)/10000f;
    noiseDetail(pIterations, pDetail);
    //mul=200+random(300);   
    break;
  }

  print(" pDetail: "+pDetail);  
  print(" pIterations: "+pIterations);  
  print(" mul: "+mul);    
  print(" sn: "+sn); 
  print(" ofs: "+ofs);
  print(" colSet: "+colSet+" "+currentColorSet.getName());  
  println();
}

