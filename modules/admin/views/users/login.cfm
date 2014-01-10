<cfoutput>

	<div class="container">
		<div class="row-regular">
			<div class="col-md-4 col-md-offset-4">
				<div class="panel panel-default">
					<div class="panel-heading">
						<span class="elusive icon-lock"></span> Login
					</div>
					
					#startFormTag(route="moduleAction", module="admin", controller="users", action="loginPost")#
					
						<div class="panel-body">
							<div class="form-group">
								<div class="input-group">
									<span class="input-group-addon"><span class="elusive icon-user"></span></span>
									<input class="form-control" type="text" placeholder="Enter your email" name="email">
								</div>
							</div>
							<div class="form-group">
								<div class="input-group">
									<span class="input-group-addon"><span class="elusive icon-key"></span></span>
									<input class="form-control" type="password" placeholder="Password" name="pass">
								</div>
							</div>
							<div class="form-group last">								
								<button class="btn btn-primary btn-lg btn-block" type="submit">Login</button>
								
								<span class="login-link"><br />

								<a class="lost-password" href='#urlFor(route="moduleAction", module="admin", controller="users", action="recovery")#'>Forgot pass?</a>	
								</span>
							</div>						
						</div>
						<div class="panel-footer">
							<span class="login-link">Not Registered? <a href='#urlFor(route="moduleAction", module="admin", controller="users", action="register")#'>Register here</a></span>
						</div>
						
					#endFormTag()#
					
				</div>
			</div>
		</div>
	</div>
</cfoutput>