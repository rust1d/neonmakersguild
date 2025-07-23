component {
  public BlogEntries function create(required Users mUser, numeric benid=0) {
    variables.mUser = arguments.mUser;
    variables.mBE = mUser.blog().entry_find_or_create(arguments.benid);
    if (form.keyExists('btnLater')) form.ben_released = false;
    param form.ben_released = false;
    param form.ben_comments = false;
    param form.beiids = '';
    form.ben_posted = post_date();
    mBE.set(form);
    if (mBE.repost()) { // TEST FOR SAME POST IN 1 MINUTE
      application.flash.warning('Double post caught.');
      return mBE;
    }
    if (mBE.safe_save()) {
      save_images();
      save_captions();
      mBE.BlogEntryImages(reset: true);
      application.flash.success('Your entry was saved.');
    }
    return mBE;
  }

  // PRIVATE

  private array function field_filter(required string pre) {
    var match = arguments.pre;
    return form.fieldnames.listToArray().filter(fld => fld.left(match.len())==match);
  }

  private date function post_date() {
    param form.ben_schedule = 0;
    if (form.ben_schedule==0) return now();
    try {
      if (isDate(form.ben_date & ' ' & form.ben_time)) return ParseDateTime(form.ben_date & ' ' & form.ben_time);
      if (isDate(form.ben_date)) return ParseDateTime(form.ben_date & ' 23:59:59');
    } catch (any err) {
    }
    return now();
  }

  private void function save_captions() {
    for (var fld in field_filter('bei_caption_')) {
      var enc = fld.listToArray('_').pop();
      var beiid = request.utility.decode(enc); // pop off last el, should be id
      if (beiid) {
        var mBEI = mBE.BlogEntryImages(detect: { bei_beiid: beiid });
        if (!isNull(mBEI)) {
          mBEI.set(bei_caption: form[fld]).safe_save();
        }
      }
    }
  }

  private void function save_images() {
    // PROCESS DELETIONS
    for (var enc in form.beiids) {
      var beiid = request.utility.decode(enc);
      if (beiid) {
        var mBEI = mBE.BlogEntryImages(detect: { bei_beiid: beiid });
        if (!isNull(mBEI)) {
          mBEI.destroy();
          application.flash.success('#mBEI.UserImage().filename()# removed from post.');
        }
      }
    }
    // PROCESS INSERTS
    for (var fld in field_filter('img_')) {
      mUI = mUser.UserImages(build: { filefield: fld });
      if (mUI.safe_save()) {
        var params = {
          bei_benid:  mBE.benid(),
          bei_uiid:  mUI.uiid()
        }
        // SAVE CAPTION
        if (form.keyExists('cap_#fld#')) params.bei_caption = form['cap_#fld#'];
        mBE.BlogEntryImages(build: params).safe_save();
      }
    }
  }
}
