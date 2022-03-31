package en.collectibles;

class SilverGem extends Gem {
  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.GemWhite);
    g.beginTileFill(tile);
    g.drawTile(0, 0, tile);
    g.endFill();
  }
}