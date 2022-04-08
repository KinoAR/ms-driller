package en.blocks;

/**
 * Heavy block that takes longer time
 * to destroy than a regular block within the game.
 */
class HeavyBlock extends Block {
  public function new(x:Int, y:Int) {
    super(x, y);
    health = 5;
  }

  override function setupGraphic() {
    var g = spr.createGraphics();
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.SteelBox);
    g.beginTileFill(tile);
    g.drawTile(0, 0, tile);
    g.endFill();
    g.x -= 8;
  }
}