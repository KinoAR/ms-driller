package en.collectibles;

class Gem extends Collectible {
  public function new(x:Int, y:Int) {
    super(x, y);
    setupGraphic();
  }

  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.GemGreen);
    g.beginTileFill(tile);
    g.drawTile(0, 0, tile);
    g.endFill();
    g.x -= 8;
  }
}