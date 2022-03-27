package en.hazards;

/**
 * Exit which will send the player to the 
 * next level when they run into it.
 */
class Exit extends Entity {
  public function new(x:Int, y:Int) {
    super(x, y);
    setupGraphic();
  }

  public function setupGraphic() {
    var g = this.spr.createGraphics();
    g.beginFill(0xffaaaa);
    g.drawRoundedRect(0, 0, Const.GRID, Const.GRID, 30);
    g.endFill();
  }
}