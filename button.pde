class Button{
  PVector Pos = new PVector(0, 0);
  float width, height;
  color c;
  String label;
  
  Button(int x, int y, String label, int w, int h, int r, int g, int b){
    Pos.x = x;
    Pos.y = y;
    this.width = w;
    this.height = h;
    this.label = label;
    c = color(r,g,b);
  }
  
  void draw(){
    fill(c);
    rect(Pos.x,Pos.y,width,height);
    fill(0);
    textAlign(CENTER,CENTER);
    text(label,Pos.x+(width/2),Pos.y+(height/2));
  }
  
  boolean isClicked(){
    if(mouseX >= Pos.x && mouseY >= Pos.y && mouseX <= Pos.x + width && mouseY <= Pos.y +height)
    {
    return  true;
    }
    return false;
    }
  }
