package en.blocks;

/**
 * Base block for 
 * all blocks to inherit from
 * and used to set the basis of each block type.
 */
class Block extends Entity {
  public var health:Int = 3;

  public function new(x:Int, y:Int) {
    super(x, y);
    setupGraphic();
  }

  public function setupGraphic() {
    var g = this.spr.createGraphics();
    g.beginFill(0xaf8f00);
    g.drawRect(0, 0, Const.GRID, Const.GRID);
    g.endFill();
  }

  override function update() {
    super.update();
    handleDamage();
  }

  public function handleDamage() {}

  /**
   * Takes damage to the block and also
   * produces a sound.
   */
  public function takeDamage() {
    if (!cd.has('damaged')) {
      if (health > 0) {
        health -= 1;
        cd.setS('damaged', 0.2);
        Assets.damageSnd.play();
      }
    }
    if (health <= 0) {
      this.destroy();
    }
  }

  /**
   * Plays the damage sound.
   * Should modify this to produce
   * different sound per block type.
   */
  public function playDamageSound() {
    Assets.damageSnd.play();
  }
}