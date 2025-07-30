// main.js
import { initAuth } from './api/auth.js';
import { fetchInventoryList } from './api/inventory.js';
import { fetchPurchaseHistory } from './api/purchase.js';
import { bindGlobalActions, bindInventorySelection } from './bindings.js';

document.addEventListener('DOMContentLoaded', async () => {
    const { keycloak, authenticated } = await initAuth();

    if (!authenticated) {
        document.getElementById('loginBtn').style.display = 'inline';
        return;
    }

    await fetchInventoryList();
    await fetchPurchaseHistory();

    bindGlobalActions(keycloak);
    bindInventorySelection();
});
