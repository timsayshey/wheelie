# Bootstrap CFWheels Plugin

Experimental plugin that adds an API for working with [Twitter Bootstrap][1].

## Methods

All methods have their "usual" arguments from the Wheels API, but additional arguments are listed below along with the
method names.

### Object Form Helpers

  * `hStartFormTag()`
  * `bFileField([ string helpBlock ])`
  * `bSelect([ string helpBlock ])`
  * `bTextField([ string helpBlock, string prependedText, string appendedText ])`
  * `bTextArea([ string helpBlock ])`
  * `bPasswordField([ string helpBlock, string prependedText, string appendedText ])`
  * `bUneditableTextField(string label, string value [, string class ])`
  * `bCheckBox()`

These form helpers also place error messages in-line using `errorMessageOn` and Bootstrap.

### Tag Form Helpers

  * `bSelectTag()`
  * `bTextFieldTag()`
  * `bPasswordFieldTag()`

### Other Form Helpers

  * `bSubmitTag([ string class, boolean isPrimary ])`

### View Helpers

  * `bFlashMessages()`
  * `bPaginationLinks()`

## Dependencies

You must install the [Nested errorMessageOn][2] plugin for this plugin to work.

## Contributors

Created by [Chris Peters][3] with support from [Liquifusion Studios][4].

[1]: http://twitter.github.com/bootstrap/
[2]: http://cfwheels.org/plugins/listing/78
[3]: http://cfwheels.org/user/profile/1
[4]: http://liquifusion.com/