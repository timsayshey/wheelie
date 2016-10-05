<cfoutput>
    <div class="row">
    	<div id="no-more-tables">
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
	    			<cfloop query='orders'>
					<tr>
	    				<td data-title="Order ID">#id#</td>
	    				<td data-title="Vendor">#company#</td>
	    				<td data-title="Total" class="numeric">#NumberFormat( ordertotal, "$0.00" )#</td>
	    				<td data-title="Status">#status#</td>
	    				<td data-title="Date">#dateFormat(createdAt,"short")#</td>
	    				<td class="text-center">
	    					<a class="btn btn-info btn-xs" href="#urlFor(route='admin~id', controller='orders', action='details', id=orders.id)#"><span class="elusive icon-list"></span> View</a> 
	    				</td>
	    			</tr>
					</cfloop>
	    		</tbody>
	    	</table>
	    </div>
    </div> 
</cfoutput>