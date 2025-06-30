component accessors='true' {
  property name='path'       type='string';
  property name='decoder'    type='com.madgag.gif.fmsware.GifDecoder';
  property name='frameCount' type='numeric';

  public any function init(required string path) {
    variables.path = arguments.path;
    variables.decoder = createObject('java', 'com.madgag.gif.fmsware.GifDecoder').init();
    var status = decoder.read(arguments.path);
    if (status neq 0) {
      throw('Failed to load GIF (status code: #status#)','GifReadError');
    }
    variables.frameCount = decoder.getFrameCount();
    variables.hints = createObject('java', 'java.awt.RenderingHints');
    return this;
  }

  public boolean function isAnimated() {
    return variables.frameCount > 1;
  }

  public void function resize(required numeric size, required string filename, boolean square=false) {
    var encoder = createObject('java', 'com.madgag.gif.fmsware.AnimatedGifEncoder').init();
    encoder.setRepeat(0);
    encoder.start(filename);

    for (var i = 0; i < variables.frameCount; i++) {
      var frame = clone_frame(decoder.getFrame(i));
      var delay = decoder.getDelay(i);
      var params = resize_params(frame, size);
      var resized = resize_frame(frame, params.width, params.height);
      if (arguments.square) {
        resized = resized.getSubimage(params.cropX, params.cropY, size, size)
      }
      encoder.setDelay(delay);
      encoder.addFrame(resized);
    }
    encoder.finish();
  }

  // PRIVATE

  function clone_frame(required any img) {
    var BufferedImage = createObject('java', 'java.awt.image.BufferedImage');
    var copy = BufferedImage.init(img.getWidth(), img.getHeight(), img.getType());
    var g = copy.createGraphics();
    g.drawImage(img, 0, 0, javacast('null', ''));
    g.dispose();
    return copy;
  }

  function resize_frame(required any img, required numeric width, required numeric height) {
    var BufferedImage = createObject('java', 'java.awt.image.BufferedImage');
    var resized = BufferedImage.init(width, height, img.getType());
    var g2d = resized.createGraphics();
    g2d.setRenderingHint(hints.KEY_INTERPOLATION, hints.VALUE_INTERPOLATION_BILINEAR);
    g2d.drawImage(img.getScaledInstance(width, height, img.SCALE_SMOOTH), 0, 0, width, height, javacast('null', ''));
    g2d.dispose();
    return resized;
  }

  public struct function resize_params(required any frame, required numeric size) {
    var params = {
      size: size,
      width: size,
      height: size
    }
    if (frame.getWidth() <= frame.getHeight()) {
      params.height = round(frame.getHeight() * (size / frame.getWidth()));
    } else {
      params.width = round(frame.getWidth() * (size / frame.getHeight()));
    }
    params.cropX = max((params.width - size) / 2, 0);
    params.cropY = max((params.height - size) / 2, 0);
    return params;
  }
}
