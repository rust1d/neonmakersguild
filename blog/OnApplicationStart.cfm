<cfset APPLICATION.CFC.BLOG = StructNew() />

<cfset APPLICATION.BLOG.name = APPLICATION.SETTING.blog />
<!--- load and init blog --->

<cfset APPLICATION.CFC.BLOG = CreateObject("component","org.camden.blog.blog").init(APPLICATION.BLOG.name) />

<cfset APPLICATION.CFC.BLOG.setProperty("owneremail", APPLICATION.EMAIL.admin) />
<cfset APPLICATION.CFC.BLOG.setProperty("failTo", APPLICATION.EMAIL.admin) />
<cfset APPLICATION.CFC.BLOG.setProperty("mailserver", APPLICATION.EMAIL.smtp) />
<cfset APPLICATION.CFC.BLOG.setProperty("mailusername", APPLICATION.EMAIL.user) />
<cfset APPLICATION.CFC.BLOG.setProperty("mailpassword", APPLICATION.EMAIL.pwd) />
<cfset APPLICATION.CFC.BLOG.setProperty("SiteBlog", true) />
<!--- locale related --->
<cfset APPLICATION.BLOG.resourceBundle = createObject("component","org.hastings.locale.resourcebundle")>
<!--- Path may be different if admin. --->
<cfset currentPath = getDirectoryFromPath(getCurrentTemplatePath()) />
<cfset theFile = currentPath & "includes/main" />
<cfset lylaFile = "#APPLICATION.PATH.ROOT#/blog/includes/captcha.xml" />
<cfset slideshowdir = currentPath & "images/slideshows/" & APPLICATION.DISK.BLOGIMG />

<cfset APPLICATION.BLOG.resourceBundle.loadResourceBundle(theFile, APPLICATION.CFC.BLOG.getProperty("locale"))>
<cfset APPLICATION.BLOG.resourceBundleData = APPLICATION.BLOG.resourceBundle.getResourceBundleData()>
<cfset APPLICATION.BLOG.localeutils = createObject("component","org.hastings.locale.utils")>
<cfset APPLICATION.BLOG.localeutils.loadLocale(APPLICATION.CFC.BLOG.getProperty("locale"))>
<!--- load slideshow --->
<cfset APPLICATION.BLOG.slideshow = createObject("component", "org.camden.blog.slideshow").init(slideshowdir)>
<cfset APPLICATION.BLOG.captcha = createObject("component","org.captcha.captchaService").init(configFile="#lylaFile#") />
<cfset APPLICATION.BLOG.captcha.setup() />
<!--- tweetbacks --->
<cfset APPLICATION.BLOG.sweetTweets = createObject("component","org.sweettweets.SweetTweets").init()/>
<!--- clear scopecache --->
<cfmodule template="tags/scopecache.cfm" scope="APPLICATION" clearall="true">

<!--- used for cache purposes is 60 minutes --->
<cfset APPLICATION.BLOG.timeout = 60*60>
<!--- how many entries? --->
<cfset APPLICATION.BLOG.maxEntries = APPLICATION.CFC.BLOG.getProperty("maxentries")>
<!--- Gravatars allowed? --->
<cfset APPLICATION.BLOG.gravatarsAllowed = APPLICATION.CFC.BLOG.getProperty("allowgravatars")>
<!--- Load the Utils CFC --->
<cfset APPLICATION.BLOG.utils = createObject("component", "org.camden.blog.utils")>
<!--- Load the Page CFC --->
<cfset APPLICATION.BLOG.page = createObject("component", "org.camden.blog.page").init(dsn=APPLICATION.DSN.BLOG, blog=APPLICATION.BLOG.name) />
<!--- Load the TB CFC --->
<cfset APPLICATION.BLOG.textblock = createObject("component", "org.camden.blog.textblock").init(dsn=APPLICATION.DSN.BLOG, blog=APPLICATION.BLOG.name) />
<!--- Do we allow file browsing in the admin? --->
<cfset APPLICATION.BLOG.filebrowse = APPLICATION.CFC.BLOG.getProperty("filebrowse")>
<!--- Do we allow settings in the admin? --->
<cfset APPLICATION.BLOG.settings = APPLICATION.CFC.BLOG.getProperty("settings")>
<!--- load pod --->
<cfset APPLICATION.BLOG.pod = createObject("component", "org.camden.blog.pods")>
