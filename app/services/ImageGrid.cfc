component {
  public ImageGrid function init(struct params={}) {
    variables.params = arguments.params;
    param variables.params.image_class = '';
    param variables.params.row_class = '';
    variables.utility = request.utility;

    return this;
  }

  string function layout(required array mUIs, numeric limit=0) {
    var cnt = arguments.mUIs.len();
    var imgs = arguments.mUIs;
    if (limit && limit < cnt) {
      imgs = imgs.slice(1, limit);
      cnt -= limit;
      imgs[limit].store('remaining', cnt);
    }
    return '<div class="row mx-0 g-0 image-grid #variables.params.row_class#">' &  grid_cols(imgs) & '</div>';
  }

  // PRIVATE

  string function grid_cols(required array mUIs) {
    var cnt = arguments.mUIs.len();
    if (cnt==1) return layout_1(arguments.mUIs.first());
    if (cnt==2) return layout_x(arguments.mUIs);
    if (cnt%3==0) {
      var groups = application.utility.groups_of(arguments.mUIs, 3);
      var trs = layout3xy(groups[1]);
      for (var idx=2;idx<=groups.len();idx++) {
        trs &= layout_x(groups[idx]);
      }
      return trs;
    }
    if (cnt==5) return layout_x(arguments.mUIs.slice(1,2)) & layout_x(arguments.mUIs.slice(3,3));

    return layout_x(arguments.mUIs.slice(1,2)) & grid_cols(arguments.mUIs.slice(3));
  }

  private string function img(required UserImages mUI, string src) {
    param arguments.src = mUI.thumbnail_src();
    var beiid = utility.encode(mUI.beiid());
    var data = "<img data-beiid='#beiid#' data-uiid='#mUI.encoded_key()#' src='#arguments.src#' title='#mUI.caption()#' class='#variables.params.image_class#' />";
    if (mUI.stored('remaining')) {
      data = '<div class="position-relative">#data#<span class="remaining">+#mUI.fetch('remaining')#</span></div>';
    }
    return data;
  }

  private string function layout_1(required UserImages mUI) {
    return "<div class='col-12'>#img(mUI, mUI.image_src())#</div>";
  }

  private string function layout_x(required array mUIs) {
    var col = 12 / arguments.mUIs.len();
    var data = '';
    for (var mUI in arguments.mUIs) {
      data &= "<div class='col-#col#'>#img(mUI)#</div>";
    }
    return data;
  }

  private string function layout3xy(required array mUIs) {
    return "
      <div class='col-8'>
        #img(arguments.mUIs[1])#
      </div>
      <div class='col-4'>
        <div class='row h-100'>
          <div class='col-12'>
            #img(arguments.mUIs[2])#
          </div>
          <div class='col-12'>
            #img(arguments.mUIs[3])#
          </div>
        </div>
      </div>
    ";
  }
}