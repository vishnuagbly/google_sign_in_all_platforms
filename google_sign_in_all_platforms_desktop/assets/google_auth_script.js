// Google Sign-In Authentication Script
// This script handles OAuth2 responses from both implicit flow (fragments) and authorization code flow (query parameters)
// It automatically processes the authentication data and sends it to the appropriate server endpoint

(function() {
    'use strict';
    
    /**
     * Parses URL fragment parameters
     * @param {string} fragment - The URL fragment (without the #)
     * @returns {Object} Parsed parameters as key-value pairs
     */
    function parseFragment(fragment) {
        const params = {};
        if (fragment) {
            fragment.split('&').forEach(param => {
                const [key, value] = param.split('=');
                if (key && value) {
                    params[decodeURIComponent(key)] = decodeURIComponent(value);
                }
            });
        }
        return params;
    }

    /**
     * Parses URL query parameters
     * @param {string} search - The URL query string (including the ?)
     * @returns {Object} Parsed parameters as key-value pairs
     */
    function parseQuery(search) {
        const params = new URLSearchParams(search);
        const result = {};
        for (const [key, value] of params) {
            result[key] = value;
        }
        return result;
    }

    /**
     * Sends token data to the server
     * @param {Object} tokenData - The token data to send
     * @returns {Promise<Response>} Fetch promise
     */
    function sendTokenToServer(tokenData) {
        return fetch('/token', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(tokenData)
        });
    }

    /**
     * Dispatches a custom event with authentication data
     * @param {string} eventName - Name of the event
     * @param {Object} data - Event data
     */
    function dispatchAuthEvent(eventName, data) {
        const event = new CustomEvent(eventName, {
            detail: data,
            bubbles: true,
            cancelable: true
        });
        document.dispatchEvent(event);
    }

    /**
     * Main authentication processing function
     */
    function processAuthentication() {
        const fragment = window.location.hash.substring(1);
        const search = window.location.search;

        console.log('Google Auth Script - Fragment:', fragment);
        console.log('Google Auth Script - Query:', search);

        if (fragment) {
            // Handle fragment-based response (implicit flow)
            const fragmentParams = parseFragment(fragment);
            console.log('Google Auth Script - Fragment params:', fragmentParams);

            if (fragmentParams.access_token) {
                // Dispatch event to notify the page about token processing
                dispatchAuthEvent('google-auth-token-processing', {
                    status: 'processing',
                    message: 'Processing access token...'
                });

                const tokenData = {
                    access_token: fragmentParams.access_token,
                    token_type: fragmentParams.token_type || 'Bearer',
                    expires_in: fragmentParams.expires_in ? parseInt(fragmentParams.expires_in) : null,
                    scope: fragmentParams.scope,
                    id_token: fragmentParams.id_token
                };

                sendTokenToServer(tokenData)
                    .then(response => {
                        if (response.ok) {
                            dispatchAuthEvent('google-auth-success', {
                                status: 'success',
                                message: 'Authentication successful! You may now close this tab.',
                                tokenData: tokenData
                            });
                        } else {
                            throw new Error('Server error: ' + response.status);
                        }
                    })
                    .catch(error => {
                        console.error('Google Auth Script - Failed to send token to server:', error);
                        dispatchAuthEvent('google-auth-error', {
                            status: 'error',
                            message: 'Failed to process token: ' + error.message,
                            error: error
                        });
                    });
            } else if (fragmentParams.error) {
                dispatchAuthEvent('google-auth-error', {
                    status: 'error',
                    message: `Error: ${fragmentParams.error} - ${fragmentParams.error_description || 'Unknown error'}`,
                    error: fragmentParams.error,
                    errorDescription: fragmentParams.error_description
                });
            } else {
                dispatchAuthEvent('google-auth-error', {
                    status: 'error',
                    message: 'Received fragment but no access token found.',
                    error: 'no_access_token'
                });
            }
        } else if (search) {
            // Handle query-based response (authorization code flow)
            const queryParams = parseQuery(search);
            console.log('Google Auth Script - Query params:', queryParams);

            if (queryParams.code) {
                dispatchAuthEvent('google-auth-success', {
                    status: 'success',
                    message: 'Authorization code received. You may now close this tab.',
                    code: queryParams.code,
                    state: queryParams.state
                });
                // For authorization code flow, the server already handles the token exchange
            } else if (queryParams.error) {
                dispatchAuthEvent('google-auth-error', {
                    status: 'error',
                    message: `Error: ${queryParams.error} - ${queryParams.error_description || 'Unknown error'}`,
                    error: queryParams.error,
                    errorDescription: queryParams.error_description
                });
            } else {
                dispatchAuthEvent('google-auth-error', {
                    status: 'error',
                    message: 'Received query parameters but no authorization code found.',
                    error: 'no_authorization_code'
                });
            }
        } else {
            dispatchAuthEvent('google-auth-error', {
                status: 'error',
                message: 'No authentication data received in URL.',
                error: 'no_auth_data'
            });
        }
    }

    // Auto-execute when the page loads
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', processAuthentication);
    } else {
        // Document already loaded
        processAuthentication();
    }

    // Expose functions globally for advanced usage
    window.GoogleAuthScript = {
        parseFragment: parseFragment,
        parseQuery: parseQuery,
        sendTokenToServer: sendTokenToServer,
        processAuthentication: processAuthentication
    };
})();
