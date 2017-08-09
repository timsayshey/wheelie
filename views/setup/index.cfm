<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Welcome</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="margin:100px;">
	<cfoutput>

		<form action="/" method="post">
			<h1>Setup Wheelie</h1>
			<p>Please fill this out before you get started.</p>
			<input type="hidden" name="firstTimeSetupInstall" value="true">

			<div class="well">
				<h3>Default Settings</h3>

				<div class="form-group">
					<label>Admin Email (Receive errors, etc)</label>
					<input class="form-control" name="defaultEmail">
				</div>
			</div>

			<input type="submit" value="Save & Continue" class="btn-lg btn-primary btn">

		</form>

	</cfoutput>
</body>
</html>
