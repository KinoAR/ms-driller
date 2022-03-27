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
    var g = this.spr.createGraphics();
    g.beginFill(0x111111);
    g.drawRect(0, 0, Const.GRID, Const.GRID);
    g.endFill();
  }
}