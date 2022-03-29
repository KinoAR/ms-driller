package en.collectibles;

class Gem extends Collectible {
  public function new(x:Int, y:Int) {
    super(x, y);
    setupGraphic();
  }

  override function setupGraphic() {
    var g = this.spr.createGraphics();
    g.beginFill(0xffaa);
    g.drawRoundedRect(0, 0, Const.GRID, Const.GRID, 5);
    g.endFill();
  }
}