import { initAuth } from './api/auth.js';
import { fetchInventoryList } from './api/inventory.js';
import { fetchPurchaseHistory } from './api/purchase.js';
import {
    bindLoginLogout,
    bindGlobalActionsAfterAuth,
    bindInventorySelection
} from './bindings.js';
import {renderPurchaseHistory} from "./ui.js";

document.addEventListener('DOMContentLoaded', async () => {
    console.log('[main] DOMContentLoaded triggered');

    const { keycloak, authenticated } = await initAuth();
    console.log('[main] initAuth completed:', { authenticated, token: keycloak.token });

    // Always bind login/logout buttons
    bindLoginLogout(keycloak);
    console.log('[main] login/logout buttons bound');

    if (!authenticated) {
        console.log('[main] User not authenticated, showing login button');
        document.getElementById('loginBtn').style.display = 'inline';
        return;
    }

    console.log('[main] User authenticated, fetching inventory and purchase history');
    await fetchInventoryList();
    const statuses = ['PENDING', 'CONFIRMED', 'REJECTED'];

    for (const status of statuses) {
        const purchases = await fetchPurchaseHistory(status);
        renderPurchaseHistory(purchases, status); // Pass status to help with rendering
    }


    bindGlobalActionsAfterAuth();
    bindInventorySelection();
    console.log('[main] Bound post-auth global actions and inventory selection');
});
