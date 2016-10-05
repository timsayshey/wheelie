<cfoutput>
    <div class="row">
        <div class="col-xs-12">
    		<!---<div class="row">
    			<div class="col-xs-6">
    				<address>
    				<strong>Billed To:</strong><br>
    					John Smith<br>
    					1234 Main<br>
    					Apt. 4B<br>
    					Springfield, ST 54321
    				</address>
    			</div>
    			<div class="col-xs-6 text-right">
    				<address>
        			<strong>Shipped To:</strong><br>
    					Jane Smith<br>
    					1234 Main<br>
    					Apt. 4B<br>
    					Springfield, ST 54321
    				</address>
    			</div>
    		</div>---> 
    		<div class="row">
    			 <cfif !isNull(stripeCard)><div class="col-xs-6">
    				<address>                       
                        <strong>Payment Method:</strong><br>
                        #stripeCard.brand# ending **** #stripeCard.last4#<br>
                        #stripeCard.exp_month# / #stripeCard.exp_year#                           					
    				</address>
    			</div>
                </cfif>  
    			<div class="col-xs-6 text-right">
    				<address>
    					<strong>Order Date:</strong><br>
    					#dateFormat(orderitems.createdat,'MMMM D, YYYY')#<br><br>
    				</address>
    			</div>
    		</div>
    	</div>
    </div>
    
    <div class="row">
    	<div class="col-md-12">
    		<div class="panel panel-default">
    			<div class="panel-heading">
    				<h3 class="panel-title"><strong>Order summary</strong></h3>
    			</div>
    			<div class="panel-body">
    				<div class="table-responsive">
    					<table class="table table-condensed">
    						<thead>
                                <tr>
        							<td><strong>Item</strong></td>
        							<td class="text-center"><strong>Price</strong></td>
        							<td class="text-center"><strong>Quantity</strong></td>
        							<td class="text-right"><strong>Totals</strong></td>
                                </tr>
    						</thead>
    						<tbody>
                                <cfset totalPrice = 0>
    							<cfloop query='orderitems'>
	    							<tr>
	    								<td>#itemname#</td>
	    								<td class="text-center">#NumberFormat( itemprice, "$0.00" )#</td>
	    								<td class="text-center">#itemquantity#</td>
                                        <cfset itemlinetotal = itemprice * itemquantity>
                                        <cfset totalPrice += itemlinetotal>
	    								<td class="text-right">#NumberFormat( itemlinetotal, "$0.00" )#</td>
	    							</tr>
    							</cfloop>
    							<tr>
    								<td class="no-line"></td>
    								<td class="no-line"></td>
    								<td class="no-line text-center"><strong>Total</strong></td>
    								<td class="no-line text-right">#NumberFormat( totalPrice, "$0.00" )#</td>
    							</tr>
    						</tbody>
    					</table>
    				</div>
    			</div>
    		</div>
    	</div>
    </div>
</cfoutput>