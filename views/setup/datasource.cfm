<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Welcome</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="margin:100px;">
	<cfoutput>
		<h1>Whoops! Missing Datasource</h1>
		<p>It looks like you haven't added a datasource yet.</p>

		<h3>Normal Instructions</h3>
		<ul>
			<li>Login to the <a href="/lucee/admin/web.cfm?action=services.datasource" target="_blank">Lucee Web Admin.</a> (Default password: password)</li>
			<li>Add a new MySQL or PostgreSQL datasource named "wheelie"</li>
			<li>Profit.</li>
		</ul>

		<h3>Heroku Instructions</h3>
		<ul>
			<li>Go to Heroku and <a href="https://postgres.heroku.com/databases" target="_blank">add a free Postgres Database.</a></li>
			<li>Then login to the <a href="/lucee/admin/web.cfm?action=services.datasource" target="_blank">Lucee Web Admin.</a> (Default password: password)</li>
			<li>Add a new Datasource with the name "wheelie" and the type "Other - JDBC Driver (deprecated)".</li>
			<li>Then copy and paste the username and password from the Heroku Postgres settings page.</li>
			<li>Set the class to "org.postgresql.Driver".</li>
			<li>Set connection string to the following (replace the placeholders with your Heroku host and database.<br>
			jdbc:postgresql://[heroku-postgres-host]:5432/[heroku-postgres-database]?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory</li>
			<li>Make sure you add the datasource in your local environment and commit it to the Heroku repo.</li>
			<li>Profit.</li>
		</ul><br><br>

		<a href="/" class="btn btn-lg btn-primary">Okay, I added a datasource named wheelie</a>

	</cfoutput>
</body>
</html>
