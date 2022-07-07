<cfoutput>
  <h3>Welcome to the Neon Makers Guild!</h3>
  <p>Hello #mUser.UserProfile().firstname()#!</p>
  <p>
    Your new account has been set up with a temporary password. Please login to your
    NeonMakersGuild.org account and change your password as soon as you have a chance.
  </p>
  <hr>
  <p>Login: <a href='#application.urls.root#/login'>#application.urls.root#/login</a></p>
  <p>Username: #mUser.user()#</p>
  <p>Temporary Password: #temp_pwd#</p>
  <hr>
  <p>
    We are excited that you’ve joined us in our mission to strengthen the neon community!
  </p>
  <p>
    We’re building an encouraging and helpful place for all neon makers. In the guild you’ll
    find valuable information if you’re a beginner. And if you’re a seasoned neon maker, we
    welcome your knowledge and offer you a place to find community.
  </p>
  <p>
    As a member you can look forward to regional events, demonstrations, educational content,
    business seminars, and even trivia nights for starters!
  </p>
  <p>
    If you encounter any problems with the website, look for the “?” help icon - hover your cursor
    over it. If that still does not answer your question, email us and we’ll see what we can do.
  </p>
  <h5>Neon Makers Guild Swag</h5>
  <p>
    You get a neat t-shirt to tell the world you’re part of a cool new guild! We’ll be batch
    ordering shirts and you’ll get an update on timing. More merch coming soon!
  </p>
  <p>
    Follow and tag the guild on social media @neonmakersguild and share, comment, and post and
    help us connect to our glass community.
  </p>
</cfoutput>
