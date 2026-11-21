import { keycloak, initAuth } from './api/auth.js';
import { fetchInventoryList } from './api/inventory.js';
import { loadAndRenderPurchaseHistoryByStatus } from './util.js';
import { bindLoginLogout, bindPostAuthActions } from './bindings.js';
import { updateLoginState } from './ui.js';

document.addEventListener('DOMContentLoaded', () => {
    // Bind the buttons immediately — before the silent-SSO check — so Login
    // works even if initAuth() is slow or the silent iframe is blocked.
    bindLoginLogout(keycloak);

    initAuth().then(async ({ authenticated }) => {
        if (!authenticated) return;
        await fetchInventoryList();
        await loadAndRenderPurchaseHistoryByStatus();
        bindPostAuthActions();
    }).catch(err => {
        console.error('[auth] initAuth failed', err);
        updateLoginState(null);
    });
});
