/**
 * Created by jbarker on 2019-08-26.
 */

({
    doInit: function (component, event, helper) {
        var cartItemId = component.get('v.recordId');
        var cartItems = component.get('v.cartItems');

        if (cartItemId != null && cartItems != null) {
            var cartItem = cartItems[cartItemId];
            if (cartItem != null) {
                component.set('v.cartItem', cartItem);
                component.set('v.quantity', cartItem.ccrz__Quantity__c);
                component.set('v.componentIDs', cartItem.cartItemList);
                component.set('v.componentItems', cartItem.cartItemMap);

                if (cartItem.cartItemList == null || cartItem.cartItemList.length == 0) {
                    component.set('v.allowsPriceOverride', true);
                }
            }
        }

        component.set('v.renderComplete', true);
    },

    /**
     * @description Event handler for the + button.
     * @param component
     * @param event
     * @param helper
     */
    incrementQuantity: function (component, event, helper) {
        var cartItem = component.get('v.cartItem');
        var quantity = component.get('v.quantity');
        var products = component.get('v.productMap');

        if (cartItem != null && quantity != null && products != null) {
            var productId = cartItem.ccrz__Product__c;
            var product = products[productId];

            if (product != null) {
                var productInventory = product.inventoryCount;
                if (quantity == productInventory) {
                    return;
                }

                quantity = Number(quantity) + 1;
                component.set('v.quantity', quantity);

                var updateEvent = component.getEvent('incrementProductCount');
                updateEvent.setParams({'productSfid': productId});
                updateEvent.fire();
            }
        }
    },

    /**
     * @description Event handler for the - button.
     * @param component
     * @param event
     * @param helper
     */
    decrementQuantity: function (component, event, helper) {
        var cartItem = component.get('v.cartItem');
        var quantity = component.get('v.quantity');
        var products = component.get('v.productMap');

        if (cartItem != null && quantity != null && products != null) {
            var productId = cartItem.ccrz__Product__c;
            var product = products[productId];

            if (product != null) {
                if (quantity == 0) {
                    return;
                }

                quantity = Number(quantity) - 1;
                component.set('v.quantity', quantity);

                var updateEvent = component.getEvent('decrementProductCount');
                updateEvent.setParams({'productSfid': productId});
                updateEvent.fire();
            }
        }
    },

    /**
     * @description Event handler for the price override link.
     * @param component
     * @param event
     * @param helper
     */
    handlePriceOverrideClick: function (component, event, helper) {
        var cartItemId = component.get('v.recordId');
        if (cartItemId != null) {
            var showEvent = component.getEvent('showPriceOverrideModal');
            showEvent.setParam('cartItemId', cartItemId);
            showEvent.fire();
        }
    }

});