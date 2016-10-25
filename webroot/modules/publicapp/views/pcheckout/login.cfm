<cfoutput>
    <cfset request.breadcrumb = 'Checkout'> 
    <cfset themeDir = "/views/themes/#request.site.theme#/shopfrog">

    <div class="content">
        <h1>Login to continue checkout</h1>
    </div> <!-- //end content -->
               
        
   <div class="container">
        <div class="row">
            <div class="col-md-6 col-md-offset-3">
                <div class="panel panel-login">
                    <div class="panel-heading">
                        <div class="row">
                           <div class="col-xs-6">
                                <a href="##" class="active" id="register-form-link">Register</a>
                            </div>
                            <div class="col-xs-6">
                                <a href="##" id="login-form-link">Login</a>
                            </div>                            
                        </div>
                        <hr>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-lg-12">

                                 <form id="register-form" action="#urlFor(route='public~checkoutAction', action='registerPost')#" method="post" role="form" style="display: block;">
                                    <div class="form-group col-sm-6">
                                        #btextfield(
                                            objectName  = 'user', 
                                            property    = 'firstname',
                                            placeholder = "First name"
                                        )#
                                    </div>
                                    <div class="form-group col-sm-6">
                                        #btextfield(
                                            objectName  = 'user', 
                                            property    = 'lastname',
                                            placeholder = "Last name"
                                        )#
                                    </div>

                                    <div class="form-group col-sm-12">
                                        #btextfield(
                                            objectName  = 'user', 
                                            property    = 'email',
                                            placeholder = "Email"
                                        )#
                                    </div>
                                    <div class="form-group col-sm-12">
                                         #bpasswordfield(
                                            objectName  = 'user', 
                                            property    = 'password',
                                            placeholder = "Password"
                                        )#
                                    </div>
                                    <div class="form-group col-sm-12">
                                        #bpasswordfield(
                                            objectName  = 'user', 
                                            property    = 'passwordConfirmation',
                                            placeholder = "Confirm password"
                                        )#
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-sm-6 col-sm-offset-3">
                                                <input type="submit" name="register-submit" id="register-submit" tabindex="4" class="form-control btn btn-register" value="Register Now">
                                            </div>
                                        </div>
                                    </div>
                                </form>

                                <form id="login-form" action="#urlFor(route='public~checkoutAction', action='loginPost')#" method="post" role="form" style="display: none;">
                                    <div class="form-group">
                                        <input type="text" name="email" id="email" tabindex="1" class="form-control" placeholder="Email" value="">
                                    </div>
                                    <div class="form-group">
                                        <input type="password" name="pass" id="password" tabindex="2" class="form-control" placeholder="Password">
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-sm-6 col-sm-offset-3">
                                                <input type="submit" name="login-submit" id="login-submit" tabindex="4" class="form-control btn btn-login" value="Log In">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <div class="text-center">
                                                    <a href="/" tabindex="5" class="forgot-password">Forgot Password?</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>                              

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</cfoutput>