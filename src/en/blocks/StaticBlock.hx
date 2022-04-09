package en.blocks;

/**
 * Stay in a static location which allows the
 * block to stay in the same spot without being 
 * moved via the edge detection.
 */
class StaticBlock extends Block {
  public function new(x:Int, y:Int) {
    super(x, y);
    health = 99999999;
  }

  override function setupGraphic() {
    var g = spr.createGraphics();
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.SteelBox);
    g.beginTileFill(tile);
    g.drawTile(0, 0, tile);
    g.endFill();
    g.x -= 8;
  }

  override function getEdgeDetection():Bool {
    return false;
  }
}