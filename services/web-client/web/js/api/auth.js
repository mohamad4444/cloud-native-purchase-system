// api/auth.js
import Keycloak from 'https://cdn.jsdelivr.net/npm/keycloak-js@26.2.0/+esm';
import { KEYCLOAK_CONFIG } from '../config.js';
import { setToken } from '../state.js';
import { updateLoginState } from '../ui.js';

export async function initAuth() {
    const keycloak = new Keycloak(KEYCLOAK_CONFIG);

    const authenticated = await keycloak.init({
        pkceMethod: 'S256',
        checkLoginIframe: false,
        redirectUri: window.location.origin,
        scope: KEYCLOAK_CONFIG.scope
    });

    if (authenticated) {
        setToken(keycloak.token);
        updateLoginState(keycloak.tokenParsed?.preferred_username);
        setInterval(() => {
            keycloak.updateToken(30).then(refreshed => {
                if (refreshed) setToken(keycloak.token);
            }).catch(() => keycloak.logout({ redirectUri: window.location.href }));
        }, 60000);
    }

    return { keycloak, authenticated };
}
export async function callHello(url, token) {
    try {
        const res = await fetch(url, {
            headers: { 'Authorization': 'Bearer ' + token }
        });
        return await res.text();
    } catch (err) {
        console.error('Hello API error:', err);
        throw err;
    }
}
