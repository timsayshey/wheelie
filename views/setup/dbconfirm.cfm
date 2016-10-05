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
			<h1>Setup Wheelie Database</h1>
			<p>It looks like you haven't setup your database yet.</p>

			<h3>Want us to setup your database? (WARNING: Existing tables may be dropped.)</h3>

			<input name="setupDatabase" value="true" type="radio"> Yes<br>
			<input name="setupDatabase" value="false" type="radio"> No (You'll keep getting this prompt until you setup your database.)<br><br>

			<input type="submit" value="Save & Continue" class="btn-lg btn-primary btn">

		</form>
	
	</cfoutput>
</body>
</html>