<cfscript>
  function save_images(required ForumMessages mFM) {
    var flds = form.fieldnames.listToArray().filter(fld => fld.left(4)=='img_');
    if (flds.isEmpty()) return;

    var params = {
      fi_foid:  mFM.foid(),
      fi_ftid:  mFM.ftid(),
      fi_fmid:  mFM.fmid(),
      fi_usid:  mFM.usid()
    }
    for (var fld in flds) {
      params.filefield = fld;
      mFM.ForumImages(build: params).safe_save();
    }
  }
</cfscript>
