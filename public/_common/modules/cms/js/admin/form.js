Element.Methods.toggleOpen = function(element, target, openLabel, closeLabel) {
    if (!openLabel) {
        openLabel = "開く▼";
    }
    if (!closeLabel) {
        closeLabel = "閉じる▲";
    }
    if ($(target).getStyle('display') == 'none') {
        $(element).innerHTML = closeLabel;
    } else {
        $(element).innerHTML = openLabel;
    }
    $(target).toggle();
    return false;
};
Element.addMethods();
