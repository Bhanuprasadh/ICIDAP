const axios = require("axios");

const TARGET_URL = process.env.TARGET_URL || 'http://localhost:8000/events';

const EVENT_TYPES = ['login', 'purchase', 'page_view', 'error'];

async function sendEvent() {
    const type = EVENT_TYPES[Math.floor(Math.random() * EVENT_TYPES.length)];

    const payload = {
        type: type,
        timestamp: new Date().toISOString(),
        user_id: Math.floor(Math.random() * 1000)
    };

    try {
        await axios.post(TARGET_URL, payload);
        console.log(`[SUCCESS] Sent ${type} event`);
    } catch (error) {
        console.error(`[ERROR] Failed to send event: ${error.message}`);
    }
}

console.log(`Starting load generator targeting: ${TARGET_URL}`);
setInterval(sendEvent, 1000);