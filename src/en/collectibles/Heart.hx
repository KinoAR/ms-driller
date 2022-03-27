package en.collectibles;

class Heart extends Collectible {
  public function new(eHeart:Entity_Heart) {
    super(eHeart.cx, eHeart.cy);
  }
}