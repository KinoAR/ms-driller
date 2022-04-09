package en.blocks;

/**
 * Base block for 
 * all blocks to inherit from
 * and used to set the basis of each block type.
 */
class Block extends Entity {
  public var health:Int = 3;
  public var deathAnimStart = false;
  public var noEdge:Bool;

  public function new(x:Int, y:Int) {
    super(x, y);
    noEdge = false;
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
    noEdge = getEdgeDetection();
    if (noEdge) {
      handleGravity();
    } else {
      dy = 0;
      yr = 1;
    }
  }

  public function handleGravity() {
    dy += .098;
  }

  /**
   * Determines if block falls or not.
   */
  public function getEdgeDetection() {
    var below = level.getBlockCollision(cx, cy + 1);
    if (below != null) {
      return false;
    }
    var right = level.getBlockCollision(cx + 1, cy + 1);
    if (right != null) {
      return false;
    }
    var left = level.getBlockCollision(cx - 1, cy + 1);
    if (left != null) {
      return false;
    }

    if (level.hasAnyCollision(cx, cy + 1)) {
      return false;
    }
    return true;
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
    if (health <= 0 && !deathAnimStart) {
      handleDestroy();
    }
  }

  public function handleDestroy() {
    deathAnimStart = true;
    var slib = hxd.Res.img.smoke_destroy_ase.toAseprite().aseToSlib(Const.FPS);
    var mySpr = new HSprite(slib);
    this.spr.addChild(mySpr);
    mySpr.x -= 8;
    mySpr.y -= 8;
    // should play a sound too
    mySpr.anim.play('destroy');
    mySpr.anim.setSpeed(3.5);
    mySpr.anim.onEnd(() -> this.destroy());
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