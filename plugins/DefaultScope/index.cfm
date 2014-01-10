<h1>DefaultScope</h1>

<p>
	The DefaultScope plugin seeks to add the functionality of Rails' <a href="http://api.rubyonrails.org/classes/ActiveRecord/Base.html#M002313">ActiveRecord::Base&#35;default_scope</a> to Wheels. While you can use <code>set()</code> right now in Wheels to alter the global defaults of the <code>findAll()</code> method, you can't set a scope for individual models. With this plugin, you can specify default values for the <code>findAll()</code> method on a specific model.
</p>

<p>
	This plugin overrides the <code>findAll()</code> method and adds a new method called <code>defaultScope()</code>.
</p>

<h2>New Methods</h2>
<ul>
	<li>defaultScope([ <em>where, order, select, distinct, include, maxRows, page, perPage, count, handle, cache, reload, parameterize, returnAs, returnIncluded</em> ])</li>
</ul>

<p>
	This method is mixed in to your Models and is meant to be invoked from the <code>init()</code> method. It takes all of the same optional arguments as the <code>findAll()</code> method, and will set them as defaults for future calls to that method.
</p>

<pre>
&lt;!--- in any model ---&gt;
&lt;cffunction name="init"&gt;
	&lt;!--- assume we have a model containing user information, and
		you want to sort by the last name then first for most of your
		findAll() requests.  ---&gt;
	&lt;cfset defaultScope(order="lastName, firstName") /&gt;
&lt;/cffunction&gt;
</pre>

<h2>Overridden Methods</h2>
<ul>
	<li>findAll()</li>
</ul>

<p>
	While this method has been overridden in order to accommodate the new defaultScope settings, it still behaves the same as it did before. Use it the way you normally would. Just remember that you might have set some values in the <code>defaultScope()</code>. If you set new values for the same parameters here, those values will override the values set in <code>defaultScope()</code>.
</p>

<h2>How to Use</h2>

<p>Install it! Then the new method is automatically available to you.</p>

<h2>Uninstallation</h2>

<p>All you need to do is delete the <tt>/plugins/DefaultScope-x.x.zip</tt> file.</p>

<h2>Thanks</h2>

<p>
	To the rather active <a href="http://groups.google.com/group/cfwheels">CFWheels Google group</a>, and especially <a href="http://iamjamesgibson.com">James Gibson</a> who helped squirrel out an annoying bug during the initial development.
</p>

<h2>Release History</h2>

<ul>
	<li>2010-04-05 -- 0.6.3
		<ul>
			<li>Compatibility update, through CFWheels 1.0.3</li>
			<li>Fixing typo in column statistics methods</li>
		</ul>
	</li>
	<li>2009-12-19 -- 0.6.2
		<ul>
			<li>fix for DefaultScope causing issues with the calculations methods (andybellenie)</li>
		</ul>
	</li>
	<li>2009-12-09 -- 0.6.1
		<ul>
			<li>code cleanup</li>
			<li>slight change to how the methods determine valid arguments for <code>findAll()</code> and <code>defaultScope()</code></li>
		</ul>
	</li>
	<li>2009-12-08 -- 0.6
		<ul>
			<li>reduced loop overhead and simplified code (andybellenie)</li>
		</ul>
	</li>
	<li>2009-12-07 -- 0.5
		<ul>
			<li>initial public release</li>
			<li>feature complete but probably bug-ridden</li>
		</ul>
	</li>
	<li>2009-12-05 -- 0.1
		<ul>
			<li>happy birthday</li>
		</ul>
	</li>
</ul>

<h2>Problems/Known Issues</h2>

<ul>
	<li>If for some reason you decide to use ordered arguments rather than named arguments, then it won't work. The new <code>findAll()</code> expects named arguments only.</li>
	<li>The plugin could do with some testing and better documentation. Also, it would probably be good to steer away from my ... unorthodox method of defining arguments for methods.</li>
	<li>There's no consideration for environment at this time. It might be a good idea to cache the values from <code>defaultScope()</code> if you're in production mode. I need to learn how to do that.</li>
	<li><code>findAll()</code> is used by the calculations methods (count, sum, average, etc.), which due to the SQL methods they use can't take an 'order' parameter. These methods are not making sure this parameter isn't being passed to <code>findAll()</code>, so this plugin now strips out the 'order' parameter before the calculations methods run. (Thanks, andybellenie, and you can see his path request for CFWheels to fix this at <a href="http://code.google.com/p/cfwheels/issues/detail?id=366">http://code.google.com/p/cfwheels/issues/detail?id=366</a>)</li>
</ul>

<h2>License</h2>

<p>(The MIT License)</p>

<p>Copyright (c) 2009 Joshua Clingenpeel</p>

<p>Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:</p>

<p>The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.</p>

<p>THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>