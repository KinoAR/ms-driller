package en.collectibles;

class Heart extends Collectible {
  public function new(eHeart:Entity_Heart) {
    super(eHeart.cx, eHeart.cy);
  }

  override function setupGraphic() {
    var g = spr.createGraphics();
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.HeartGem);
    g.beginTileFill(tile);
    g.drawTile(0, 0, tile);
    g.endFill();
    g.x -= 8;
  }
}