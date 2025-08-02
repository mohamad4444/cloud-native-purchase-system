// bindings.js
import { API_ENDPOINTS } from './config.js';
import { addItem, getSelectedItems, clearSelectedItems } from './state.js';
import {sendPurchase, fetchPurchaseHistory } from './api/purchase.js';
import { fetchInventoryList } from './api/inventory.js';


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
        const items = getSelectedItems();
        if (Object.keys(items).length === 0) return alert("No items selected.");

        for (const item of Object.values(items)) {
            await sendPurchase(item);
        }

        alert("Purchase request(s) sent.");
        clearSelectedItems();
        await fetchInventoryList();
        await fetchPurchaseHistory();
    });
}


export function bindInventorySelection() {
    document.getElementById('inventoryList').addEventListener('click', e => {
        if (!e.target.classList.contains('select-btn')) return;

        const btn = e.target;
        const id = btn.dataset.id;
        const name = btn.dataset.name;
        const qtyInput = document.getElementById(`qty-${id}`);
        const quantity = parseInt(qtyInput.value);

        if (!quantity || quantity < 1) {
            alert("Please enter a valid quantity");
            return;
        }

        addItem(id, { productName: name, quantity });

        btn.classList.remove('btn-outline-primary');
        btn.classList.add('btn-success');
        btn.textContent = 'Selected';

        qtyInput.value = '';
    });
}
