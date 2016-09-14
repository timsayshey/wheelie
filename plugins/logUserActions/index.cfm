<h1>Log User Actions 1.1</h1>
<h3>A plugin for <a href="http://cfwheels.org" target="_blank">Coldfusion on Wheels</a> by <a href="http://cfwheels.org/user/profile/24" target="_blank">Andy Bellenie</a></h3>
<p>This plugin allows the automatic completion of user logging fields during insertions, updates and deletes.</p>
<h2>Usage</h2>
<p>Add  logUserActions(userIdLocation[, createProperty, updateProperty, deleteProperty]) to the init of your model to enable the plugin.</p>
<ul>
	<li>userIdLocation (string, required) - the literal name of a variable containing the value you want to store as a user Id, e.g. &quot;session.userId&quot; (not the value itself!)</li>
	<li>createProperty (string, default 'createdBy') - the name of the column you would like to use for logging creates</li>
	<li>updateProperty (string, default 'updatedBy') - the name of the column you would like to use for logging updates</li>
	<li>deleteProperty (string, default 'deletedBy') - the name of the column you would like to use for logging deletes</li>
</ul>
<pre>
&lt;cffunction name=&quot;init&quot;&gt;
	&lt;cfset logUserActions(userIdLocation=&quot;session.userId&quot;)&gt;
&lt;/cffunction&gt;</pre>
<h2>Support</h2>
<p>I try to keep my plugins free from bugs and up to date with Wheels releases, but if you encounter a problem please log an issue using the tracker on github, where you can also browse my other plugins.<br />
<a href="https://github.com/andybellenie" target="_blank">https://github.com/andybellenie</a></p>