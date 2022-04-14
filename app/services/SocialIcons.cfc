component {
  public SocialIcons function init(array mLinks = []) {
    variables.mLinks = arguments.mLinks;

    // META CODE - DEFINES A PUBLIC FUNCTION FOR EACH SOCIAL ICON TYPE
    for (method in types()) {
      variables[method] = function() {
        return img_for(GetFunctionCalledName());
      }
    }

    return this;
  }

  public array function links() {
    return mLinks.map(row => row.social_link());
    // var data = [];
    // for (var type in types()) {
    //   data.append(social_link(type));
    // }
    // return data;
  }

  public string function social_link(required string type) {
    var matches = links_for(type);
    return (matches.len()==0) ? '' : matches.first().social_link();
  }

  public array function types() {
    return listToArray('facebook,flickr,instagram,linkedin,pinterest,snapchat,twitter,vimeo,youtube');
  }

  // PRIVATE

  private string function generate(required BlogLinks mLink) {
    var img = img_for(type);
    return '<a href="#mLink.url()#" target="_blank"><img class="img-thumbnail filter-green" src="#img#" width="64"></a>';
  }

  private string function img_for(required string type) {
    return '/assets/images/svg/#type#.svg';
  }

  private array function links_for(required string type) {
    return mLinks.filter(mLink => mLink.domain().contains(type));
  }
}
