package en.blocks;

/**
 * A simple block 
 * that you can drill through in order
 * to progress downward in the game.
 */
class RegBlock extends Block {
  public function new(x:Int, y:Int) {
    super(x, y);
  }

  override function setupGraphic() {
    var g = spr.createGraphics();
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.BasicCrate);
    g.beginTileFill(tile);
    g.drawTile(0, 0, tile);
    g.endFill();
    g.x -= 8;
  }
}