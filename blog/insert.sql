
INSERT INTO `blogCategories` (`bca_bcaid`, `bca_name`, `bca_alias`, `blog`) VALUES
('7A8EB00B-C39B-435E-23467B5A5FA3FDFE', 'Test', 'Test', 'BeerInHand'),
('37FB9016-A55B-7D4B-E9C6BA115C2F5D42', 'Lacto', 'Lacto', 'beerinhand'),
('56B6B8A1-A728-A2D8-1DCAC32B22C3AD53', 'Kegs', 'Kegs', 'beerinhand'),
('252D3039-D4BC-89DF-89D6841D4406E904', 'hop aroma', 'hop-aroma', 'barnay42'),
('28BC5085-F2A6-71EE-3D8EA9F94870EBE4', 'late hop additions', 'late-hop-additions', 'barnay42'),
('291A7DE5-C8AA-CA2A-A9656B4F64C88056', 'Mashing', 'Mashing', 'beerinhand'),
('7653C64F-A086-840A-142FCD6EB8AD1D81', 'Barrel Aging', 'Barrel-Aging', 'beerinhand');


INSERT INTO `blogComments` (`id`, `entryidfk`, `name`, `email`, `comment`, `posted`, `subscribe`, `bco_website`, `bco_moderated`, `bco_subscribeonly`, `bco_kill`, `usid`) VALUES
('0D9A1F49-DC4F-5AB9-C4C35B4E4F716C98', '7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE', 'BarNay42', 'tomconville@hotmail.com', 'Dood,\n\nWhere are your tasting notes??', '2012-11-09 18:40:22', 0, 'http://www.beerinhand.com/BarNay42/p.brewer.cfm', 1, 0, '0D9A1F4C-FF2E-ABE0-F472F43E00AD7A68', 14),
('129E20F3-F9CA-9A72-3243CB76DD7213DA', '7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE', 'Boneyard', 'rust1d@usa.net', 'BarNay42 - when editing a recipe look for the Notebook tab. There is an Activity of &quot;Sampled&quot; that you can use. Are you looking for a more formatted/template type of screen?', '2013-02-17 07:06:41', 0, 'http://www.beerinhand.com/Boneyard/p.brewer.cfm', 1, 0, '129E20F5-CF6B-D0B8-DFA198D5BFE142C6', 2),
('16CBD378-EC3F-FC73-545006F8106E689F', '56B6B2B7-955D-DDA2-FAEF987309191A3C', 'custom essay writing service', 'georgelhays@yahoo.com', 'The custom essay writing service is having successful writers for making school and college related essay and dissertation papers. You can get all types of writing process from us. Our writing company is providing perfect and quality set of information for making more essays as success.', '2017-06-27 03:32:54', 0, 'https://www.onlinecustomessaywriting.com/', 0, 0, '16CBD379-FD85-CDDE-747DE6B2CDA6CA1E', 0),
('52818CB3-FE25-2C5B-B59761A9CC7E6AC1', '56B6B2B7-955D-DDA2-FAEF987309191A3C', 'Custom essay writing service', 'danielheller94@yahoo.com', 'Your blog was really very helpful for me and I am very glad to have such a great blog to read. I was wondering that why these things were not in my mind before.', '2017-08-21 23:44:29', 0, 'http://www.writemyessayz.co/', 0, 0, '52818CB4-A2AD-F05E-CA0ABF8AEA477B93', 0);


INSERT INTO `blogEntries` (`id`, `title`, `body`, `posted`, `morebody`, `alias`, `username`, `blog`, `allowcomments`, `enclosure`, `filesize`, `mimetype`, `views`, `released`, `mailed`, `summary`, `subtitle`, `keywords`, `duration`) VALUES
('7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE', 'Is this thing on?', 'Welcome to BeerInHand! Things are dusty around here, but we\'re sweeping up and hope to have this place presentable real soon. In the meantime, create a user account, check out the Recipe Calculator, and drop on by the forums and introduce yourself.', '2012-02-12 12:41:00', NULL, 'test', 'BeerInHand', 'BeerInHand', 1, '', 0, '', 2261, 1, 1, '', '', '', ''),
('37FB8906-C035-A0E9-EDD14F94C5C54D5F', 'Brewing with Yogurt', 'Here\'s an interesting article on making lacto-beers using a culture started with yogurt. Portland brewer, Sean Burke, shared his techniques here:\r\n\r\n<a href=\"http://www.notsoprofessionalbeer.com/2013/09/brewing-with-yogurt.html\">http://www.notsoprofessionalbeer.com/2013/09/brewing-with-yogurt.html</a>', '2013-09-24 18:52:00', NULL, 'Brewing-with-Yogurt', 'BeerInHand', 'beerinhand', 1, '', 0, '', 1870, 1, 1, '', '', '', ''),
('56B6B2B7-955D-DDA2-FAEF987309191A3C', '5 gallon PET Sanke Keg', '<a href=\"http://www.kegworks.com/5-gallon-pet-homebrew-keg-with-us-sankey-coupler-fitting-778-p178096\"><img src=\"http://www.kegworks.com/images/detailed/3200CD-5gal-PET-keg-B4.jpg\" width=\"300\" align=\"right\"  /></a><a href=\"http://www.kegworks.com/5-gallon-pet-homebrew-keg-with-us-sankey-coupler-fitting-778-p178096\">KegWorks.com</a> has 5 gallon PET \"kegs\" with a Sanke fitting for $60. They are essentially a giant PET soda bottle in a plastic shell. Neat, but for my money I\'d stick with a used metal corny keg.', '2013-10-05 07:42:00', NULL, '5-gallon-PET-Sanke-Keg', 'BeerInHand', 'beerinhand', 1, '', 0, '', 2103, 1, 1, '', '', '', ''),
('252D2ADC-0EAC-7B85-5F8434ACF9E05CFA', 'http://www.mrmalty.com/late_hopping.php', 'secret to over-the-top hop flavor and aroma', '2013-10-09 08:04:00', NULL, 'httpwwwmrmaltycomlatehoppingphp', 'BarNay42', 'barnay42', 1, '', 0, '', 697, 1, 1, '', '', '', ''),
('28BC4F36-C86A-157F-6B78C36C6D9C493A', 'discussion on how much bitterness late hop additions make', 'http://discussions.probrewer.com/showthread.php?28064-Hop-Utilization-of-Whirlpool-Additions', '2013-10-09 09:43:00', NULL, 'discussion-on-how-much-bitterness-late-hop-additions-make', 'BarNay42', 'barnay42', 1, '', 0, '', 693, 1, 1, '', '', '', ''),
('28F1E1C9-D3F9-31F5-FB1E96B4318EA5BC', 'BYO discussion on hop additions after the boil', 'http://byo.com/component/k2/item/2808-hop-stands', '2013-10-09 09:49:00', NULL, 'BYO-discussion-on-hop-additions-after-the-boil', 'BarNay42', 'barnay42', 1, '', 0, '', 723, 1, 1, '', '', '', ''),
('291A79C2-BCE1-0937-4BCD5B7AA903496F', 'The \"No Mess, No Guess\" Single Decoction Mash Technique', 'Here\'s a technique I\'ve been using for years to produce single decoction beers with little mess and is almost guarenteed to hit the temp rests. You\'ll need a 3-4 gallon pot that can fit in your oven, in addition to your typical mash tun. The idea is to split the grain bill into a main mash and a mini-mash. The mini-mash will be coverted, boiled and then added to the main mash to hit sacc temps.<br><br>\r\n\r\nFor Example, let\'s say we\'re making a 5 gallon batch of Maibock and using 12 lbs of grain for ~1.062 SG target.<br><br>\r\n\r\nTake 1/3 of the malt (4 lbs) at room temp (~68F) and mix with 1.5 gallons water (1.5 qts/lb) water at 165F to hit 154F. Let it rest for 20-30 mins at this temp to covert and then cover the pot and stick it in your oven at 220F. This temp is high enough to boil the mash without any chance of actually scorching so stirring is optional. I typically let this cook for a couple of hours.<br><br>\r\n\r\nAfter you have your \"decoction\" in the oven happily boiling, you can prepare the main mash. Take the remaining malt (8 lbs at ~68F) and mix with 3 gallons water (1.5 qt/lb) at 129F to hit 122F (50C). Now take the mini-mash from the oven and add it to the main mash to boost the temp to 154F. Proceed to mash and sparge as normal. Sparging will be a bit slower because the mini-mash will have broken down a lot during boiling.<br><br>\r\n\r\nNow onto the math portion - since we have doughed in both mashes at the same malt-to-water ratio, figuring out the temp after mixing them is pretty easy:<br><br>\r\n\r\n((4 * 212F) + (8 * 122F) ) / 12 = 152F<br><br>\r\n\r\n\r\nIf we mix only 1/2 of the mini-mash in, we can hit the classic 140F/50C rest:<br><br>\r\n\r\n((2 * 212F) + (8 * 122F) ) / 10 = 140F<br><br>\r\n\r\nthen adding the remaining portion will get us to sacc temps:<br><br>\r\n\r\n((2 * 212F) + (10 * 140F) ) / 12 = 152F<br><br>\r\n\r\n\r\nYou can adjust the malt-to-liquor ratio and everything still works fine so long as it\'s the same for both mashes. I typically use 2 qts per lb and have never had any issue with lack of enzymes. The math gets more complicated when you start varying the liquor ratios between mashes, but it is still not difficult. That is left as an exercise for the reader.<br><br>\r\n\r\nThese calculations do not take into account the thermal mass of your mash tun. A couple of extra quarts of boiling water help to adjust the final temps as needed.<br><br>\r\n\r\nThe advantages here are the things are pre-measured while cool and you don\'t have to muck around with scooping sticky hot mash and potential burns. Be careful to slowly scoop the mini-mash into the main mash, I have been splashed with hot mash by dumping the entire mini-mash directly into the main mash.<br><br>\r\n\r\nHopefully this removes some of the fear of trying a decoction mash.<br><br>\r\n\r\n<a href=\"http://www.beerandloafing.org/hbd/fetch.php?id=64412\">Mashing formulas</a>\r\n\r\n<a href=\"http://hbd.org/hbd/archive/2926.html#2926-16\">ancient post on this subject</a>', '2013-10-19 08:27:00', NULL, 'The-No-Mess-No-Guess-Single-Decoction-Mash-Technique', 'BeerInHand', 'beerinhand', 1, '', 0, '', 1823, 1, 1, '', '', '', ''),
('7653BFF9-921C-5CA7-7FA23D9EA5E60640', 'Want to try oak aging a beer?', 'Here\'s a great source of cheap, new, barrels -\r\n\r\n<a href=\"http://www.barrelsonline.com/BrowseProducts.aspx?DepID=5\">http://www.barrelsonline.com/</a>.\r\n\r\nPrices start at $27 dollars for 1 liter barrel and a 20 liter (~5 gallon) can be had for $100.\r\n\r\nThat\'s pretty cheap.', '2013-11-04 17:22:00', NULL, 'Want-to-try-oak-aging-a-beer', 'BeerInHand', 'beerinhand', 1, '', 0, '', 1885, 1, 1, '', '', '', '');


INSERT INTO `blogEntriescategories` (`  bec_bcaid`, `entryidfk`) VALUES
('252D3039-D4BC-89DF-89D6841D4406E904', '252D2ADC-0EAC-7B85-5F8434ACF9E05CFA'),
('252D3039-D4BC-89DF-89D6841D4406E904', '28BC4F36-C86A-157F-6B78C36C6D9C493A'),
('28BC5085-F2A6-71EE-3D8EA9F94870EBE4', '28BC4F36-C86A-157F-6B78C36C6D9C493A'),
('28BC5085-F2A6-71EE-3D8EA9F94870EBE4', '28F1E1C9-D3F9-31F5-FB1E96B4318EA5BC'),
('291A7DE5-C8AA-CA2A-A9656B4F64C88056', '291A79C2-BCE1-0937-4BCD5B7AA903496F'),
('37FB9016-A55B-7D4B-E9C6BA115C2F5D42', '37FB8906-C035-A0E9-EDD14F94C5C54D5F'),
('7A8EB00B-C39B-435E-23467B5A5FA3FDFE', '37FB8906-C035-A0E9-EDD14F94C5C54D5F'),
('56B6B8A1-A728-A2D8-1DCAC32B22C3AD53', '56B6B2B7-955D-DDA2-FAEF987309191A3C'),
('7653C64F-A086-840A-142FCD6EB8AD1D81', '7653BFF9-921C-5CA7-7FA23D9EA5E60640'),
('7A8EB00B-C39B-435E-23467B5A5FA3FDFE', '7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE');


INSERT INTO `blogRoles` (`id`, `role`, `description`) VALUES
('7F183B27-FEDE-0D6F-E2E9C35DBC7BFF19', 'AddCategory', 'The ability to create a new category when editing a blog entry.'),
('7F197F53-CFF7-18C8-53D0C85FCC2CA3F9', 'ManageCategories', 'The ability to manage blog categories.'),
('7F25A20B-EE6D-612D-24A7C0CEE6483EC2', 'Admin', 'A special role for the admin. Allows all functionality.'),
('7F26DA6C-9F03-567F-ACFD34F62FB77199', 'ManageUsers', 'The ability to manage blog users.'),
('800CA7AA-0190-5329-D3C7753A59EA2589', 'ReleaseEntries', 'The ability to both release a new entry and edit any released entry.');


INSERT INTO `blogSubscribers` (`email`, `token`, `blog`, `verified`) VALUES
('jac@jac.com', 'D71BBF82-BAD8-B0A0-7F22F791D02B631F', 'Default', 0);


INSERT INTO `blogUserroles` (`username`, `roleidfk`, `blog`) VALUES
('BeerInHand', '7F25A20B-EE6D-612D-24A7C0CEE6483EC2', 'BeerInHand');


INSERT INTO `blogUsers` (`username`, `password`, `salt`, `name`, `blog`) VALUES
('BeerInHand', '6920E2B6FC86925FF4ED4A4532A10D0F8FFDB117EA9B5300A4B6CDE3FF0E1B677DFAAA65C94813AE99421D13B8F93891683C0F78A80299A6D0CE53D032666857', 'tcuz00zltlc7YL0sdvUQ1jZx/n0DQU8D1xzLt+lcKUw=', 'John Varady', 'BeerInHand');
