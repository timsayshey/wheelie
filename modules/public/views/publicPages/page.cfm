<cfoutput>

<section class="page-wrapper">

	<cfif subMenuItems.recordcount>
		<nav class="page-nav">
		  <ul>
			
				<cfif activeMenuItem.parentid eq 0>
					<li><a href="#activeMenuItem.urlPath#" class="current">#activeMenuItem.name#</a></li>
				<cfelseif len(activeParent.urlPath)>
					<li><a href="#activeParent.urlPath#">#activeParent.name#</a></li>
				</cfif>		
				
				<cfloop query="subMenuItems">
					<li><a href="#subMenuItems.urlPath#"
							<cfif subMenuItems.id eq activeMenuItem.id>
								class="current"
							</cfif>
					>#subMenuItems.name#</a></li>
				</cfloop>
		  </ul>
		</nav>
	
		<article class="page-content">	
	<cfelse>
		<article class="page-content-full">
	</cfif>
		
		<h1>#capitalize(page.name)#</h1>
		
		<p>#page.content#</p>

		<!--- <p><strong>Ghost is a platform dedicated to one thing: Publishing.</strong> It's beautifully designed, completely customisable and completely Open Source. Ghost allows you to write and publish your own blog, giving you the tools to make it easy and even fun to do. It's simple, elegant, and designed so that you can spend less time messing with making your blog work - and more time blogging.</p>

		<h2>The Story So Far</h2>

		<p>In late 2012, <a href="http://twitter.com/JohnONolan">John O'Nolan</a> put together a <a href="http://john.onolan.org/ghost">post</a> with some wireframes about his idea for a new blogging platform. After years of frustration building blogs with existing solutions, he wrote a concept for a fictional platform that would be once more about online publishing rather than building complex websites. After a few hundred thousand pageviews in the space of a few days, he realised that other people were looking for the same thing.</p>

		<p>Six months later, after many hours of hard work, Ghost was revealed the public  for the first time <a href="http://www.kickstarter.com/projects/johnonolan/ghost-just-a-blogging-platform">on Kickstarter</a>. It raised more than $100,000 in the first 48 hours of funding, and went on to triple that figure within its 29 day funding period. Having brought on <a href="http://twitter.com/erisds">Hannah Wolfe</a> as the development lead for the project, the Ghost prototype received more attention than ever before as people finally saw the platform in action.</p>

		<h2>What People Are Saying</h2>

		<blockquote>
			<p>"If Mr. O’Nolan and Ghost deliver on their big idea that is now a funded project, content innovation may return to the forefront of disruptive conversation."&nbsp;</p>
			<cite><a href="http://www.forbes.com/sites/andyellwood/2013/04/30/innovation-in-creation/">Forbes</a></cite>
		</blockquote>

		<blockquote>
			<p>"Ghost aims to reboot blogging ... a combination of user-focused design, open-source code &amp; non-profit company"</p>
			<cite><a href="http://www.wired.co.uk/news/archive/2013-05/10/ghost">Wired</a></cite>
		</blockquote>

		<blockquote>
			<p>"Ghost will take your boring blog to the next astral plane ...  it looks so darn beautiful."</p>
			<cite><a href="http://techcrunch.com/2013/05/07/ghost-will-take-your-boring-blog-to-the-next-astral-plane/">TechCrunch</a></cite>
		</blockquote>

		<blockquote>
			<p>"Is This Kickstarter Project the Future of Blogging?"</p>
			<cite><a href="http://mashable.com/2013/05/25/ghost-kickstarter-blogging/">Mashable</a></cite>
		</blockquote>

		<blockquote>
			<p>"a simply, elegantly designed and useful interface ... I’m really excited to see this developed"</p>
			<cite><a href="http://www.problogger.net/archives/2013/05/01/check-out-the-new-ghost-blogging-platform-kickstarter-funded-in-under-12-hours/">ProBlogger</a></cite>
		</blockquote>

		<h2>So How Can I Use It?</h2>

		<p>Ghost is currently being actively developed by a small and incredibly talented team of designers and developers. It is planned to be released fully and publicly for the first time towards the end of Summer 2013.</p>

		<p>There are some <a href="contribute.html">newsletters</a> you can subscribe to for updates.</p> --->

	</article>

</section>

</cfoutput>