component {
  // META CODE - DEFINES A PUBLIC FUNCTION FOR EACH SOCIAL ICON TYPE
  for (method in 'facebook,flickr,instagram,linkedin,messenger,pinterest,twitter_tweet,youtube_video') {
    variables[method] = function(string size = '128') {
      var data = GetFunctionCalledName() & '_' & size & '.png';
      return 'assets/images/social_icons/' & data;
    }
  }
}
