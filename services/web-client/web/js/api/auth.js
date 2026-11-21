import { KEYCLOAK_CONFIG } from '../config.js';
import { setToken } from '../state.js';
import { updateLoginState } from '../ui.js';
import Keycloak from './lib/keycloak.js';

// Create the client eagerly so the Login button can be bound before the
// (potentially slow) silent-SSO check resolves.
export const keycloak = new Keycloak(KEYCLOAK_CONFIG);

export async function initAuth() {
    console.log('[auth] Starting initAuth');

    // Initialize Keycloak and attempt silent SSO login.
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
        sessionStorage.setItem('accessToken', keycloak.token);
        setToken(keycloak.token);
        updateLoginState(keycloak.tokenParsed?.preferred_username);

        setInterval(() => {
            keycloak.updateToken(30).then(refreshed => {
                if (refreshed) {
                    console.log('[auth] Token refreshed');
                    sessionStorage.setItem('accessToken', keycloak.token);
                    setToken(keycloak.token);
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
