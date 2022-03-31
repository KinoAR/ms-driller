package en.collectibles;

class RubyGem extends Gem {
  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.GemRed);
    g.beginTileFill(tile);
    g.drawTile(0, 0, tile);
    g.endFill();
  }
}