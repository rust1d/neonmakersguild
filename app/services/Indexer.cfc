component {
  // handles navigation inside the image modal
  // next/previous depends upon your entry point to the modal
  // opening the modal from a post w/multiple images
  // -- navigation locked to the images on that post in a circular fashion
  // opening modal from single image post
  // -- navigation is now across the underlying section: front page, members stream or member page
  // -- when next is clicked on the last image the first image of the next post should display

  public Indexer function init() {
    variables.utility = application.utility;
    variables.cache_id = 'idx-benid';
    variables.refresh_rate = 10; // minutes

    return this;
  }

  public void function flush_cache() {
    CacheRemove(variables.cache_id);
  }

  public struct function index() {
    var data = cacheGet(variables.cache_id);
    if (!isNull(data)) return data;

    data = build_index();
    cachePut(variables.cache_id, data, createTimeSpan(0, 0, variables.refresh_rate, 0));
    return data;
  }

  public string function get_type(required numeric bei_beiid) {
    var cur_ben = data.images[bei_beiid]; // BEN FOR CURRENT BEI
    return cur_ben.images.cnt==1 ? 'images' : 'post';
  }

  public numeric function go(required numeric bei_beiid, string section='front', string type='images', numeric usid=0, string direction='next') {
    if (!listFindNoCase('front,stream,user', arguments.section)) throw('indexer section invalid');
    if (!listFindNoCase('post,images', arguments.type)) throw('indexer type invalid');
    if (!listFindNoCase('prev,next', arguments.direction)) throw('indexer direction invalid');
    var data = index();
    var cur_ben = data.images[bei_beiid]; // BEN FOR CURRENT BEI
    if (type=='images') { // SINGLE IMAGE ENTRY POINT: ROTATE WITHIN THE SECTION
      var nav = data[section][bei_beiid]; // FIND THE SECTION/CURRENT IMAGE
    } else { // MULTI-IMAGE POST: ROTATE WITHIN THE POST
      var nav = cur_ben.images[bei_beiid]; // FIND THE CURRENT IMAGE
    }
    return direction=='prev' ? nav.first() : nav.last();
  }

  // PRIVATE

  public struct function build_index() {
    var rows = utility.query_to_array(records());
    var benids = rows.map(row=>row.ben_benid);
    var data = {
      entries:  structNew('ordered'), // ALL ENTRIES benid->ben
      images:   structNew('ordered'), // ALL IMAGES  beiid->ben
      front:    structNew('ordered'), // FRONTPAGE   beiid->image.nav
      stream:   structNew('ordered'), // STREAM      beiid->image.nav
      user:     structNew('ordered')
    }
    var nav = {}
    for (var idx=1; idx<=benids.len(); idx++) {
      set_nav(benids, nav, idx);
    }
    var front_ids = [];
    var stream_ids = [];
    var user_ids = [];
    var users = structNew('ordered');

    for (var row in rows) {
      data.entries[row.ben_benid] = row;

      row.nav = nav[row.ben_benid];
      row.images = structNew('ordered');
      row.beiids = row.ben_beiids.listToArray();
      row.image_cnt = row.beiids.len();
      row.images = structNew('ordered');

      for (var idx=1; idx<=row.image_cnt; idx++) {
        var beiid = row.beiids[idx];
        data.images[beiid] = row;
        set_nav(row.beiids, row.images, idx)
      }

      if (row.ben_frontpage) {
        front_ids.append(row.beiids, true);
      }
      if (row.ben_stream) {
        stream_ids.append(row.beiids, true);
      }

      if (!users.keyExists(row.ben_usid)) {
        user_ids.append(row.ben_usid)
        users[row.ben_usid] = [];
      }
      users[row.ben_usid].append(row.beiids, true);
    }

    for (var idx=1; idx<=front_ids.len(); idx++) {
      set_nav(front_ids, data.front, idx);
    }
    for (var idx=1; idx<=stream_ids.len(); idx++) {
      set_nav(stream_ids, data.stream, idx);
    }
    for (var usid in user_ids) {
      var img_ids = users[usid];
      for (var idx=1; idx<=img_ids.len(); idx++) {
        var val = img_ids[idx];
        data.user[usid][val] = [];
        set_nav(img_ids, data.user[usid], idx);
      }
    }
    return data;
  }

  private void function set_nav(arr, hash, idx) {
    var cur = arr[idx];
    var prv = idx==1 ? arr.len() : idx-1;
    var nxt = idx==arr.len() ? 1 : idx+1;
    hash[cur] = [ arr[prv], arr[nxt] ];
  }

  private query function records() {
    // FETCHES ALL benids/usids, A LIST OF THEIR beiids AND FRONTPAGE FLAG
    var sproc = new StoredProc(procedure: 'blogentries_index', datasource: application.dsn);
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: 500);
    return sproc.execute().getProcResultSets().qry;
  }
}
