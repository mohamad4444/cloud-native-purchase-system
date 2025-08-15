import { initAuth } from './api/auth.js';
import { fetchInventoryList } from './api/inventory.js';
import { loadAndRenderPurchaseHistoryByStatus } from './util.js';
import { bindLoginLogout, bindPostAuthActions } from './bindings.js';

document.addEventListener('DOMContentLoaded', async () => {
    const { keycloak, authenticated } = await initAuth();

    bindLoginLogout(keycloak);

    if (!authenticated) return;

    await fetchInventoryList();             // show available items
    await loadAndRenderPurchaseHistoryByStatus(); // show history
    bindPostAuthActions();                  // bind finalize purchase + selection
});
