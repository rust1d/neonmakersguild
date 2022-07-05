<cfoutput>
  <p>Hello #mUser.UserProfile().firstname()#!</p>
  <p>
    Welcome to the Neon Makers Guild! Your new account has been set up with a temporary
    password. Please login to your NeonMakersGuild.org account and change your password
    as soon as you have a chance.
  </p>
  <p>Login: <a href='#application.urls.root#/login'>#application.urls.root#/login</a></p>
  <p>Username: #mUser.user()#</p>
  <p>Temporary Password: #mUser.temp_pwd()#</p>
</cfoutput>
