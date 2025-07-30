// bindings.js
import { API_ENDPOINTS } from './config.js';
import { getToken } from './state.js';
import { addItem, getSelectedItems, clearSelectedItems } from './state.js';
import { callHello } from './api/hello.js';  // or './api/auth.js'
import { fetchInventoryList, sendPurchase, fetchPurchaseHistory } from './api/purchase.js';
import { showHelloResponse } from './ui.js';

export function bindGlobalActions(keycloak) {
    document.getElementById('loginBtn').addEventListener('click', () => {
        keycloak.login({ redirectUri: window.location.href });
    });

    document.getElementById('logoutBtn').addEventListener('click', () => {
        keycloak.logout({ redirectUri: window.location.href });
    });

    document.getElementById('callUserHello').addEventListener('click', () => {
        callHello(API_ENDPOINTS.helloUser);
    });

    document.getElementById('callAdminHello').addEventListener('click', () => {
        callHello(API_ENDPOINTS.helloAdmin);
    });

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

async function callHello(url) {
    try {
        const res = await fetch(url, {
            headers: { 'Authorization': 'Bearer ' + getToken() }
        });
        const text = await res.text();
        showHelloResponse(`Response: ${text}`);
    } catch (err) {
        showHelloResponse(`Error: ${err}`);
    }
}
