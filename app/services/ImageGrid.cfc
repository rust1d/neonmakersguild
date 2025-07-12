component {
  public ImageGrid function init(required array images, required string section, struct params={}) {
    variables.images = arguments.images;
    variables.section = arguments.section;
    variables.params = arguments.params;
    param variables.params.image_class = '';
    param variables.params.row_class = '';
    variables.type = variables.images.len()==1 ? 'images' : 'post';
    variables.utility = request.utility;

    return this;
  }

  string function layout(numeric limit=0) {
    var cnt = variables.images.len();
    var imgs = variables.images;
    if (limit && limit < cnt) {
      imgs = imgs.slice(1, limit);
      cnt -= limit;
      imgs[limit].store('remaining', cnt);
    }
    return '<div class="row mx-0 g-0 image-grid #variables.params.row_class#">' &  grid_cols(imgs) & '</div>';
  }

  // PRIVATE

  string function grid_cols(required array imgs) {
    var cnt = arguments.imgs.len();
    if (cnt==1) return layout_1(arguments.imgs.first());
    if (cnt==2) return layout_x(arguments.imgs);
    if (cnt%3==0) {
      var groups = application.utility.groups_of(arguments.imgs, 3);
      var trs = layout3xy(groups[1]);
      for (var idx=2;idx<=groups.len();idx++) {
        trs &= layout_x(groups[idx]);
      }
      return trs;
    }
    if (cnt==5) return layout_x(arguments.imgs.slice(1,2)) & layout_x(arguments.imgs.slice(3,3));

    return layout_x(arguments.imgs.slice(1,2)) & grid_cols(arguments.imgs.slice(3));
  }

  private string function img(required UserImages mUI, string src) {
    param arguments.src = mUI.thumbnail_src();
    var beiid = utility.encode(mUI.beiid());
    var data = "<img data-section='#section#' data-type='#type#' data-beiid='#beiid#' src='#arguments.src#' title='#mUI.caption()#' class='#variables.params.image_class#' />"; // data-uiid='#mUI.encoded_key()#'
    if (mUI.stored('remaining')) {
      data = '<div class="position-relative">#data#<span class="remaining">+#mUI.fetch('remaining')#</span></div>';
    }
    return data;
  }

  private string function layout_1(required UserImages mUI) {
    return "<div class='col-12'>#img(mUI, mUI.image_src())#</div>";
  }

  private string function layout_x(required array imgs) {
    var col = 12 / arguments.imgs.len();
    var data = '';
    for (var mUI in arguments.imgs) {
      data &= "<div class='col-#col#'>#img(mUI)#</div>";
    }
    return data;
  }

  private string function layout3xy(required array imgs) {
    return "
      <div class='col-8'>
        #img(arguments.imgs[1])#
      </div>
      <div class='col-4'>
        <div class='row h-100'>
          <div class='col-12'>
            #img(arguments.imgs[2])#
          </div>
          <div class='col-12'>
            #img(arguments.imgs[3])#
          </div>
        </div>
      </div>
    ";
  }
}