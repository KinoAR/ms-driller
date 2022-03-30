package en.blocks;

/**
 * Ignition Block, which when hit,
 * starts the ignition timer,
 * this will blow up all blocks in
 * a cross shaped pattern.
 */
class IgnitionBlock extends Block {
  public static inline var COUNTDOWN_TIME:Float = 3;

  public function new(x:Int, y:Int) {
    super(x, y);
  }

  override function setupGraphic() {
    var g = spr.createGraphics();
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.ExplosiveBox);
    g.beginTileFill(tile);
    g.drawTile(0, 0, tile);
    g.endFill();
  }
}