package en;

class Enemy extends BaseEnt {
  /**
   * Sets the enemy at the grid based coordinates.
   * @param x 
   * @param y 
   */
  public function new(x:Int, y:Int) {
    super(x, y);
    setupGraphics();
  }

  public function setupGraphics() {}
}