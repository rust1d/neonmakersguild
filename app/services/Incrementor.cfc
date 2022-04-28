component {
  public struct function inc(required string field, required numeric blog, required numeric pkid) {
    if (field=='bloglink') {
      queryExecute(
        'UPDATE bloglinks SET bli_clicks = bli_clicks + 1, bli_dla = now() WHERE bli_blog = :blog AND bli_bliid = :pkid',
        { blog: { value: arguments.blog, cfsqltype: 'integer' }, pkid: { value: arguments.pkid, cfsqltype: 'integer' } },
        { datasource: application.dsn }
      );
      return { 'clicks': new app.models.BlogLinks().search(bli_bliid: pkid).getRow(1).bli_clicks };
    }
  }

  public struct function link(required numeric blog, required numeric pkid) {
    return inc('bloglink', blog, pkid);
  }
}
