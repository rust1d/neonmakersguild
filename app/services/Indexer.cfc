component {
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

    data = build_images();
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
    if (type=='images') {
      // front.image
      // find the right list, and nav
    }
    if (cur_ben.images.cnt==1) { // SINGLE IMAGE BEN? FIND NEXT BEN, RETURN FIRST IMAGE
      nav_ben = data.entries[direction=='prev' ? cur_ben.nav.first() : cur_ben.nav.last()];
      return nav_ben.images.ids.first();
    }
    var nav_img = cur_ben.images[bei_beiid];
    return direction=='prev' ? nav_img.first() : nav_img.last();
  }

  public numeric function go2(required numeric current_id, string section='front', string type='images', numeric usid=0, string direction='next') {
    if (!listFindNoCase('front,stream,user', arguments.section)) throw('indexer section invalid');
    if (!listFindNoCase('post,images', arguments.type)) throw('indexer type invalid');
    if (!listFindNoCase('prev,next', arguments.direction)) throw('indexer direction invalid');

    var data = index();
    if (type=='post') { // IF POST HAS 1 IMAGE, SWITCH TO IMAGES; NEXT/PREV IS NOW IMAGE ROLL SCROLL
      var entry = data.entries[current_id];
      if (entry.images.len()==1) {
        type=='images';
      } else {

      }
    }
    var entry = data.entries[current_id];
    try {
      if (section=='user') {
        var curr = data[section][type][user].hash[current_id];
      } else {
        var curr = data[section][type].hash[current_id];
      }
      return direction=='prev' ? curr.first() : curr.last();
    } catch (any err) {
      var data = serializeJSON(arguments);
      application.flash.cferror(err);
      application.flash.error(data);
    }
    return current_id;
  }


  // PRIVATE

  public struct function build_images() {
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
      row.images = {}
      row.images.ids = row.ben_beiids.listToArray();
      row.images.cnt = row.images.ids.len();
      row.images.beiid = structNew('ordered');

      for (var idx=1; idx<=row.images.cnt; idx++) {
        var beiid = row.images.ids[idx];
        data.images[beiid] = row;
        set_nav(row.images.ids, row.images.beiid, idx)
      }

      if (row.ben_frontpage) {
        front_ids.append(row.images.ids, true);
      }
      if (row.ben_usid!=1) {
        stream_ids.append(row.images.ids, true);
      }

      if (!users.keyExists(row.ben_usid)) {
        user_ids.append(row.ben_usid)
        users[row.ben_usid] = [];
      }
      users[row.ben_usid].append(row.images.ids, true);
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

  public struct function build_index() {
    // BUILDS A LIGHTWEIGHT INDEX WITH BLOGENTRY PRIMARY KEYS FOR NAVIGATION LOOK
    var data = {
      entries:             structNew('ordered'),
      front.images.array:  [],
      front.images.hash:   structNew('ordered'),
      front.post.array:    [],
      front.post.hash:     structNew('ordered'),
      stream.images.array: [],
      stream.images.hash:  structNew('ordered'),
      stream.post.array:   [],
      stream.post.hash:    structNew('ordered'),
      user.images.array:   structNew('ordered'), // user key hash holds array
      user.images.hash:    structNew('ordered'),
      user.post.array:     structNew('ordered'), // user key hash holds array
      user.post.hash:      structNew('ordered')
    }

    var rows = utility.query_to_array(records());

    // BUILD ARRAYS THAT CONTAIN THE IDS IN THE SORT ORDER
    for (var row in rows) {
      data.entries[row.ben_benid] = row;
      row.images = row.ben_beiids.listToArray();
      // FRONT PAGE INDEX
      if (row.ben_frontpage) {
        data.front.post.array.append(row.ben_benid);
        data.front.images.array.append(row.images, true);
      }
      // MEMBER STREAM
      if (row.ben_usid!=1) {
        data.stream.post.array.append(row.ben_benid);
        data.stream.images.array.append(row.images, true);
      }
      // USER - USID HOLDS ARRAY OF BENIDS
      if (!data.user.post.array.keyExists(row.ben_usid)) data.user.post.array[row.ben_usid] = [];
      data.user.post.array[row.ben_usid].append(row.ben_benid);
      if (!data.user.images.array.keyExists(row.ben_usid)) data.user.images.array[row.ben_usid] = [];
      data.user.images.array[row.ben_usid].append(row.images, true);
    }
    // NOW WE KNOW THE LIST OF IDS IN EACH SECTION AND THE ORDER THEY SHOULD NAVIGATE
    // NOW LOOP OVER THE ARRAY AND BUILD A HASH WITH THE KEY AND STORE AN ARRAY PREV/NEXT IN THAT HASH
    // set_nav WILL BUILD THE ARRAY AND STORE IT IN THE HASH WITH benid OR beiid
    for (key in data.user.post.array) {
      for (var idx=1; idx<=data.user.post.array[key].len(); idx++) {
        var val = data.user.post.array[key][idx];
        data.user.post.hash[key][val] = [];
        set_nav(data.user.post.array[key], data.user.post.hash[key], idx);
      }
    }

    for (key in data.user.images.array) {
      for (var idx=1; idx<=data.user.images.array[key].len(); idx++) {
        var val = data.user.images.array[key][idx];
        data.user.images.hash[key][val] = [];
        set_nav(data.user.images.array[key], data.user.images.hash[key], idx);
      }
    }

    for (var idx=1; idx<=data.front.post.array.len(); idx++) {
      set_nav(data.front.post.array, data.front.post.hash, idx);
    }
    for (var idx=1; idx<=data.front.images.array.len(); idx++) {
      set_nav(data.front.images.array, data.front.images.hash, idx);
    }

    for (var idx=1; idx<=data.stream.post.array.len(); idx++) {
      set_nav(data.stream.post.array, data.stream.post.hash, idx);
    }
    for (var idx=1; idx<=data.stream.images.array.len(); idx++) {
      set_nav(data.stream.images.array, data.stream.images.hash, idx);
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
