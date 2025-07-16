component extends=BaseModel accessors=true {
  property name='bli_bliid'        type='numeric'  sqltype='integer'            primary_key;
  property name='bli_blog'         type='numeric'  sqltype='integer';
  property name='bli_type'         type='string'   sqltype='varchar';
  property name='bli_url'          type='string'   sqltype='varchar';
  property name='bli_title'        type='string'   sqltype='varchar';
  property name='bli_description'  type='string'   sqltype='varchar'            default='';
  property name='bli_clicks'       type='numeric'  sqltype='integer';
  property name='bli_added'        type='date';
  property name='bli_dla'          type='date';

  belongs_to(name: 'UserBlog', class: 'Users', key: 'bli_blog', relation: 'us_usid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'bloglinks_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bli_bliid'), null: !arguments.keyExists('bli_bliid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bli_blog'),  null: !arguments.keyExists('bli_blog'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bli_type'),  null: !arguments.keyExists('bli_type'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),      null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public string function datadash() {
    if (new_record()) return '';
    return serializeJSON({ 'blog': bli_blog, 'pkid': bli_bliid });
  }

  public string function domain() {
    return isNull(variables.bli_url) ? '' : utility.getDomain(bli_url);
  }

  public string function icon_link(string size='fa-2x') {
    if (isNull(variables.bli_url)) return '';
    return "<a href='#bli_url#' class='btn btn-icon btn-icon-link' title='#bli_title#' data-link='#datadash()#' target='_blank'>#icon(size)#</a>";
  }

  public string function icon(string size = 'fa-2x') {
    if (isNull(variables.bli_url)) return 'fa-solid fa-question';
    var type = social_type().lcase();
    var icon = type.len() ? 'fa-brands fa-#type#' : icons().get(bli_type ?: 'bookmark') ?: 'fa-solid fa-question';
    return "<i class='#size# #icon#'></i>";
  }

  public struct function icons() {
    return {
      'bookmark':            'fa-solid fa-fw fa-link',
      'social media':        'fa-brands fa-fw fa-untappd',
      'website':             'fa-solid fa-fw fa-globe',
      'resources-classes':   'fa-solid fa-fw fa-school',
      'resources-other':     'fa-solid fa-fw fa-link',
      'resources-suppliers': 'fa-solid fa-fw fa-truck-field'
    }
  }

  public boolean function isBookmark() {
    return (variables.bli_type ?: '')=='bookmark';
  }

  public boolean function isClass() {
    return (variables.bli_type ?: '')=='resources-classes';
  }

  public boolean function isResource() {
    return ListFirst(variables.bli_type ?: '', '-')=='resource';
  }

  public boolean function isSupplier() {
    return (variables.bli_type ?: '')=='resources-suppliers';
  }

  public boolean function isSocial() {
    if (social_domains().keyExists(domain())) return true;
    return (variables.bli_type ?: '')=='social media';
  }

  public boolean function isWebsite() {
    return (variables.bli_type ?: '')=='website';
  }

  public boolean function recent() {
    return bli_added.add('m', 1) > now();
  }

  public string function social_type() {
    var dom = domain();
    if (dom.len()==0) return '';

    if (social_domains().keyExists(dom)) return social_domains()[dom];
    if (!isSocial()) return '';
    for (var type in social_types()) if (dom.contains(type)) return type;
    return 'unk';
  }

  public struct function social_domains() {
    return {
      'behance.net':      'Behance',
      'blueskyweb.xyz':   'Bluesky',
      'bsky.app':         'Bluesky',
      'discord.com':      'Discord',
      'dribbble.com':     'Dribbble',
      'facebook.com':     'Facebook',
      'flickr.com':       'Flickr',
      'github.com':       'Github',
      'instagram.com':    'Instagram',
      'linkedin.com':     'Linkedin',
      'mastodon.social':  'Mastodon',
      'medium.com':       'Medium',
      'pinterest.com':    'Pinterest',
      'reddit.com':       'Reddit',
      'slack.com':        'Slack',
      'snapchat.com':     'Snapchat',
      'soundcloud.com':   'Soundcloud',
      'spotify.com':      'Spotify',
      't.me':             'Telegram',
      'telegram.me':      'Telegram',
      'threads.net':      'Threads',
      'tiktok.com':       'Tiktok',
      'tumblr.com':       'Tumblr',
      'twitch.tv':        'Twitch',
      'twitter.com':      'Twitter',
      'vimeo.com':        'Vimeo',
      'x.com':            'Twitter',
      'youtu.be':         'Youtube',
      'youtube.com':      'Youtube',
      'whatsapp.com':     'Whatsapp'
    }
  }

  public array function social_types() {
    return listToArray('bluesky,facebook,flickr,instagram,linkedin,pinterest,snapchat,tiktok,twitter,threads,vimeo,youtube');
  }

  public array function types() {
    if (bli_blog==1) return ['resources-classes','resources-other','resources-suppliers','social media'];

    return ['bookmark','social media','website'];
  }



  // PRIVATE

  private void function post_load() {
    if (!isNull(variables.bli_url)) variables.bli_url = utility.url_add_protocol(bli_url);
  }

  private void function pre_save() {
    if (this.url_changed()) {
      variables.bli_url = utility.url_add_protocol(bli_url);
    }
  }


}
