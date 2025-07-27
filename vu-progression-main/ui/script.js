// ==============================================================================
// FINAL DIAGNOSTIC (script.js)
// This script is filled with console logs to trace the execution flow.
// ==============================================================================

// This will appear in the console immediately if the .vuic file is loaded correctly.
console.log("--- UI SCRIPT LOG: script.js has loaded. ---");

const rankPopup = document.getElementById('rank-popup');
const rankTitle = document.getElementById('rank-title');
const rankImage = document.getElementById('rank-image');
const unlockedItem = document.getElementById('unlocked-item');

// This checks if the HTML elements actually exist.
if (rankPopup) {
    console.log("--- UI SCRIPT LOG: Successfully found the 'rank-popup' HTML element. ---");
} else {
    console.log("!!! UI SCRIPT ERROR: FAILED to find the 'rank-popup' HTML element! Check index.html. !!!");
}

// The function that Lua calls.
function showRankUp(rankName, rankImgUrl, itemName, soundPath) {
    // This is the most important log. If you see this, it means Lua is successfully talking to JavaScript.
    console.log("--- UI SCRIPT LOG: SUCCESS! The showRankUp() function was called from Lua. ---");
    console.log("--- DATA RECEIVED: Rank Name: " + rankName + ", Image: " + rankImgUrl + " ---");

    if (rankPopup && rankTitle && rankImage && unlockedItem) {
        console.log("--- UI SCRIPT LOG: All popup elements are valid. Displaying popup. ---");
        rankTitle.textContent = rankName;
        rankImage.src = rankImgUrl;
        unlockedItem.textContent = `Unlocked: ${itemName}`;
        rankPopup.classList.add('show');
        setTimeout(() => {
            rankPopup.classList.remove('show');
        }, 5000);
    } else {
        console.log("!!! UI SCRIPT ERROR: One or more popup elements were not found, cannot display. !!!");
    }
}

function showAttachmentUnlock(itemName, weaponName, soundPath) {
    console.log("--- UI SCRIPT LOG: SUCCESS! The showAttachmentUnlock() function was called from Lua. ---");
    // Implementation for attachment popups...
}

// The "bridge" that connects Lua to this JavaScript file.
engine.on('ShowRankUpPopup', showRankUp);
engine.on('ShowAttachmentUnlockPopup', showAttachmentUnlock);

console.log("--- UI SCRIPT LOG: Event listeners ('engine.on') are now active. Standing by for commands from Lua. ---");