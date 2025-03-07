<cfoutput>
  <h3>Welcome to the Neon Makers Guild #mUser.UserProfile().firstname()#!</h3>
  <p>
    Your new account has been set up with a temporary password. Please login to your
    NeonMakersGuild.org account and change your password to secure your account as
    soon as you have a chance.
  </p>
  <hr>
  <p>Login: <a href='#application.urls.root#/login'>#application.urls.root#/login</a></p>
  <p>Username: #mUser.user()#</p>
  <p>Temporary Password: #temp_pwd#</p>
  <hr>

  <p>
    We're building an encouraging and helpful place for all neon makers. In the guild, you'll find valuable information
    whether you're a beginner or a seasoned neon maker. We welcome all levels, and offer you a place to find community.
    You can look forward to regional events, demonstrations, educational content, social zooms, and more!
  </p>

  <h5>Website</h5>
  <p>
    Please take a few moments to login to your membership account to get familiar with the features of our website:
    <a href='#application.urls.root#'>#application.urls.root#</a>.
    As a member, you have the benefit of creating your own member profile page where you can add images, links and
    make blog posts. You also have access to our digital library. Make sure to subscribe to our website forums to get
    notifications when there are new posts. Look for the yellow subscribe button at the upper left side of the screen.
    If you encounter any problems with the website, look for the <code>?</code> help icon - hover your cursor over it.
    If that still does not answer your question, email us and we'll see what we can do.
  </p>

  <p>
    We are excited that you've joined us in our mission to strengthen the neon community.
    And be on the lookout for your new Neon Makers Guild t-shirt, arriving in your mailbox soon!
  </p>
</cfoutput>
