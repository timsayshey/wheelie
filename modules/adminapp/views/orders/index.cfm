<cfoutput>
    <div class="row">
    	<div id="no-more-tables">
			
			<cfif session.user.role eq 'vendor'> 
				<cfset purchasedActive = "">
				<cfset soldActive = "active">
			<cfelse>
				<cfset purchasedActive = "active">
				<cfset soldActive = "">
			</cfif>
    		<ul class="nav nav-tabs" role="tablist">
                <cfif session.user.role eq 'vendor'> 
                	<li class="#soldActive#"><a href="##sold-items" role="tab" data-toggle="tab"><h4 class="text-capitalize">Sold Items</h4></a></li>
                </cfif>
                <li class="#purchasedActive#"><a href="##purchased-items" role="tab" data-toggle="tab"><h4 class="text-capitalize">Purchased Items</h4></a></li>                
            </ul>     

            <div class="tab-content">

                <cfif session.user.role eq 'vendor'> 
	                <div class="tab-pane #soldActive#" id="sold-items">    
	                	<table class="col-md-12 table-bordered table-striped table-condensed cf" style="width:100%">
				    		<thead class="cf">
				    			<tr>
				    				<th>Order ID</th>
				    				<th>Vendor</th>
				    				<th class="numeric">Total</th>
				    				<th>Status</th>
				    				<th>Date</th>
				    				<th>Actions</th>
				    			</tr>
				    		</thead>
				    		<tbody>
				    			<cfloop query='solditems'>
									<tr>
					    				<td data-title="Order ID">#id#</td>
					    				<td data-title="Vendor">#company#</td>
					    				<td data-title="Total" class="numeric">#NumberFormat( ordertotal, "$0.00" )#</td>
					    				<td data-title="Status">#status#</td>
					    				<td data-title="Date">#dateFormat(createdAt,"short")#</td>
					    				<td class="text-center">
					    					<a class="btn btn-info btn-xs" href="#urlFor(route='admin~id', controller='orders', action='details', id=solditems.id)#"><span class="elusive icon-list"></span> View</a> 
					    					<a class="btn btn-danger btn-xs" href="##"><span class="elusive icon-list"></span> Refund</a> 
					    				</td>
					    			</tr>
								</cfloop>
				    		</tbody>
				    	</table>
	                </div>
	            </cfif>

	            <div class="tab-pane #purchasedActive#" id="purchased-items">    
                	<table class="col-md-12 table-bordered table-striped table-condensed cf" style="width:100%">
			    		<thead class="cf">
			    			<tr>
			    				<th>Order ID</th>
			    				<th>Vendor</th>
			    				<th class="numeric">Total</th>
			    				<th>Status</th>
			    				<th>Date</th>
			    				<th>Actions</th>
			    			</tr>
			    		</thead>
			    		<tbody>
			    			<cfloop query='purchaseditems'>
								<tr>
				    				<td data-title="Order ID">#id#</td>
				    				<td data-title="Vendor">#company#</td>
				    				<td data-title="Total" class="numeric">#NumberFormat( ordertotal, "$0.00" )#</td>
				    				<td data-title="Status">#status#</td>
				    				<td data-title="Date">#dateFormat(createdAt,"short")#</td>
				    				<td class="text-center">
				    					<a class="btn btn-info btn-xs" href="#urlFor(route='admin~id', controller='orders', action='details', id=purchaseditems.id)#"><span class="elusive icon-list"></span> View</a> 
				    				</td>
				    			</tr>
							</cfloop>
			    		</tbody>
			    	</table>
                </div>				

            </div>  

	    </div>
    </div>
</cfoutput>