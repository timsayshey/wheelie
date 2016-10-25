<cfoutput>
    <cfset request.breadcrumb = 'Checkout'> 
    <cfset themeDir = "/views/themes/#request.site.theme#/shopfrog">

    <div class="content">
        <h1>Checkout</h1>
    </div> <!-- //end content -->
    
    <div class="row">
        <div class="col-sm-9">
            <div class="content inner">
                
                <!---<h3>Discount code</h3>
                <form action="dicount.php" method="post" class="form-inline">
                    <div class="form-group">        
                        <label for="discount_code">Have a discount code? Enter it here:&nbsp;&nbsp;</label>
                        <input id="discount_code" name="discount_code" type="text" class="form-control">
                        <input name="commit" type="submit" value="Apply" class="btn">
                    </div>
                </form>    

                <hr />--->

                <form action="#urlFor(route='public~checkoutAction', action='complete')#" id="purchase-form" method="post" class="form-horizontal">
                    <h3>Pickup method</h3>
                    <p>Please select how you would like to pickup your order.</p> 
                    <select name="eventid" id="shipping-rates" class="form-control">
                        <option value="1" selected="selected">Market Day - Wednesday, April 29, 2015</option>
                        <option value="2">Market Day - Wednesday, May 6, 2015</option>
                    </select>

                    <hr />

                    <h3>How would you like to pay for your order?</h3>
                    <p>All transactions are secure and encrypted, and we never store your credit card information. To learn more, please view our privacy policy.</p>

                    <ul class="payment-methods">
                        <li>
                            <input checked="checked" class="payment-method" id="direct-payment" name="gateway" type="radio" value="stripe">
                            <label for="direct-payment">
                                <img alt="Visa" class="credit-card" id="credit-card-visa" src="#themeDir#/img/visa.png" title="Visa">
                                <img alt="Master" class="credit-card" id="credit-card-master" src="#themeDir#/img/master.png" title="Mastercard">
                                <img alt="American_express" class="credit-card" id="credit-card-american_express" src="#themeDir#/img/american_express.png" title="Amex">
                                <img alt="Discover" class="credit-card" id="credit-card-discover" src="#themeDir#/img/discover.png" title="Discover">
                            </label>
                        </li>
                        <li>
                            <input class="payment-method" id="gateway-gift" name="gateway" type="radio" value="pickup">
                            <label for="gateway-gift">Pay on Pickup</label>
                        </li>
                        <!---<li>
                            <input class="payment-method" id="paypal_express" name="gateway" type="radio" value="paypal">
                            <label for="paypal_express">
                                <img src="https://www.paypal.com/en_US/i/logo/PayPal_mark_37x23.gif" alt="PayPal Express Logo">
                            </label>
                        </li>--->                       
                    </ul>

                    <div id="stripe">
                        <hr />      

                        <input type='hidden' name='stripeToken'>
                        <input type='hidden' id='stripePublicKey' value="#application.stripePublicKey#">

                        <h3>Card details</h3>
                        <div class="form-group">    
                            <label class="control-label col-sm-3" for="fname">First Name</label>
                            <div class="col-sm-8 col-md-6"> 
                                <input id="credit_card_first_name" name="fname" size="11" type="text" value="" class="form-control">
                            </div>
                        </div>

                        <div class="form-group">    
                            <label class="control-label col-sm-3" for="lname">Last Name</label>
                            <div class="col-sm-8 col-md-6"> 
                                <input id="credit_card_last_name" name="lname" size="13" type="text" value="" class="form-control">
                            </div>
                        </div>
                            
                        <div class="form-group">        
                            <label class="control-label col-sm-3">Credit Card Number</label> 
                            <div class="col-sm-8 col-md-6"> 
                                <input id="creditCard" value="4242424242424242" size="26" type="text" class="form-control">
                            </div>
                        </div>

                        <div class="form-group">        
                            <label class="control-label col-sm-3" for="credit_card_month">Expiration Date</label>
                            <div class="col-sm-8 col-md-6">
                                <select id="expirationMonth" class="form-control">
                                    <option value="1">1 - January</option>
                                    <option value="2">2 - February</option>
                                    <option value="3">3 - March</option>
                                    <option value="4">4 - April</option>
                                    <option value="5">5 - May</option>
                                    <option value="6">6 - June</option>
                                    <option value="7">7 - July</option>
                                    <option value="8">8 - August</option>
                                    <option value="9">9 - September</option>
                                    <option value="10">10 - October</option>
                                    <option value="11">11 - November</option>
                                    <option value="12">12 - December</option>
                                </select>
                                <select id="expirationYear" class="form-control">
                                    <option value="2015">2015</option>
                                    <option value="2016">2016</option>
                                    <option value="2017">2017</option>
                                    <option value="2018">2018</option>
                                    <option value="2019">2019</option>
                                    <option value="2020">2020</option>
                                    <option value="2021">2021</option>
                                    <option value="2022">2022</option>
                                    <option value="2023">2023</option>
                                    <option value="2024">2024</option>
                                    <option value="2025">2025</option>
                                    <option value="2026">2026</option>
                                    <option value="2027">2027</option>
                                    <option value="2028">2028</option>
                                    <option value="2029">2029</option>
                                    <option value="2030">2030</option>
                                    <option value="2031">2031</option>
                                    <option value="2032">2032</option>
                                    <option value="2033">2033</option>
                                </select>
                            </div>
                        </div>
                    
                        <div class="form-group">    
                            <label class="control-label col-sm-3" for="credit_card_verification_value">Card Security Code <a href="##cvv-popup" class="open-popup-link" title="Card Security Code">?</a></label>
                            <div class="col-sm-8 col-md-6">
                                <input id="securityCode" size="4" type="text" class="form-control">
                                <div id="cvv-popup" class="white-popup mfp-hide">
                                    <h3>Card Security Code</h3>
                                    <p>The card verification value is an important security feature for credit card transactions on the internet.</p>
                                    <p>MasterCard, Visa and Discover credit cards have a 3 digit code printed on the back of the card while American Express cards have a 4 digit code printed on the front side of the card above the card number.</p>
                                    <table>
                                      <tr>
                                        <th>Visa, MasterCard &amp; Discover</th>
                                        <th>American Express</th>
                                      </tr>
                                      <tr>
                                        <td><img alt="Cv_card" src="img/cv_card.gif" class="img-responsive"></td>
                                        <td><img alt="Cv_amex_card" src="img/cv_amex_card.gif" class="img-responsive"></td>
                                      </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <hr />
                                                    
                    <div class="form-group">
                        <div class="col-sm-12">                     
                            <label for="marketing" class="checkbox">
                                <input type="checkbox" name="buyer_accepts_marketing" checked="checked" value="true" id="marketing"> I want to receive occasional emails about new products, promotions and other news.
                            </label>
                        </div>
                    </div>
                
                    <input type="submit" class="btn btn-large inline" value="Complete purchase">
                    or <a href="/">Cancel and return to store</a>
                </form>
            </div> <!-- //end content -->
        </div> <!-- //end span9 -->

        <div class="col-sm-3">
            <cfsavecontent variable="cartlist">
                <div class="content">
                    <div class="cart-checkout clearfix">

                        <cfset cartTotal = 0>
                        <cfset item = qCart>
                        <cfloop query="item">
                            <cfset itemqty = session.cart.items[item.id]>
                            <cfset cartTotal = cartTotal + (item.price * itemqty)>

                            <div class="item clearfix">
                                <cfset imgPath = "/assets/uploads/items/sm/#item.id#.jpg">
                                <cfset hasImage = fileExists(expandPath(imgPath))>
                                #hasImage ? '<img src="#imgPath#" style="max-width:50px;">' : ''#
                                <div class="desc">
                                    <p class="name">#item.name#</p>
                                    <p class="price">#itemqty# x #NumberFormat( item.price, "$0.00" )# / #item.unit#</p>
                                </div>
                            </div>                                 
                        </cfloop>  
                        
                    </div>
                </div> 
            </cfsavecontent>
            <div class="content checkout-total">
                <p>
                    <small>your purchase:</small><br>
                    <span>#NumberFormat( cartTotal, "$0.00" )#</span><br>
                    <!---<small>Step 2 of 2</small>--->
                </p>
            </div>
            #cartlist#
        </div>
    </div>

    <script type="text/javascript" src="https://js.stripe.com/v1/"></script>
    <script type="text/javascript" src="/assets/js/stripe-app.js"></script>     
    
</cfoutput>