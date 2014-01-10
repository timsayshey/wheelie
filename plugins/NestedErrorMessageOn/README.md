# CFWheels Nested errorMessageOn Plugin

This plugin overrides `errorMessageOn` to accept arguments for nested properties. Basically, you can now use
`association` and `position` arguments for your nested properties' error messages.

## Example

`user` model with `photos` association:

	// In `init` method of `models/User.cfc`
	hasMany("photos");
	nestedProperties(association="photos", allowDelete=true);

Photos partial call in `views/users/_form.cfm` loops over whichever objects are set by model and controller:

	#includePartial(user.photos)#

Part of photo form partial at `views/users/_photo.cfm` uses new `association` and `position` arguments in
`errorMessageOn()`:

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
	)#

Without this plugin, you basically need to do this to "hack" `errorMessageOn()` to get it to work with the nested
property:

	<!--- Yuck! Hooray for this plugin! --->
	#errorMessageOn(
		objectName="user['photos'][#arguments.current#]",
		property="file"
	)#

## Contributors

Created by [Chris Peters][1] with support from [Liquifusion Studios][2].

[1]: http://cfwheels.org/user/profile/1
[2]: http://liquifusion.com/