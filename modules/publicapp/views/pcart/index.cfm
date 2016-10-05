<cfoutput>
    
    <cfset request.templateActive=true>
    <cfset request.breadcrumb = 'Shopping Cart'>    
    
    <section class="page-wrapper page-general">
        <div class="container main-content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="content">
                        <h1>Your shopping cart</h1>
                        <cfif !isNull(session.cart.items) AND len(StructKeyList(session.cart.items))>
                            <form action="shopping-cart.php" method="post" class="shopping-cart">
                                <table class="table table-striped">
                                    <cfset item = qCart>
                                    <cfset cartTotal = 0>
                                    <cfloop query="item">
                                        <cfset itemqty = session.cart.items[item.id]>
                                        <cfset cartTotal = cartTotal + (item.price * itemqty)>                                        
                                        <tr>
                                            <cfset imgPath = "/assets/uploads/items/sm/#item.id#.jpg">
                                            <cfset hasImage = fileExists(expandPath(imgPath))>
                                            <td class="img" style="text-align:center;">#hasImage ? '<img src="#imgPath#" style="max-width:50px;">' : ''#</td>
                                            <td class="name">
                                                <a href="#urlFor(route='public~itemsId', action='item', id='#item.id#')#">#item.name#</a>
                                            </td>
                                            <td class="stock instock"><span class="stock-small"></span><span class="stock-large">In stock</span></td>
                                            <td class="quantity-cell">
                                                <cfif itemqty GT 1>
                                                    <cfset qtyMinusUrl = urlFor(route='public~cartId', action='additem', id='#item.id#', 
                                                    params='itemqty=#itemqty - 1#')>
                                                <cfelse>
                                                    <cfset qtyMinusUrl = urlFor(route='public~cartId', action='removeitem', id='#item.id#')>
                                                </cfif>
                                                <a href="#qtyMinusUrl#" class="quantity minus">-</a>
                                                <span class="order-quantity" data-sub="20">#itemqty#</span>
                                                <a href="#urlFor(route='public~cartId', action='additem', id='#item.id#', 
                                                    params='itemqty=#itemqty + 1#')#" class="quantity plus">+</a>                                  
                                            </td>
                                            <td class="sub-total"><span class="currency">$</span><span class="total">#NumberFormat( item.price, "0.00" )#</span> / #item.unit#</td>
                                            <td><a href="#urlFor(route='public~cartId', action='removeitem', id='#item.id#')#" class="cart-remove pull-right"><span class="remove-small">x</span><span class="remove-large">remove</span></a></td>
                                        </tr>
                                        
                                    </cfloop>  
                                    <tr class="cart-summary">
                                        <td colspan="4"></td>
                                        <td colspan="2" class="cart-total"><span class="currency">$</span><span class="total-total">#NumberFormat( cartTotal, "0.00" )#</span></td>
                                    </tr>   
                                    <tr class="cart-summary">
                                        <td colspan="6">
                                            <a class="btn btn-large pull-right" href="/checkout">Checkout</a>
                                        </td>
                                    </tr>   
                                </table>
                            </form>
                            <div class="shopping-cart-help">
                                <p>Update or remove items from your cart before proceeding to checkout to calculate delivery cost and use any exclusive discount codes.</p>                                     
                                <p>
                                    <small><span class="instock">Instock</span> Item in stock and will be dispatched normally.</small><br />
                                    <small><span class="lowstock">Low stock</span> Low item stock. Additional delay might exist is dispatching your item, delays will be notified by email.</small><br />
                                    <small><span class="outofstock">Out of stock</span> Item is out of stock and will be placed on back order and fulfilled as soon as possible.</small>
                                </p>
                            </div>

                        <cfelse>

                            <div>
                                <p class="lead">Your don't currently have any items in your cart.</p>
                                <p>Please <a href="/">return to the shop</a>.</p>
                            </div>

                        </cfif>

                    </div>          
                </div> 
            </div> 
        </div> 
    </section>
    
</cfoutput>