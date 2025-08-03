// api/purchase.js
import { API_ENDPOINTS } from '../config.js';
import { getToken } from '../state.js';
import { renderPurchaseHistory } from '../ui.js';

export async function sendPurchase(item) {
    try {
        const res = await fetch(API_ENDPOINTS.purchases, {  // changed to plural "purchases"
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
        } else {
            // Optionally, you can parse and return the created purchase DTO if needed
            return await res.json();
        }
    } catch (err) {
        console.error("Purchase failed:", err);
    }
}

export async function fetchPurchaseHistory(status = 'ALL') {
    try {
        const url = new URL(API_ENDPOINTS.purchases);
        if (status) url.searchParams.set('status', status);

        const res = await fetch(url.toString(), {
            headers: {
                'Authorization': 'Bearer ' + getToken()
            }
        });

        const contentType = res.headers.get('Content-Type') || '';
        if (!res.ok) {
            const text = await res.text();
            console.error(`Failed to fetch purchase history [${res.status}]: ${text}`);
            return [];
        }

        if (!contentType.includes('application/json')) {
            const text = await res.text();
            console.error(`Unexpected response format: ${text}`);
            return [];
        }

        return await res.json();
    } catch (err) {
        console.error("Failed to fetch purchase history:", err);
        return [];
    }
}


