
INSERT INTO users (us_usid, us_user, us_password, us_email, us_permissions) VALUES
  (1, 'maker',        '$2a$10$qpPypwMXn5R6yvGamY/jEuGWXagktAy.VNblzZUtq/f.Eq4wqZxke', 'maker@neonmakersguild.org', 3),
  (2, 'admin',        '$2a$10$qpPypwMXn5R6yvGamY/jEuGWXagktAy.VNblzZUtq/f.Eq4wqZxke', 'admin@neonmakersguild.org', 2),
  (3, 'moderator',    '$2a$10$qpPypwMXn5R6yvGamY/jEuGWXagktAy.VNblzZUtq/f.Eq4wqZxke', 'moderator@neonmakersguild.org', 1),
  (4, 'person',       '$2a$10$qpPypwMXn5R6yvGamY/jEuGWXagktAy.VNblzZUtq/f.Eq4wqZxke', 'person@neonmakersguild.org', 0);

INSERT INTO userProfile (up_usid, up_firstname, up_lastname, up_bio, up_location) VALUES
  (1, 'site', 'owner', 'can do anything', 'the throne room'),
  (2, 'admin', 'admin', 'can do almost anything', 'the keeper at the gate'),
  (3, 'moderator', 'moderator', 'can approve stuff', 'the herder of sheep'),
  (4, 'person', 'person', 'can post stuff', 'baa...');


INSERT INTO BlogRoles (bro_broid, bro_role, bro_description) VALUES
  (1, 'Admin', 'A special role for the admin. Allows all functionality.'),
  (2, 'PageAdmin', 'The ability to add pages.'),
  (3, 'ManageUsers', 'The ability to manage blog users.'),
  (4, 'ManageCategories', 'The ability to manage blog categories.'),
  (5, 'AddCategory', 'The ability to create a new category when editing a blog entry.'),
  (6, 'ReleaseEntries', 'The ability to both release a new entry and edit any released entry.');

INSERT INTO BlogUserRoles(bur_usid,bur_broid,bur_blog) VALUES (1,1,1), (2,1,1);


INSERT INTO blogCategories (bca_blog, bca_category, bca_alias) VALUES
  (1, 'General', 'general'),
  (1, 'Bending', 'bending'),
  (1, 'Pumping', 'pumping'),
  (1, 'Selling', 'selling');

INSERT INTO blogPages (bpa_blog, bpa_title, bpa_alias, bpa_body, bpa_standalone) VALUES
  (1, 'About', 'about', '<p>The Neon Makers Guild is an organization dedicated to the preservation of the craft of neon. We offer support, connection, and resources to both seasoned benders and those just beginning their neon journey. We strive for excellence by valuing high standards and adhering to the best practices in the fabrication of neon. We respect neon as a highly specialized skill, honoring those who have dedicated themselves to learning it, advocating for transparency, and crediting the hands that make it.&nbsp;</p>', 0),
  (1, 'Login', 'login', '<p>Hey! Login below.</p>', 1),
  (1, 'Join NeonMakersGuild.org!', 'join', '<h2>Membership in the NMG is $XXX annually and includes all these amazing benefits...</h2>\r\n<ul>\r\n<li>directory of resources</li>\r\n<li>one page listing in our member\'s profile</li>\r\n<li>monthly meet-ups (via zoom or in-person)</li>\r\n<li>Access to our bender\'s forum</li>\r\n<li>monthly newsletter</li>\r\n<li>library and achives</li>\r\n</ul>\r\n<h2>Sounds great! Sign me up!</h2>\r\n<p>Complete this form and send payment to: your mom.</p>', 0),
  (1, 'Resources', 'resources', '<h1>Neon Material Suppliers</h1>\r\n<ul>\r\n<li><a href=\"https://www.brillite.com/index.php\" target=\"_blank\" rel=\"noopener\">FMS Brillite</a></li>\r\n<li><a href=\"https://www.wccdusa.com/\" target=\"_blank\" rel=\"noopener\">West Coast Custom Designs</a></li>\r\n<li><a href=\"http://www.t2-neonpower.com/\" target=\"_blank\" rel=\"noopener\">Tech 22</a></li>\r\n<li><a href=\"http://ablontech.com/\" target=\"_blank\" rel=\"noopener\">Ablon Technologies</a></li>\r\n<li><a href=\"https://www.abitechsupply.com/\" target=\"_blank\" rel=\"noopener\">Abitech Sign Supply</a></li>\r\n<li><a href=\"http://www.agfburner.com/\" target=\"_blank\" rel=\"noopener\">AGF Burner, Inc.</a></li>\r\n<li><a href=\"http://www.monarchneon.com/\" target=\"_blank\" rel=\"noopener\">Monarch Neon Supply</a></li>\r\n</ul>\r\n<hr>\r\n<h1>Neon Classes and Workshops</h1>\r\n<ul>\r\n<li><a href=\"https://www.wnsaseattle.org/\" target=\"_blank\" rel=\"noopener\">Western Neon School of Art</a></li>\r\n<li><a href=\"https://urbanglass.org/classes/category/neon\" target=\"_blank\" rel=\"noopener\">Urban Glass</a></li>\r\n<li><a href=\"https://www.radiantneon.com/book-online\" target=\"_blank\" rel=\"noopener\">Radiant Neon</a></li>\r\n<li><a href=\"https://www.hexneon.com/book-a-class\" target=\"_blank\" rel=\"noopener\">Hex Neon</a></li>\r\n<li><a href=\"http://www.eveningneon.com/learn/neon-workshops/\" target=\"_blank\" rel=\"noopener\">Evening Neon</a></li>\r\n<li><a href=\"https://store.neonmona.org/collections/classes\" target=\"_blank\" rel=\"noopener\">Museum of Neon Art</a></li>\r\n<li><a href=\"https://randomneon.com/the-neon-weekend/\" target=\"_blank\" rel=\"noopener\">Random Neon</a></li>\r\n</ul>', 0);
