//src: http://www.iquilezles.org/www/articles/warp/warp.htm

import processing.opengl.*;
import processing.video.*;
import toxi.math.noise.*;

static float mm = 1;
static float fXSIZE=720f/mm;
static float fYSIZE=480f/mm;

int XSIZE=int(720/mm);
int YSIZE=int(480/mm);

PImage imgPerlin;
float walk;

//float mul=255*2;
//int pIterations=4;
//float pDetail=0.6123f;

int pIterations=7;
float pDetail=0.610753f;
float mul=1020;

void setup() {
  size(XSIZE, YSIZE, P3D);
  imgPerlin = createImage(XSIZE, YSIZE, RGB);
  frameRate(30);

  //  noiseDetail(8,0.47);
  //  noiseDetail(6,0.6);

//  noiseDetail(7,0.46);//132267; //*726

  noiseDetail(pIterations, pDetail);
}

float xstep = 1.0f/fXSIZE;
float ystep = 1.0f/fYSIZE;

void draw() { 
  int ofs=0;  
  float xx,yy;
  
  yy=0;
  
  imgPerlin.loadPixels();
  for (int y=0; y<fYSIZE; y++) {
    xx=0;
    for (int x=0; x<fXSIZE; x++) {
      imgPerlin.pixels[ofs++] = pattern4(xx,yy);
      xx += xstep;
    }
    yy += ystep;
  }
  imgPerlin.updatePixels();
  
  walk += 0.001f;

  //display buffer
  image(imgPerlin, 0, 0);     

 //   saveFrame("scr/filename-#####.png");
}

final float ofs = 4.0f;

//second domain wraping
color pattern4(float x, float y) {
  float qx = pattern(x, y);
  float qy = pattern(x+5.2f, y+1.3f);

  float rx = pattern(x + ofs*qx + 1.7f, y + ofs*qy + 9.2f);
  float ry = pattern(x + ofs*qx + 8.3f, y + ofs*qy + 2.8f);

  float val = pattern(x + ofs*rx, y + ofs*ry);//*mul;
 // print(" "+val);
  float vv=val;
  val*=mul;
  val+=  (rx+ry)*val + val*(qx+qy) + val*(rx*qy);
  
//  return color(val*rx,val*ry,val*qy);
//  return color(val, val, val);
  float cc=pattern(qx+x, qy+y);

//  return color(val*qx,val*qy,val*cc); //cyan rot
//  return color(val*cc*val*qx, val*cc*val*qy ,val*cc*val); //cyan rot

  if (val>200) {
     return color(val*0.8f+(val-200), val*(0.9f-vv), val*0.6f);    
  }
 return color(val*0.8f, val*(0.9f-vv), val*0.6f);
  
  //return color(val*ry+val*rx, val*qy+val*qx, val*qx+val*ry); //colorfull
}


//second domain wraping
float pattern3(float x, float y) {
  float qx = pattern(x, y);
  float qy = pattern(x+5.2f, y+1.3f);

  float rx = pattern(x + 4.0*qx + 1.7f, y + 4.0*qy + 9.2f);
  float ry = pattern(x + 4.0*qx + 8.3f, y + 4.0*qy + 2.8f);

  return pattern(x+4.0*rx, y+4.0*ry);
}

//first domain wraping
float pattern2(float x, float y) {

  float qx = pattern(x, y);
  float qy = pattern(x+5.2f, y+1.3f);

  return pattern(x+4f*qx, y+4f*qy);
}

float sn=0.6f;

float pattern(float x, float y) {
//  return noise(x, y, walk);
  float f = (float)SimplexNoise.noise(x,y,walk);
  return (f*sn+f*sn/2+f*sn/4)/2;
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
  case 'o':
    mul-=10;
    break;
  case 'O':
    mul+=10;
    break;
  case 'x':
    pIterations=2+int(random(14));
    pDetail=random(9000)/10000f;
    noiseDetail(pIterations, pDetail);
    mul=200+random(300);   
    break;
  }

  print(" pDetail: "+pDetail);  
  print(" pIterations: "+pIterations);  
  print(" mul: "+mul);    
  print(" sn: "+sn);      
  println();
}

