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
				<h3>S3 Settings</h3>
				<p>Sign up with AWS S3 for free and host your assets remotely. Or leave this section blank if you want to store everything locally.</p>

				<div class="form-group">
					<label>Access Key Id</label>
					<input class="form-control" name="accessKeyId">
				</div>
				<div class="form-group">
					<label>Secret Key</label>
					<input class="form-control" name="awsSecretKey">
				</div>
				<div class="form-group">
					<label>Default Location</label>
					<input class="form-control" name="defaultLocation" value="us">
				</div>
				<div class="form-group">
					<label>Host</label>
					<input class="form-control" name="host" value="s3.amazonaws.com">
				</div>
				<div class="form-group">
					<label>Default Bucket</label>
					<input class="form-control" name="defaultBucket" value="">
				</div>
			</div>

			<div class="well">
				<h3>Other Settings</h3>

				<div class="form-group">
					<label>Stripe API Key</label>
					<input class="form-control" name="stripeKey">
				</div>
				<div class="form-group">
					<label>SendGrid Username</label>
					<input class="form-control" name="sendGridUsername">
				</div>
				<div class="form-group">
					<label>SendGrid Password</label>
					<input class="form-control" name="sendGridPassword">
				</div>
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