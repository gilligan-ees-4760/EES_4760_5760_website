// Press V to View all fragments in current slide
// Press C to hide (Conceal) all fragments in current slide
const SkipFragments = (function (Reveal) {

    function showAll() {
        let {h, v} = Reveal.getIndices();
        Reveal.slide(h, v, +Infinity);
    }
    function hideAll() {
        let {h, v} = Reveal.getIndices();
        Reveal.slide(h, v, -1);
    }

    function installKeyBindings() {
        const config = Reveal.getConfig();
        if (!config.keyboard) {
            return;
        }
        const shortcut = {
            view: config.skipFragmentsShowShortcut || 'V',
            hide: config.skipFragmentsHideShortcut || 'C'
        };
        console.log("view = " + shortcut.view);
        console.log("hide = " + shortcut.hide);
        const keyboard = config.keyboard === true ? {} : config.keyboard;
        const shift_keyboard = config.shift_keyboard === true ? {} : config.shift_keyboard;
        const upper_shortcut = {
            view: shortcut.view.toUpperCase(),
            hide: shortcut.hide.toUpperCase()
        };
        console.log("upper view = " + upper_shortcut.view);
        console.log("upper hide = " + upper_shortcut.hide);
        if (shortcut.view === upper_shortcut.view) {
            console.log("Setting shift view " + upper_shortcut.view);
            shift_keyboard[upper_shortcut.view.charCodeAt(0)] = showAll;
        } else {
            console.log("Setting lower view " + shortcut.view);
            keyboard[upper_shortcut.view.charCodeAt(0)] = showAll;
        }
        if (shortcut.hide === upper_shortcut.hide) {
            console.log("Setting shift hide " + upper_shortcut.hide);
            shift_keyboard[upper_shortcut.hide.charCodeAt(0)] = hideAll;
        } else {
            console.log("Setting lower hide " + shortcut.hide);
            keyboard[upper_shortcut.hide.charCodeAt(0)] = hideAll;
        }

        Reveal.registerKeyboardShortcut(shortcut.view, 'View slide fragments');
        Reveal.registerKeyboardShortcut(shortcut.hide, 'Hide slide fragments');
        Reveal.configure({
            keyboard: keyboard,
            shift_keyboard: shift_keyboard
        });
    }

    function install() {
        installKeyBindings();
    }

    install();

    return {
        showAll: showAll,
        hideAll: hideAll
    };

})(Reveal);
