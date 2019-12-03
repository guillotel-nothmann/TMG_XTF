const listElement = document.querySelector('aside.mdc-drawer--modal');
const drawer = mdc.drawer.MDCDrawer.attachTo(listElement);

function getDrawer() {
    return drawer;
}


const getEditButtonElement = document.querySelector('.getEdit button');
getEditButtonElement.addEventListener('click', function () {
    const inputs = document.querySelectorAll('.getEdit input[type="checkbox"]');
    const data = {
    }
    for (const input of inputs) {
        data[input.name] = input.checked;
    }
    let url = new URLSearchParams(data);
    url = '/xtf/search?' + url.toString() + '&smode=setEdit';
    jQuery.ajax({
        url: url,
        success: function (result) {
            window.top.location.reload();
        }
    });
});