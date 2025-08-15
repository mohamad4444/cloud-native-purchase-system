import { sendPurchase } from './api/purchase.js';
import { fetchInventoryList } from './api/inventory.js';
import { loadAndRenderPurchaseHistoryByStatus } from './util.js';

export function bindLoginLogout(keycloak) {
    document.getElementById('loginBtn').addEventListener('click', () => keycloak.login({ redirectUri: window.location.href }));
    document.getElementById('logoutBtn').addEventListener('click', () => keycloak.logout({ redirectUri: window.location.href }));
}

export function bindPostAuthActions() {
    // finalize purchase button
    document.getElementById('finalizePurchaseBtn').addEventListener('click', async () => {
        const selected = document.querySelectorAll('.select-checkbox:checked');
        if (!selected.length) return alert('No items selected');

        const purchases = Array.from(selected).map(cb => {
            const qty = parseInt(document.getElementById(`qty-${cb.dataset.id}`).value, 10);
            return { lagerItemId: parseInt(cb.dataset.id, 10), productName: cb.dataset.name, quantity: qty };
        }).filter(item => item.quantity > 0);

        if (!purchases.length) return alert('No valid quantities');

        for (const item of purchases) {
            try { await sendPurchase(item); } 
            catch(e) { console.error('Purchase failed', item, e); }
        }

        alert('Purchase sent!');
        selected.forEach(cb => {
            cb.checked = false;
            cb.closest('tr').style.backgroundColor = '';
        });

        await fetchInventoryList();
        await loadAndRenderPurchaseHistoryByStatus();
    });

    // row highlight
    document.getElementById('inventoryList').addEventListener('change', e => {
        if (!e.target.classList.contains('select-checkbox')) return;
        e.target.closest('tr').style.backgroundColor = e.target.checked ? '#e0ffe0' : '';
    });
}
