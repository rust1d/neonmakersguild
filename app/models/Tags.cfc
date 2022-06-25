component extends=BaseModel accessors=true {
  property name='tag_tagid'  type='numeric'  sqltype='integer'  primary_key;
  property name='tag_blog'   type='numeric'  sqltype='integer';
  property name='tag_tag'    type='string'   sqltype='varchar';
  property name='doc_count'  type='numeric';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'tags_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('tag_tagid'), null: !arguments.keyExists('tag_tagid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('tag_blog'),  null: !arguments.keyExists('tag_blog'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('tag_tag'),   null: !arguments.keyExists('tag_tag'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return paged_search(sproc, arguments);
  }

  public array function save_tags(required numeric blog, required string data) { // ACCEPTS CSV OF EXISTING IDS/NEW TAGS AND RETURNS LIST OF IDS
    var tag_ids = [];
    for (var tag in DeserializeJSON('[#data#]')) { // USE DESERIALIZE SINCE THE LIST COULD HAVE QUOTED STRINGS WITH DELIMITERS INSIDE
      var params = { tag_blog: blog }
      if (isNumeric(tag)) {
        params.tag_tagid = tag;
      } else {
        params.tag_tag = tag;
      }
      var qry = search(params);
      if (qry.len()) {
        tag_ids.append(qry.tag_tagid);
      } else {
        var mdl = new app.models.Tags(tag_tag: tag, tag_blog: blog);
        if (mdl.safe_save()) tag_ids.append(mdl.tagid());
      }
    }
    return tag_ids;
  }
}
