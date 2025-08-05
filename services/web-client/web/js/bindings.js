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

        const selectedButtons = document.querySelectorAll('.select-btn.btn-success');
        if (selectedButtons.length === 0) {
            alert("No items selected.");
            return;
        }

        const purchaseItems = [];

        selectedButtons.forEach(btn => {
            const id = btn.dataset.id;
            const name = btn.dataset.name;
            const qtyInput = document.getElementById(`qty-${id}`);
            const quantity = parseInt(qtyInput.value, 10);

            if (!quantity || quantity < 1) {
                console.warn(`[Purchase] Invalid quantity for item ${id}`);
                return;
            }

            purchaseItems.push({
                lagerItemId: parseInt(id, 10),
                productName: name,
                quantity
            });
        });

        if (purchaseItems.length === 0) {
            alert("No valid quantities found.");
            return;
        }

        for (const item of purchaseItems) {
            try {
                await sendPurchase(item);
                console.log('[Purchase] Successfully sent purchase:', item);
            } catch (err) {
                console.error('[Purchase] Failed to send purchase:', item, err);
            }
        }

        alert("Purchase request(s) sent.");
        console.log('[Purchase] Purchase requests sent.');

        try {
            await fetchInventoryList();
            console.log('[Purchase] Inventory list refreshed.');
        } catch (err) {
            console.error('[Purchase] Failed to refresh inventory list:', err);
        }

        try {
            await loadAndRenderPurchaseHistoryByStatus();
            console.log('[Purchase] Purchase history reloaded.');
        } catch (err) {
            console.error('[Purchase] Failed to reload purchase history:', err);
        }
    });
}

export function bindInventorySelection() {
    document.getElementById('inventoryList').addEventListener('click', e => {
        if (!e.target.classList.contains('select-btn')) return;

        const btn = e.target;

        const isSelected = btn.classList.contains('btn-success');

        if (isSelected) {
            btn.classList.remove('btn-success');
            btn.classList.add('btn-outline-primary');
            btn.textContent = 'Select';
        } else {
            btn.classList.remove('btn-outline-primary');
            btn.classList.add('btn-success');
            btn.textContent = 'Selected';
        }
    });
}
