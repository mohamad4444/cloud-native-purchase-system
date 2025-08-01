import Keycloak from 'https://cdn.jsdelivr.net/npm/keycloak-js@26.2.0/+esm';
import { KEYCLOAK_CONFIG } from '../config.js';
import { setToken } from '../state.js';
import { updateLoginState } from '../ui.js';

export async function initAuth() {
    console.log('[auth] Starting initAuth');

    const keycloak = new Keycloak(KEYCLOAK_CONFIG);

    // Initialize Keycloak and attempt silent SSO login
    const authenticated = await keycloak.init({
        onLoad: 'check-sso',
        silentCheckSsoRedirectUri: window.location.origin + '/silent-check-sso.html',
        pkceMethod: 'S256',
        checkLoginIframe: false,
        redirectUri: window.location.origin,
        scope: KEYCLOAK_CONFIG.scope,
        flow: 'standard'
    });

    console.log('[auth] keycloak.init() resolved:', { authenticated, token: keycloak.token });

    if (authenticated && keycloak.token) {
        // Save token to sessionStorage for your app's state management
        sessionStorage.setItem('accessToken', keycloak.token);
        setToken(keycloak.token);
        updateLoginState(keycloak.tokenParsed?.preferred_username);

        // Setup token refresh before expiration
        setInterval(() => {
            keycloak.updateToken(30).then(refreshed => {
                if (refreshed) {
                    console.log('[auth] Token refreshed');
                    sessionStorage.setItem('accessToken', keycloak.token);
                    setToken(keycloak.token);
                } else {
                    console.log('[auth] Token still valid, no refresh needed');
                }
            }).catch(() => {
                console.log('[auth] Token refresh failed, logging out');
                keycloak.logout({ redirectUri: window.location.href });
            });
        }, 60000);

    } else {
        console.log('[auth] User NOT authenticated, clearing token and updating UI');
        sessionStorage.removeItem('accessToken');
        setToken('');
        updateLoginState(null);
    }

    return { keycloak, authenticated };
}
