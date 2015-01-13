String items[];
StringList itemList;
int itemIndex = -1;
XML xml;
PFont f;

PImage pic;

void setup() {

  size(displayWidth, displayHeight);

  items = loadStrings("items.txt");

  //  BEFORE:
  //  printItems();

  shuffleItems();

  //  AFTER:
  //  printItems();

  f = loadFont("FranklinGothicURW-DemIta-48.vlw");
  textFont(f, 48);
  imageMode(CENTER);
}

void draw() {
  background(0);
  if (itemIndex >= items.length) {
    text("I'm all out of stuff!", 20, 60);
    text("Press r to restart", 20, 120);
  } else if (itemIndex < 0) {
    text("Let's get started!", 20, 60);
    text("Press spacebar to get your thing", 20, 120);
  } else {
    
    getFlikrImage();

    if (pic.height > height - 120) {
      pic = resizeImage(pic);
    }

    image(pic, width/2, height/2);
    fill(0);
    rect(0, 0, width, 80);
    fill(255);
    text(items[itemIndex], 20, 60);
  }
  noLoop();
}

void printItems() {
  for (int i = 0; i < items.length; i++) {
    println(i + ": " + items[i]);
  }
}

void shuffleItems() {
  for (int i = 0; i < items.length; i++) {
    int newPos = int(random(items.length));
    String temp = items[i];
    items[i] = items[newPos];
    items[newPos] = temp;
  }
}

 void getFlikrImage(){   
    String searchString;
    searchString = items[itemIndex].replace(' ', '+');
    String rest = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=613a48d95d8506ebe36ec618ee9c8103&tags=" + searchString + "&per_page=10&format=rest";

    xml = loadXML(rest);

    XML[] children = xml.getChildren("photos");
    int r = int(random(10));
    XML[] photo = children[0].getChildren("photo");
    String farm = photo[r].getString("farm");
    String server = photo[r].getString("server");
    String id  = photo[r].getString("id");
    String secret = photo[r].getString("secret");
    String url = "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret + "_b.jpg";

    pic = loadImage(url);

    teachingTools(xml, searchString, rest, url, farm, server, id);
 }
 
 void teachingTools(XML xml, String searchString, String rest, String url, String farm, String server, String id) {
  //What's Going On?
  saveXML(xml, "Example.xml");
  println("Search String = " + searchString);
  println("Rest =          " + rest);
  println("URL =           " + url);
  println("Farm =          " + farm);
  println("Server =        " + server);
  println("Id =            " + id);
  println(" ");
}


PImage resizeImage(PImage picToScale) {
  float scaleFactor = float(height - 120) / picToScale.height;
  picToScale.resize(int(picToScale.width * scaleFactor), height - 120 );
  return picToScale;
} 



void keyPressed() {
  switch (key) {
  case ' ':
    itemIndex += 1;
    loop();
    break;
  case 'r':
    shuffleItems();
    itemIndex = -1;
    loop();
    break;
  }
}

boolean sketchFullScreen() {
  return true;
}

