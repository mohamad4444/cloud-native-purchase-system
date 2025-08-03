// bindings.js
import { addItem, getSelectedItems, clearSelectedItems } from './state.js';
import { sendPurchase } from './api/purchase.js';
import { fetchInventoryList } from './api/inventory.js';
import { loadAndRenderPurchaseHistoryByStatus } from './util.js';

export function bindLoginLogout(keycloak) {
    document.getElementById('loginBtn').addEventListener('click', () => {
        keycloak.login({ redirectUri: window.location.href });
    });

    document.getElementById('logoutBtn').addEventListener('click', () => {
        keycloak.logout({ redirectUri: window.location.href });
    });
}

export function bindGlobalActionsAfterAuth() {
    document.getElementById('finalizePurchaseBtn').addEventListener('click', async () => {
        console.log('[Purchase] Finalize button clicked.');

        const items = getSelectedItems();
        console.log('[Purchase] Selected items:', items);

        if (Object.keys(items).length === 0) {
            console.warn('[Purchase] No items selected.');
            return alert("No items selected.");
        }

        for (const [id, quantity] of Object.entries(items)) {
            const purchaseItem = { id, quantity };
            console.log('[Purchase] Sending purchase for item:', purchaseItem);
            try {
                await sendPurchase(purchaseItem);
                console.log('[Purchase] Successfully sent purchase:', purchaseItem);
            } catch (err) {
                console.error('[Purchase] Failed to send purchase:', purchaseItem, err);
            }
        }

        alert("Purchase request(s) sent.");
        console.log('[Purchase] Purchase requests sent alert displayed.');

        clearSelectedItems();
        console.log('[Purchase] Selected items cleared.');

        try {
            await fetchInventoryList();
            console.log('[Purchase] Inventory list refreshed.');
        } catch (err) {
            console.error('[Purchase] Failed to refresh inventory list:', err);
        }

        try {
            await loadAndRenderPurchaseHistoryByStatus();
            console.log('[Purchase] Purchase history reloaded and rendered.');
        } catch (err) {
            console.error('[Purchase] Failed to reload purchase history:', err);
        }
    });
}

export function bindInventorySelection() {
    document.getElementById('inventoryList').addEventListener('click', e => {
        if (!e.target.classList.contains('select-btn')) return;

        const btn = e.target;
        const id = btn.dataset.id;
        const name = btn.dataset.name;
        const qtyInput = document.getElementById(`qty-${id}`);
        const quantity = parseInt(qtyInput.value, 10);

        if (!quantity || quantity < 1) {
            alert("Please enter a valid quantity");
            return;
        }

        // Save quantity only (not full object)
        addItem(id, quantity);

        btn.classList.remove('btn-outline-primary');
        btn.classList.add('btn-success');
        btn.textContent = 'Selected';

        // **Do NOT clear the input value** so user sees what they selected
        // qtyInput.value = '';  // <-- removed this line
    });
}
