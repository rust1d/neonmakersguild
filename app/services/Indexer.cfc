component {
  public Indexer function init() {
    variables.utility = request.utility;
    variables.index = {
      front.post.array:    [],
      stream.post.array:   [],
      user.post.array:     structNew('ordered'),

      front.post.hash:    structNew('ordered'),
      stream.post.hash:   structNew('ordered'),
      user.post.hash:     structNew('ordered'),

      front.images.array:  [],
      stream.images.array: [],
      user.images.array:   structNew('ordered'),

      front.images.hash:  structNew('ordered'),
      stream.images.hash: structNew('ordered'),
      user.images.hash:   structNew('ordered')
    }

    load();

    return this;
  }

  public struct function _index() {
    return variables.index;
  }

  public numeric function go(required numeric current_benid, string type='front', string style='post', numeric usid=0, string direction='next') {
    try {
      if (type=='user') {
        var data = index[type][style][user].hash[current_benid];
      } else {
        var data = index[type][style].hash[current_benid];
      }
      if (direction=='prev') return data.first();
      return data.last();
    } catch (any err) {}
    return current_benid;
  }

  // PRIVATE

  private void function load() {
    var rows = utility.query_to_array(records());
    // index.arrayll = rows.map(row=>row.ben_benid);

    for (var row in rows) {
      row.images = row.ben_beiids.listToArray();
      // index.arrayll.post.hash[row.ben_benid] = row;

      // FRONT PAGE INDEX
      if (row.ben_frontpage) {
        index.front.post.array.append(row.ben_benid);
        index.front.images.array.append(row.images, true);
      }
      // MEMBER STREAM
      if (row.ben_usid!=1) {
        index.stream.post.array.append(row.ben_benid);
        index.stream.images.array.append(row.images, true);
      }
      // USER - USID HOLDS ARRAY OF BENIDS
      if (!index.user.post.array.keyExists(row.ben_usid)) index.user.post.array[row.ben_usid] = [];
      index.user.post.array[row.ben_usid].append(row.ben_benid);

      if (!index.user.images.array.keyExists(row.ben_usid)) index.user.images.array[row.ben_usid] = [];
      index.user.images.array[row.ben_usid].append(row.images, true);
    }

    for (key in index.user.post.array) {
      for (var idx=1; idx<=index.user.post.array[key].len(); idx++) {
        var val = index.user.post.array[key][idx];
        index.user.post.hash[key][val] = [];
        set_nav(index.user.post.array[key], index.user.post.hash[key], idx);
      }
    }

    for (key in index.user.images.array) {
      for (var idx=1; idx<=index.user.images.array[key].len(); idx++) {
        var val = index.user.images.array[key][idx];
        index.user.images.hash[key][val] = [];
        set_nav(index.user.images.array[key], index.user.images.hash[key], idx);
      }
    }

    for (var idx=1; idx<=index.front.post.array.len(); idx++) {
      set_nav(index.front.post.array, index.front.post.hash, idx);
    }
    for (var idx=1; idx<=index.front.images.array.len(); idx++) {
      set_nav(index.front.images.array, index.front.images.hash, idx);
    }

    for (var idx=1; idx<=index.stream.post.array.len(); idx++) {
      set_nav(index.stream.post.array, index.stream.post.hash, idx);
    }
    for (var idx=1; idx<=index.stream.images.array.len(); idx++) {
      set_nav(index.stream.images.array, index.stream.images.hash, idx);
    }

  }

  private void function set_nav(arr, hash, idx) {
    var cur = arr[idx];
    var prv = idx==1 ? arr.len() : idx-1;
    var nxt = idx==arr.len() ? 1 : idx+1;
    hash[cur] = [ arr[prv], arr[nxt] ];
  }

  private query function records() {
    var sproc = new StoredProc(procedure: 'blogentries_index', datasource: application.dsn);
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: 500);
    return sproc.execute().getProcResultSets().qry;
  }
}
