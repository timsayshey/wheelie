<h1>CFWheels Nested errorMessageOn Plugin</h1>

<p>
	This plugin overrides <tt>errorMessageOn</tt> to accept arguments for nested properties. Basically, you can now use
	<tt>association</tt> and <tt>position</tt> arguments for your nested properties' error messages.
</p>

<h2>Example</h1>

<p>
	<tt>user</tt> model with <tt>photos</tt> association:
</p>

<pre>
// In `init` method of `models/User.cfc`
hasMany("photos");
nestedProperties(association="photos", allowDelete=true);</pre>

<p>
	Photos partial call in <tt>views/users/_form.cfm</tt> loops over whichever objects are set by model and controller:
</p>

<pre>
#includePartial(user.photos)#</pre>

<p>
	Part of photo form partial at <tt>views/users/_photo.cfm</tt> uses new <tt>association</tt> and <tt>position</tt> arguments in
	<tt>errorMessageOn()</tt>:
</p>

<pre>
#fileField(
	label="Photo ###arguments.current#",
	objectName="user",
	association="photos",
	position=arguments.current
	property="file"
)#
#errorMessageOn(
	objectName="user",
	association="photos",
	position=arguments.current
	property="file"
)#</pre>

<p>
	Without this plugin, you basically need to do this to &quot;hack&quot; <tt>errorMessageOn()</tt> to get it to work with the nested
	property:
</p>

<pre>
<!--- Yuck! Hooray for this plugin! --->
#errorMessageOn(
	objectName="user['photos'][#arguments.current#]",
	property="file"
)#</pre>

<h2>Contributors</h2>

<p>
	You can watch and fork this project on its GitHub repo at
	<a href="https://github.com/liquifusion/cfwheels-nested-errorMessageOn">liquifusion/cfwheels-nested-errorMessageOn</a>.
</p>

<p>
	Created by <a href="http://cfwheels.org/user/profile/1">Chris Peters</a> with support from
	<a href="http://liquifusion.com/">Liquifusion Studios</a>.
</p>