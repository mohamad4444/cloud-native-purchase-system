import { fetchPurchaseHistory } from './api/purchase.js';
import { renderPurchaseHistory } from './ui.js';

export async function loadAndRenderPurchaseHistoryByStatus() {
    const statuses = ['PENDING', 'CONFIRMED', 'REJECTED'];

    for (const status of statuses) {
        const purchases = await fetchPurchaseHistory(status);
        renderPurchaseHistory(purchases, status);
    }
}
