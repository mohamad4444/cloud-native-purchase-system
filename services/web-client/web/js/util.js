import { fetchPurchaseHistory } from './api/purchase.js';
import { renderPurchaseHistory } from './ui.js';

export async function loadAndRenderPurchaseHistoryByStatus() {
    const statuses = ['PENDING', 'CONFIRMED', 'REJECTED'];

    for (const status of statuses) {
        console.log(`[PurchaseHistory] Fetching purchases with status: ${status}`);
        const purchases = await fetchPurchaseHistory(status);
        console.log(`[PurchaseHistory] Fetched ${purchases.length} items for status ${status}:`, purchases);
        renderPurchaseHistory(purchases, status);
    }
}
