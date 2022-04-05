<cfparam name="URL.hashReference" default="">
<cfset variables.captcha = APPLICATION.BLOG.captcha.createCaptchaFromHashReference("file",URL.hashReference) />
<cfcontent type="image/jpg" file="#variables.captcha.fileLocation#" deletefile="true" reset="false" />