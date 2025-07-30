// api/purchase.js
import { API_ENDPOINTS } from '../config.js';
import { getToken } from '../state.js';
import { renderPurchaseHistory } from '../ui.js';

export async function sendPurchase(item) {
    try {
        const res = await fetch(API_ENDPOINTS.purchase, {
            method: 'POST',
            headers: {
                'Authorization': 'Bearer ' + getToken(),
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(item)
        });
        if (!res.ok) {
            const text = await res.text();
            console.error(`Purchase error: ${text}`);
        }
    } catch (err) {
        console.error("Purchase failed:", err);
    }
}

export async function fetchPurchaseHistory() {
    try {
        const res = await fetch(API_ENDPOINTS.purchases, {
            headers: { 'Authorization': 'Bearer ' + getToken() }
        });
        const history = await res.json();
        renderPurchaseHistory(history);
    } catch (err) {
        console.error("Failed to fetch purchase history:", err);
    }
}
