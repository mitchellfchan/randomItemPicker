String items[];
StringList itemList;
int itemIndex = -1;
XML xml;
PFont f;

String API_KEY = "613a48d95d8506ebe36ec618ee9c8103";

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

    String searchString;
    println(items[itemIndex]);
    searchString = items[itemIndex].replace(' ', '+');
    String url = getFlickrPic(searchString);

    PImage pic = loadImage(url);
    if (pic.height > height - 120) {
      float scaleFactor = float(height - 120) / pic.height;
      pic.resize(int(pic.width * scaleFactor), height - 120 );
    }

    image(pic, width/2, height/2);

    fill(255);
    text(items[itemIndex], 20, 60);

  }

  noLoop();

}

String getFlickrPic(String searchString) {
    String request = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=" + API_KEY + "&tags=" + searchString + "&per_page=10&format=rest";
    xml = loadXML(request);
    XML[] children = xml.getChildren("photos");
    int r = int(random(10));
    XML[] photo = children[0].getChildren("photo");
    String farm = photo[r].getString("farm");
    String server = photo[r].getString("server");
    String id  = photo[r].getString("id");
    String secret = photo[r].getString("secret");
    String url = "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret + "_b.jpg";
    return url;
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
