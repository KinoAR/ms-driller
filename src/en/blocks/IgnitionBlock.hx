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
    var g = this.spr.createGraphics();
    g.beginFill(0xff4a00);
    g.drawRect(0, 0, Const.GRID, Const.GRID);
    g.endFill();
  }
}